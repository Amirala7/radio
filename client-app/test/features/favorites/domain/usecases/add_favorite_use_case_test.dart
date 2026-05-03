import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:radio/features/favorites/domain/usecases/add_favorite_use_case.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockRepo extends Mock implements FavoritesRepository {}

class _FakeStation extends Fake implements Station {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeStation());
  });

  late _MockRepo repo;
  late AddFavoriteUseCase useCase;
  const station = Station(id: 1, name: 'X', streams: []);

  setUp(() {
    repo = _MockRepo();
    useCase = AddFavoriteUseCase(repo);
  });

  test('forwards the station to the repository', () async {
    when(() => repo.add(any())).thenAnswer((_) async {});
    await useCase(station);
    verify(() => repo.add(station)).called(1);
  });

  test('propagates failures', () async {
    when(() => repo.add(any())).thenThrow(const UnauthenticatedFailure());
    await expectLater(
      useCase(station),
      throwsA(isA<UnauthenticatedFailure>()),
    );
  });
}
