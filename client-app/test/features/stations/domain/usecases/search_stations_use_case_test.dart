import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_meta.dart';
import 'package:radio/features/stations/domain/entities/station.dart';
import 'package:radio/features/stations/domain/repositories/station_repository.dart';
import 'package:radio/features/stations/domain/usecases/search_stations_use_case.dart';

class _MockRepo extends Mock implements StationRepository {}

void main() {
  late _MockRepo repo;
  late SearchStationsUseCase useCase;
  const page = Page<Station>(data: [], meta: PageMeta(page: 1, limit: 20));

  setUp(() {
    repo = _MockRepo();
    useCase = SearchStationsUseCase(repo);
  });

  test('forwards query and pagination', () async {
    when(
      () => repo.searchStations(query: 'jazz', page: 1, limit: 20),
    ).thenAnswer((_) async => page);
    await useCase(query: 'jazz');
    verify(
      () => repo.searchStations(query: 'jazz', page: 1, limit: 20),
    ).called(1);
  });
}
