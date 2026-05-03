import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_meta.dart';
import 'package:radio/features/genres/domain/entities/genre.dart';
import 'package:radio/features/genres/domain/repositories/genre_repository.dart';
import 'package:radio/features/genres/domain/usecases/list_genres_use_case.dart';

class _MockRepo extends Mock implements GenreRepository {}

void main() {
  late _MockRepo repo;
  late ListGenresUseCase useCase;

  const page = Page<Genre>(
    data: [Genre(id: 1)],
    meta: PageMeta(page: 1, limit: 100),
  );

  setUp(() {
    repo = _MockRepo();
    useCase = ListGenresUseCase(repo);
  });

  test('forwards page and limit, returns repo result', () async {
    when(() => repo.listGenres(page: 2, limit: 50))
        .thenAnswer((_) async => page);
    final result = await useCase(page: 2, limit: 50);
    expect(result.data.first.id, 1);
  });

  test('propagates failures', () async {
    when(() => repo.listGenres(page: 1, limit: 100))
        .thenThrow(const NetworkFailure());
    await expectLater(useCase(), throwsA(isA<NetworkFailure>()));
  });
}
