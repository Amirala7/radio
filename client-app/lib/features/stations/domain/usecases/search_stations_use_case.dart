import '../../../../core/pagination/page.dart';
import '../entities/station.dart';
import '../repositories/station_repository.dart';

class SearchStationsUseCase {
  SearchStationsUseCase(this._repository);

  final StationRepository _repository;

  Future<Page<Station>> call({
    required String query,
    int page = 1,
    int limit = 20,
  }) async =>
      _repository.searchStations(query: query, page: page, limit: limit);
}
