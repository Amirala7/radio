import 'package:cloud_functions/cloud_functions.dart';

import '../../../../core/network/cloud_functions_client.dart';
import '../../../../core/pagination/page_dto.dart';
import '../models/station_dto.dart';

class StationRemoteDataSource {
  StationRemoteDataSource(this._client);

  final CloudFunctionsClient _client;

  Future<PageDto<StationDto>> listStations({int page = 1, int limit = 20}) =>
      _callPage('listStations', {'page': page, 'limit': limit});

  Future<PageDto<StationDto>> popularStations({
    String? country,
    int page = 1,
    int limit = 20,
  }) => _callPage('popularStations', {
    'country': ?country,
    'page': page,
    'limit': limit,
  });

  Future<PageDto<StationDto>> searchStations({
    required String query,
    int page = 1,
    int limit = 20,
  }) => _callPage('searchStations', {'q': query, 'page': page, 'limit': limit});

  Future<PageDto<StationDto>> stationsByGenre({
    int? genreId,
    String? genreSlug,
    int page = 1,
    int limit = 20,
  }) => _callPage('stationsByGenre', {
    'genreId': ?genreId,
    'genreSlug': ?genreSlug,
    'page': page,
    'limit': limit,
  });

  Future<PageDto<StationDto>> _callPage(
    String name,
    Map<String, Object?> args,
  ) async {
    final HttpsCallableResult<Object?> result = await _client
        .call(name)
        .call<Object?>(args);
    final json = _asJsonMap(result.data);
    return PageDto<StationDto>.fromJson(
      json,
      (v) => StationDto.fromJson(_asJsonMap(v)),
    );
  }

  Map<String, dynamic> _asJsonMap(Object? raw) {
    if (raw is Map) return raw.cast<String, dynamic>();
    throw StateError(
      'Expected a Map from cloud function, got ${raw.runtimeType}',
    );
  }
}
