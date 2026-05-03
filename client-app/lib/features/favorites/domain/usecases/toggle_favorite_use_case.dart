import '../../../stations/domain/entities/station.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  ToggleFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(Station station) async {
    final isFav = await _repository.isFavorite(station.id).first;
    if (isFav) {
      await _repository.remove(station.id);
    } else {
      await _repository.add(station);
    }
  }
}
