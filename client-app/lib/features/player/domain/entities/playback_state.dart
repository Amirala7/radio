import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../../stations/domain/entities/radio_stream.dart';
import '../../../stations/domain/entities/station.dart';

part 'playback_state.freezed.dart';

enum PlaybackStatus { idle, loading, playing, paused, error }

@freezed
abstract class PlaybackState with _$PlaybackState {
  const factory PlaybackState({
    @Default(PlaybackStatus.idle) PlaybackStatus status,
    Station? currentStation,
    RadioStream? currentStream,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration bufferedPosition,
    @Default(false) bool isBuffering,
    AppFailure? error,
  }) = _PlaybackState;
}
