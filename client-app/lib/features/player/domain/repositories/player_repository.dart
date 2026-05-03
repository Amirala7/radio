import '../../../stations/domain/entities/station.dart';
import '../entities/playback_state.dart';

abstract interface class PlayerRepository {
  Stream<PlaybackState> get state;

  Future<void> play(Station station);

  Future<void> pause();

  Future<void> resume();

  Future<void> stop();

  Future<void> setVolume(double volume);
}
