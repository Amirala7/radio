import '../../../../core/pagination/page.dart';
import '../entities/station.dart';

abstract interface class StationRepository {
  Future<Page<Station>> listStations({int page = 1, int limit = 20});

  Future<Page<Station>> popularStations({
    String? country,
    int page = 1,
    int limit = 20,
  });

  Future<Page<Station>> searchStations({
    required String query,
    int page = 1,
    int limit = 20,
  });

  Future<Page<Station>> stationsByGenre({
    int? genreId,
    String? genreSlug,
    int page = 1,
    int limit = 20,
  });
}
