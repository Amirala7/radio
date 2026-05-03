import '../../../../core/pagination/page.dart';
import '../entities/genre.dart';

abstract interface class GenreRepository {
  Future<Page<Genre>> listGenres({int page = 1, int limit = 100});
}
