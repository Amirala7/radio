import 'package:cloud_functions/cloud_functions.dart';

import '../../../../core/network/cloud_functions_client.dart';
import '../../../../core/pagination/page_dto.dart';
import '../models/genre_dto.dart';

class GenreRemoteDataSource {
  GenreRemoteDataSource(this._client);

  final CloudFunctionsClient _client;

  Future<PageDto<GenreDto>> listGenres({
    int page = 1,
    int limit = 100,
  }) async {
    final HttpsCallableResult<Object?> result =
        await _client.call('listGenres').call<Object?>({
      'page': page,
      'limit': limit,
    });
    final json = (result.data! as Map).cast<String, dynamic>();
    return PageDto<GenreDto>.fromJson(
      json,
      (v) => GenreDto.fromJson((v! as Map).cast<String, dynamic>()),
    );
  }
}
