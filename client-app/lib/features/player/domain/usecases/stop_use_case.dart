import '../repositories/player_repository.dart';

class StopUseCase {
  StopUseCase(this._repository);

  final PlayerRepository _repository;

  Future<void> call() => _repository.stop();
}
