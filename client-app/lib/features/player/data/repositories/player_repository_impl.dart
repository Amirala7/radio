import 'dart:async';

import '../../../../core/errors/failures.dart';
import '../../../stations/domain/entities/radio_stream.dart';
import '../../../stations/domain/entities/station.dart';
import '../../domain/entities/playback_state.dart';
import '../../domain/pick_best_stream.dart';
import '../../domain/repositories/player_repository.dart';
import '../datasources/audio_player_data_source.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  PlayerRepositoryImpl(this._dataSource) {
    _subscription = _dataSource.events.listen(_onSnapshot);
  }

  final AudioPlayerDataSource _dataSource;
  final StreamController<PlaybackState> _state =
      StreamController<PlaybackState>.broadcast();
  late final StreamSubscription<RawPlayerSnapshot> _subscription;

  PlaybackState _current = const PlaybackState();
  Station? _currentStation;
  RadioStream? _currentStream;

  // Token bumped on every play() and cleared once that call's
  // setSourceAndPlay resolves. While `_pending > _completed`, snapshots
  // from the data source describe the *previous* source (just_audio keeps
  // ticking ready+playing for the old URL until the new source takes
  // effect) — dropping them prevents the LCD from flashing back to LIVE
  // before the new station has actually started tuning.
  int _pending = 0;
  int _completed = 0;
  bool get _switching => _pending > _completed;

  @override
  Stream<PlaybackState> get state => _state.stream;

  @override
  Future<void> play(Station station) async {
    final picked = pickBestStream(station.streams);
    if (picked == null) {
      _currentStation = station;
      _currentStream = null;
      _emit(
        _current.copyWith(
          status: PlaybackStatus.error,
          currentStation: station,
          currentStream: null,
          error: const UnknownFailure('no playable streams'),
        ),
      );
      return;
    }
    _currentStation = station;
    _currentStream = picked;
    final token = ++_pending;
    _emit(
      _current.copyWith(
        status: PlaybackStatus.loading,
        currentStation: station,
        currentStream: picked,
        error: null,
      ),
    );
    try {
      await _dataSource.setSourceAndPlay(
        id: station.id.toString(),
        url: picked.url,
        title: station.name,
        artUrl: station.logo,
      );
    } finally {
      if (token > _completed) _completed = token;
    }
  }

  @override
  Future<void> pause() => _dataSource.pause();

  @override
  Future<void> resume() => _dataSource.resume();

  @override
  Future<void> stop() => _dataSource.stop();

  @override
  Future<void> setVolume(double volume) =>
      _dataSource.setVolume(volume.clamp(0.0, 1.0));

  Future<void> dispose() async {
    await _subscription.cancel();
    await _state.close();
  }

  void _onSnapshot(RawPlayerSnapshot snap) {
    if (snap.errorMessage != null) {
      _emit(
        _current.copyWith(
          status: PlaybackStatus.error,
          currentStation: _currentStation,
          currentStream: _currentStream,
          position: snap.position,
          bufferedPosition: snap.bufferedPosition,
          isBuffering: false,
          error: UnknownFailure(snap.errorMessage!),
        ),
      );
      return;
    }
    // Drop snapshots that describe the previous source while a station
    // switch is in flight. Keep emitting errors above so failures aren't
    // hidden by the gate.
    if (_switching) return;
    final isBuffering = snap.processingState == RawProcessingState.buffering;
    final status = _statusFor(snap);
    _emit(
      _current.copyWith(
        status: status,
        currentStation: _currentStation,
        currentStream: _currentStream,
        position: snap.position,
        bufferedPosition: snap.bufferedPosition,
        isBuffering: isBuffering,
        error: null,
      ),
    );
  }

  PlaybackStatus _statusFor(RawPlayerSnapshot snap) {
    switch (snap.processingState) {
      case RawProcessingState.idle:
        return PlaybackStatus.idle;
      case RawProcessingState.loading:
        return PlaybackStatus.loading;
      case RawProcessingState.buffering:
        // For HTTP/ICY radio streams, just_audio keeps reporting
        // `buffering` even after audio becomes audible — it's just
        // topping up the network buffer. Once `playing` flips true,
        // surface this as playing so the tuning loop can stop.
        return snap.playing ? PlaybackStatus.playing : PlaybackStatus.loading;
      case RawProcessingState.ready:
        return snap.playing ? PlaybackStatus.playing : PlaybackStatus.paused;
      case RawProcessingState.completed:
        return PlaybackStatus.idle;
    }
  }

  void _emit(PlaybackState s) {
    _current = s;
    _state.add(s);
  }
}
