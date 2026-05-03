import '../../../../core/pagination/page.dart';
import '../entities/station.dart';
import '../repositories/station_repository.dart';

class GetStationsByGenreUseCase {
  GetStationsByGenreUseCase(this._repository);

  final StationRepository _repository;

  Future<Page<Station>> call({
    int? genreId,
    String? genreSlug,
    int page = 1,
    int limit = 20,
  }) =>
      _repository.stationsByGenre(
        genreId: genreId,
        genreSlug: genreSlug,
        page: page,
        limit: limit,
      );
}
