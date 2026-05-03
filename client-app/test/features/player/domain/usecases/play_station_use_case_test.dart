import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/player/domain/repositories/player_repository.dart';
import 'package:radio/features/player/domain/usecases/play_station_use_case.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockRepo extends Mock implements PlayerRepository {}

class _FakeStation extends Fake implements Station {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeStation());
  });

  late _MockRepo repo;
  late PlayStationUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = PlayStationUseCase(repo);
  });

  test('forwards the station to repo.play', () async {
    when(() => repo.play(any())).thenAnswer((_) async {});
    const s = Station(id: 1, name: 'X', streams: []);
    await useCase(s);
    verify(() => repo.play(s)).called(1);
  });
}
