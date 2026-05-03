import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/core/pagination/page_dto.dart';
import 'package:radio/core/pagination/page_meta_dto.dart';
import 'package:radio/features/genres/data/datasources/genre_remote_data_source.dart';
import 'package:radio/features/genres/data/models/genre_dto.dart';
import 'package:radio/features/genres/data/repositories/genre_repository_impl.dart';

class _MockDataSource extends Mock implements GenreRemoteDataSource {}

void main() {
  late _MockDataSource ds;
  late GenreRepositoryImpl repo;

  const samplePage = PageDto<GenreDto>(
    data: [GenreDto(id: 1, slug: 'rock', name: 'Rock')],
    meta: PageMetaDto(page: 1, limit: 100),
  );

  setUp(() {
    ds = _MockDataSource();
    repo = GenreRepositoryImpl(ds);
  });

  test('returns mapped Page<Genre> on success', () async {
    when(() => ds.listGenres(page: 1, limit: 100))
        .thenAnswer((_) async => samplePage);
    final page = await repo.listGenres();
    expect(page.data.first.id, 1);
    expect(page.data.first.name, 'Rock');
  });

  test('maps unauthenticated to UnauthenticatedFailure', () async {
    when(() => ds.listGenres(page: 1, limit: 100)).thenThrow(
      FirebaseFunctionsException(message: '', code: 'unauthenticated'),
    );
    await expectLater(repo.listGenres(), throwsA(isA<UnauthenticatedFailure>()));
  });

  test('maps unavailable to NetworkFailure', () async {
    when(() => ds.listGenres(page: 1, limit: 100)).thenThrow(
      FirebaseFunctionsException(message: '', code: 'unavailable'),
    );
    await expectLater(repo.listGenres(), throwsA(isA<NetworkFailure>()));
  });

  test('maps arbitrary exceptions to UnknownFailure', () async {
    when(() => ds.listGenres(page: 1, limit: 100))
        .thenThrow(StateError('boom'));
    await expectLater(repo.listGenres(), throwsA(isA<UnknownFailure>()));
  });
}
