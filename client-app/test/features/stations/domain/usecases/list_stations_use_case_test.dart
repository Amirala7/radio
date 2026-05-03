import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_meta.dart';
import 'package:radio/features/stations/domain/entities/station.dart';
import 'package:radio/features/stations/domain/repositories/station_repository.dart';
import 'package:radio/features/stations/domain/usecases/list_stations_use_case.dart';

class _MockRepo extends Mock implements StationRepository {}

void main() {
  late _MockRepo repo;
  late ListStationsUseCase useCase;
  const sample = Station(id: 1, name: 'X', streams: []);
  const page = Page<Station>(
    data: [sample],
    meta: PageMeta(page: 1, limit: 20),
  );

  setUp(() {
    repo = _MockRepo();
    useCase = ListStationsUseCase(repo);
  });

  test('forwards page and limit and returns the repo result', () async {
    when(
      () => repo.listStations(page: 2, limit: 50),
    ).thenAnswer((_) async => page);
    final result = await useCase(page: 2, limit: 50);
    expect(result.data.first.id, 1);
    verify(() => repo.listStations(page: 2, limit: 50)).called(1);
  });

  test('propagates failures from the repo', () async {
    when(
      () => repo.listStations(page: 1, limit: 20),
    ).thenThrow(const NetworkFailure());
    await expectLater(useCase(), throwsA(isA<NetworkFailure>()));
  });
}
