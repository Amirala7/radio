import '../../../../core/pagination/page.dart';
import '../entities/genre.dart';
import '../repositories/genre_repository.dart';

class ListGenresUseCase {
  ListGenresUseCase(this._repository);

  final GenreRepository _repository;

  Future<Page<Genre>> call({int page = 1, int limit = 100}) async =>
      _repository.listGenres(page: page, limit: limit);
}
