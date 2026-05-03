import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/pagination/page.dart';
import '../../../../core/pagination/page_mapper.dart';
import '../../domain/entities/station.dart';
import '../../domain/repositories/station_repository.dart';
import '../datasources/station_remote_data_source.dart';
import '../mappers/station_mapper.dart';

class StationRepositoryImpl implements StationRepository {
  StationRepositoryImpl(this._dataSource);

  final StationRemoteDataSource _dataSource;

  @override
  Future<Page<Station>> listStations({int page = 1, int limit = 20}) =>
      _guarded(() async {
        final dto = await _dataSource.listStations(page: page, limit: limit);
        return dto.toEntity((s) => s.toEntity());
      });

  @override
  Future<Page<Station>> popularStations({
    String? country,
    int page = 1,
    int limit = 20,
  }) => _guarded(() async {
    final dto = await _dataSource.popularStations(
      country: country,
      page: page,
      limit: limit,
    );
    return dto.toEntity((s) => s.toEntity());
  });

  @override
  Future<Page<Station>> searchStations({
    required String query,
    int page = 1,
    int limit = 20,
  }) => _guarded(() async {
    final dto = await _dataSource.searchStations(
      query: query,
      page: page,
      limit: limit,
    );
    return dto.toEntity((s) => s.toEntity());
  });

  @override
  Future<Page<Station>> stationsByGenre({
    int? genreId,
    String? genreSlug,
    int page = 1,
    int limit = 20,
  }) => _guarded(() async {
    final dto = await _dataSource.stationsByGenre(
      genreId: genreId,
      genreSlug: genreSlug,
      page: page,
      limit: limit,
    );
    return dto.toEntity((s) => s.toEntity());
  });

  Future<T> _guarded<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e) {
      throw mapException(e);
    }
  }
}
