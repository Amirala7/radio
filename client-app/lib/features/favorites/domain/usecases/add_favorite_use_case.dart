import '../../../stations/domain/entities/station.dart';
import '../repositories/favorites_repository.dart';

class AddFavoriteUseCase {
  AddFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(Station station) async => _repository.add(station);
}
