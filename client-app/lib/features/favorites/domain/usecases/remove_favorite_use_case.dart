import '../repositories/favorites_repository.dart';

class RemoveFavoriteUseCase {
  RemoveFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(int stationId) => _repository.remove(stationId);
}
