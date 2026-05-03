import '../repositories/player_repository.dart';

class ResumeUseCase {
  ResumeUseCase(this._repository);

  final PlayerRepository _repository;

  Future<void> call() => _repository.resume();
}
