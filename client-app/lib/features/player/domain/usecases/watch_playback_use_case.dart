import '../entities/playback_state.dart';
import '../repositories/player_repository.dart';

class WatchPlaybackUseCase {
  WatchPlaybackUseCase(this._repository);

  final PlayerRepository _repository;

  Stream<PlaybackState> call() => _repository.state;
}
