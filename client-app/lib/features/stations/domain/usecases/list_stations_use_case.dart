import '../../../../core/pagination/page.dart';
import '../entities/station.dart';
import '../repositories/station_repository.dart';

class ListStationsUseCase {
  ListStationsUseCase(this._repository);

  final StationRepository _repository;

  Future<Page<Station>> call({int page = 1, int limit = 20}) =>
      _repository.listStations(page: page, limit: limit);
}
