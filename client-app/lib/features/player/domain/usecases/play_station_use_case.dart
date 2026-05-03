import '../../../stations/domain/entities/station.dart';
import '../repositories/player_repository.dart';

class PlayStationUseCase {
  PlayStationUseCase(this._repository);

  final PlayerRepository _repository;

  Future<void> call(Station station) => _repository.play(station);
}
