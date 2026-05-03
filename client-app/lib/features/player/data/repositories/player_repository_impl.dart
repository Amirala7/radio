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

  @override
  Stream<PlaybackState> get state => _state.stream;

  @override
  Future<void> play(Station station) async {
    final picked = pickBestStream(station.streams);
    if (picked == null) {
      _currentStation = station;
      _currentStream = null;
      _emit(_current.copyWith(
        status: PlaybackStatus.error,
        currentStation: station,
        currentStream: null,
        error: const UnknownFailure('no playable streams'),
      ));
      return;
    }
    _currentStation = station;
    _currentStream = picked;
    _emit(_current.copyWith(
      status: PlaybackStatus.loading,
      currentStation: station,
      currentStream: picked,
      error: null,
    ));
    await _dataSource.setUrlAndPlay(picked.url);
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
      _emit(_current.copyWith(
        status: PlaybackStatus.error,
        currentStation: _currentStation,
        currentStream: _currentStream,
        position: snap.position,
        bufferedPosition: snap.bufferedPosition,
        isBuffering: false,
        error: UnknownFailure(snap.errorMessage!),
      ));
      return;
    }
    final isBuffering =
        snap.processingState == RawProcessingState.buffering;
    final status = _statusFor(snap);
    _emit(_current.copyWith(
      status: status,
      currentStation: _currentStation,
      currentStream: _currentStream,
      position: snap.position,
      bufferedPosition: snap.bufferedPosition,
      isBuffering: isBuffering,
      error: null,
    ));
  }

  PlaybackStatus _statusFor(RawPlayerSnapshot snap) {
    switch (snap.processingState) {
      case RawProcessingState.idle:
        return PlaybackStatus.idle;
      case RawProcessingState.loading:
      case RawProcessingState.buffering:
        return PlaybackStatus.loading;
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
