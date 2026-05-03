import '../entities/favorite_station.dart';
import '../repositories/favorites_repository.dart';

class WatchFavoritesUseCase {
  WatchFavoritesUseCase(this._repository);

  final FavoritesRepository _repository;

  Stream<List<FavoriteStation>> call() => _repository.watchAll();
}
