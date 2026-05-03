import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../stations/domain/entities/station.dart';
import '../../domain/entities/playback_state.dart';
import '../../domain/usecases/pause_use_case.dart';
import '../../domain/usecases/play_station_use_case.dart';
import '../../domain/usecases/resume_use_case.dart';
import '../../domain/usecases/stop_use_case.dart';
import '../../domain/usecases/watch_playback_use_case.dart';

class PlayerViewModel extends ChangeNotifier {
  PlayerViewModel({
    required WatchPlaybackUseCase watchPlayback,
    required PlayStationUseCase playStation,
    required PauseUseCase pause,
    required ResumeUseCase resume,
    required StopUseCase stop,
  })  : _playStation = playStation,
        _pause = pause,
        _resume = resume,
        _stop = stop {
    _subscription = watchPlayback().listen((s) {
      if (_disposed) return;
      _state = s;
      notifyListeners();
    });
  }

  final PlayStationUseCase _playStation;
  final PauseUseCase _pause;
  final ResumeUseCase _resume;
  final StopUseCase _stop;

  late final StreamSubscription<PlaybackState> _subscription;
  bool _disposed = false;

  PlaybackState _state = const PlaybackState();
  PlaybackState get state => _state;

  bool get isPlaying => _state.status == PlaybackStatus.playing;
  bool get isPaused => _state.status == PlaybackStatus.paused;
  bool get isLoading =>
      _state.status == PlaybackStatus.loading || _state.isBuffering;
  bool get hasError => _state.status == PlaybackStatus.error;
  Station? get currentStation => _state.currentStation;

  Future<void> play(Station station) => _playStation(station);
  Future<void> pause() => _pause();
  Future<void> resume() => _resume();
  Future<void> stop() => _stop();

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _subscription.cancel();
    super.dispose();
  }
}
