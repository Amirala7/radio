import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/core/pagination/page_dto.dart';
import 'package:radio/core/pagination/page_meta_dto.dart';
import 'package:radio/features/stations/data/datasources/station_remote_data_source.dart';
import 'package:radio/features/stations/data/models/station_dto.dart';
import 'package:radio/features/stations/data/repositories/station_repository_impl.dart';

class _MockDataSource extends Mock implements StationRemoteDataSource {}

void main() {
  late _MockDataSource ds;
  late StationRepositoryImpl repo;

  const sampleDto = StationDto(id: 1, name: 'X', streams: []);
  const samplePage = PageDto<StationDto>(
    data: [sampleDto],
    meta: PageMetaDto(page: 1, limit: 20),
  );

  setUp(() {
    ds = _MockDataSource();
    repo = StationRepositoryImpl(ds);
  });

  group('listStations', () {
    test('returns mapped Page<Station> on success', () async {
      when(() => ds.listStations(page: 1, limit: 20))
          .thenAnswer((_) async => samplePage);

      final page = await repo.listStations();

      expect(page.data.first.id, 1);
      expect(page.data.first.name, 'X');
      expect(page.meta.page, 1);
    });

    test('maps unauthenticated to UnauthenticatedFailure', () async {
      when(() => ds.listStations(page: 1, limit: 20)).thenThrow(
        FirebaseFunctionsException(message: 'no auth', code: 'unauthenticated'),
      );
      await expectLater(
        repo.listStations(),
        throwsA(isA<UnauthenticatedFailure>()),
      );
    });

    test('maps invalid-argument to InvalidArgumentFailure', () async {
      when(() => ds.listStations(page: 1, limit: 20)).thenThrow(
        FirebaseFunctionsException(message: 'bad', code: 'invalid-argument'),
      );
      await expectLater(
        repo.listStations(),
        throwsA(isA<InvalidArgumentFailure>()),
      );
    });

    test('maps unavailable to NetworkFailure', () async {
      when(() => ds.listStations(page: 1, limit: 20)).thenThrow(
        FirebaseFunctionsException(message: '', code: 'unavailable'),
      );
      await expectLater(
        repo.listStations(),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('maps arbitrary exceptions to UnknownFailure', () async {
      when(() => ds.listStations(page: 1, limit: 20))
          .thenThrow(StateError('boom'));
      await expectLater(
        repo.listStations(),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  group('popularStations', () {
    test('forwards country and pagination, returns mapped page', () async {
      when(() => ds.popularStations(country: 'GB', page: 2, limit: 10))
          .thenAnswer((_) async => samplePage);
      final page = await repo.popularStations(country: 'GB', page: 2, limit: 10);
      expect(page.data.first.id, 1);
      verify(() => ds.popularStations(country: 'GB', page: 2, limit: 10))
          .called(1);
    });
  });

  group('searchStations', () {
    test('forwards query and returns mapped page', () async {
      when(() => ds.searchStations(query: 'jazz', page: 1, limit: 20))
          .thenAnswer((_) async => samplePage);
      final page = await repo.searchStations(query: 'jazz');
      expect(page.data, isNotEmpty);
      verify(() => ds.searchStations(query: 'jazz', page: 1, limit: 20))
          .called(1);
    });
  });

  group('stationsByGenre', () {
    test('forwards genreId and returns mapped page', () async {
      when(() =>
              ds.stationsByGenre(genreId: 5, page: 1, limit: 20))
          .thenAnswer((_) async => samplePage);
      final page = await repo.stationsByGenre(genreId: 5);
      expect(page.data, isNotEmpty);
    });

    test('forwards genreSlug and returns mapped page', () async {
      when(() => ds.stationsByGenre(
            genreSlug: 'rock',
            page: 1,
            limit: 20,
          )).thenAnswer((_) async => samplePage);
      final page = await repo.stationsByGenre(genreSlug: 'rock');
      expect(page.data, isNotEmpty);
    });
  });
}
