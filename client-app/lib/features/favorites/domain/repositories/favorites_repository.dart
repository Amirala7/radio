import '../../../stations/domain/entities/station.dart';
import '../entities/favorite_station.dart';

abstract interface class FavoritesRepository {
  Stream<List<FavoriteStation>> watchAll();

  Stream<bool> isFavorite(int stationId);

  Future<void> add(Station station);

  Future<void> remove(int stationId);
}
