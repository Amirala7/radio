import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_meta.dart';
import 'package:radio/features/stations/domain/entities/station.dart';
import 'package:radio/features/stations/domain/repositories/station_repository.dart';
import 'package:radio/features/stations/domain/usecases/get_stations_by_genre_use_case.dart';

class _MockRepo extends Mock implements StationRepository {}

void main() {
  late _MockRepo repo;
  late GetStationsByGenreUseCase useCase;
  const page = Page<Station>(data: [], meta: PageMeta(page: 1, limit: 20));

  setUp(() {
    repo = _MockRepo();
    useCase = GetStationsByGenreUseCase(repo);
  });

  test('forwards genreId variant', () async {
    when(
      () => repo.stationsByGenre(genreId: 7, page: 1, limit: 20),
    ).thenAnswer((_) async => page);
    await useCase(genreId: 7);
    verify(
      () => repo.stationsByGenre(genreId: 7, page: 1, limit: 20),
    ).called(1);
  });

  test('forwards genreSlug variant', () async {
    when(
      () => repo.stationsByGenre(genreSlug: 'rock', page: 1, limit: 20),
    ).thenAnswer((_) async => page);
    await useCase(genreSlug: 'rock');
    verify(
      () => repo.stationsByGenre(genreSlug: 'rock', page: 1, limit: 20),
    ).called(1);
  });
}
