import '../repositories/player_repository.dart';

class PauseUseCase {
  PauseUseCase(this._repository);

  final PlayerRepository _repository;

  Future<void> call() => _repository.pause();
}
