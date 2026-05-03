import '../repositories/favorites_repository.dart';

class IsFavoriteUseCase {
  IsFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Stream<bool> call(int stationId) => _repository.isFavorite(stationId);
}
