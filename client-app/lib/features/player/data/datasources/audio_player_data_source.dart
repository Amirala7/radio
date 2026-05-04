import 'dart:async';

import 'package:just_audio/just_audio.dart';

import 'radio_audio_handler.dart';

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

/// Adapts the [RadioAudioHandler]'s underlying `just_audio` player into
/// the [RawPlayerSnapshot] stream the player repository consumes.
///
/// Why this is a thin facade over the handler rather than owning the
/// player itself: lock-screen / notification metadata is driven via
/// `audio_service`, which requires the player to live inside a
/// `BaseAudioHandler`. Splitting concerns keeps the handler focused on
/// platform integration and leaves the snapshot mapping (the contract
/// the repo depends on) right here.
class AudioPlayerDataSource {
  AudioPlayerDataSource(this._handler) {
    _attach();
  }

  final RadioAudioHandler _handler;
  AudioPlayer get _player => _handler.player;

  final StreamController<RawPlayerSnapshot> _events =
      StreamController<RawPlayerSnapshot>.broadcast();

  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _bufferedSub;
  StreamSubscription<PlaybackEvent>? _eventSub;

  PlayerState _state = PlayerState(false, ProcessingState.idle);
  Duration _position = Duration.zero;
  Duration _buffered = Duration.zero;
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
      await _handler.openStation(
        id: id,
        url: url,
        title: title,
        artUrl: artUrl,
      );
    } catch (e) {
      _lastError = e.toString();
      _emit();
    }
  }

  Future<void> pause() => _handler.pause();

  Future<void> resume() => _handler.play();

  Future<void> stop() async {
    await _handler.stop();
    // After stop just_audio holds onto the source in `idle` processing
    // state but `playing` flips to false. The repo treats that as idle,
    // so the next power tap re-runs setSourceAndPlay() rather than
    // attempting resume() on a torn-down stream.
    _emit();
  }

  Future<void> setVolume(double v) => _handler.setVolume(v);

  /// Re-emit the current state. Pulls `playerState` synchronously so the
  /// snapshot reflects the latest just_audio state even when the
  /// playerStateStream listener hasn't caught up yet.
  ///
  /// Used by the repository immediately after the station-switch gate
  /// drops: fast-prepared streams reach ready+playing entirely inside
  /// setAudioSource's await, so every state event was gated and dropped.
  /// just_audio doesn't re-emit when state is stable, so without this
  /// nudge the repo would stay on loading forever.
  void refresh() {
    _state = _player.playerState;
    _emit();
  }

  Future<void> dispose() async {
    await _stateSub?.cancel();
    await _positionSub?.cancel();
    await _bufferedSub?.cancel();
    await _eventSub?.cancel();
    await _events.close();
    // Player lifetime is owned by the handler (process-singleton via
    // AudioService.init). Don't dispose it here.
  }

  void _attach() {
    _stateSub = _player.playerStateStream.listen((s) {
      _state = s;
      _emit();
    });
    _positionSub = _player.positionStream.listen((p) {
      _position = p;
    });
    _bufferedSub = _player.bufferedPositionStream.listen((b) {
      _buffered = b;
    });
    _eventSub = _player.playbackEventStream.listen(
      (_) {},
      onError: (Object e, StackTrace _) {
        _lastError = e.toString();
        _emit();
      },
    );
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
