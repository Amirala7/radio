import '../../../../core/pagination/page.dart';
import '../entities/station.dart';
import '../repositories/station_repository.dart';

class GetPopularStationsUseCase {
  GetPopularStationsUseCase(this._repository);

  final StationRepository _repository;

  Future<Page<Station>> call({
    String? country,
    int page = 1,
    int limit = 20,
  }) async =>
      _repository.popularStations(country: country, page: page, limit: limit);
}
