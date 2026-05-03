import 'dart:async';

import 'package:just_audio/just_audio.dart';

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

  Future<void> setUrlAndPlay(String url) async {
    _lastError = null;
    try {
      await _player.setUrl(url);
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
