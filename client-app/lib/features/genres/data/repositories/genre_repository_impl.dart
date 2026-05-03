import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/pagination/page.dart';
import '../../../../core/pagination/page_mapper.dart';
import '../../domain/entities/genre.dart';
import '../../domain/repositories/genre_repository.dart';
import '../datasources/genre_remote_data_source.dart';
import '../mappers/genre_mapper.dart';

class GenreRepositoryImpl implements GenreRepository {
  GenreRepositoryImpl(this._dataSource);

  final GenreRemoteDataSource _dataSource;

  @override
  Future<Page<Genre>> listGenres({int page = 1, int limit = 100}) async {
    try {
      final dto = await _dataSource.listGenres(page: page, limit: limit);
      return dto.toEntity((g) => g.toEntity());
    } catch (e) {
      throw mapException(e);
    }
  }
}
