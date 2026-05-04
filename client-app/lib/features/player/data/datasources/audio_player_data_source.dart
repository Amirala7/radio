import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

enum RawProcessingState { idle, loading, buffering, ready, completed }

class RawPlayerSnapshot {
  const RawPlayerSnapshot({
    required this.processingState,
    required this.playing,
    required this.position,
    required this.bufferedPosition,
    this.errorMessage,
  });

  final RawProcessingState processingState;
  final bool playing;
  final Duration position;
  final Duration bufferedPosition;
  final String? errorMessage;
}

/// Thin wrapper over [AudioPlayer]. Catches just_audio errors and emits them
/// as [RawPlayerSnapshot] entries with `errorMessage` set, rather than throwing.
class AudioPlayerDataSource {
  AudioPlayerDataSource({AudioPlayer? player})
    : _player = player ?? AudioPlayer() {
    _attach();
  }

  final AudioPlayer _player;
  final StreamController<RawPlayerSnapshot> _events =
      StreamController<RawPlayerSnapshot>.broadcast();

  Duration _position = Duration.zero;
  Duration _buffered = Duration.zero;
  PlayerState _state = PlayerState(false, ProcessingState.idle);
  String? _lastError;

  Stream<RawPlayerSnapshot> get events => _events.stream;

  Future<void> setSourceAndPlay({
    required String id,
    required String url,
    required String title,
    String? artUrl,
  }) async {
    _lastError = null;
    try {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          tag: MediaItem(
            id: id,
            title: title,
            artUri: (artUrl != null && artUrl.isNotEmpty)
                ? Uri.tryParse(artUrl)
                : null,
          ),
        ),
      );
    } on PlayerException catch (e) {
      _lastError = e.message ?? 'PlayerException(${e.code})';
      _emit();
      return;
    } on PlayerInterruptedException catch (e) {
      _lastError = e.message ?? 'PlayerInterruptedException';
      _emit();
      return;
    } catch (e) {
      _lastError = e.toString();
      _emit();
      return;
    }
    // For live streams, _player.play() returns a Future that only resolves
    // when playback ends (i.e. stop() is called). Awaiting it would block
    // setSourceAndPlay forever and freeze any caller relying on its completion
    // (e.g. the repo's switch-token gate). Fire-and-forget with separate
    // error handling.
    unawaited(_safePlay());
  }

  Future<void> _safePlay() async {
    try {
      await _player.play();
    } on PlayerException catch (e) {
      _lastError = e.message ?? 'PlayerException(${e.code})';
      _emit();
    } on PlayerInterruptedException catch (e) {
      _lastError = e.message ?? 'PlayerInterruptedException';
      _emit();
    } catch (e) {
      _lastError = e.toString();
      _emit();
    }
  }

  Future<void> pause() => _player.pause();

  Future<void> resume() => _player.play();

  Future<void> stop() => _player.stop();

  Future<void> setVolume(double v) => _player.setVolume(v.clamp(0.0, 1.0));

  Future<void> dispose() async {
    await _events.close();
    await _player.dispose();
  }

  void _attach() {
    _player.playerStateStream.listen((s) {
      _state = s;
      _emit();
    });
    _player.positionStream.listen((p) {
      _position = p;
      _emit();
    });
    _player.bufferedPositionStream.listen((p) {
      _buffered = p;
      _emit();
    });
  }

  void _emit() {
    _events.add(
      RawPlayerSnapshot(
        processingState: _mapProcessingState(_state.processingState),
        playing: _state.playing,
        position: _position,
        bufferedPosition: _buffered,
        errorMessage: _lastError,
      ),
    );
  }

  RawProcessingState _mapProcessingState(ProcessingState s) {
    switch (s) {
      case ProcessingState.idle:
        return RawProcessingState.idle;
      case ProcessingState.loading:
        return RawProcessingState.loading;
      case ProcessingState.buffering:
        return RawProcessingState.buffering;
      case ProcessingState.ready:
        return RawProcessingState.ready;
      case ProcessingState.completed:
        return RawProcessingState.completed;
    }
  }
}
