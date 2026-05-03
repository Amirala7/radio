import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:radio/features/favorites/domain/usecases/toggle_favorite_use_case.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockRepo extends Mock implements FavoritesRepository {}

class _FakeStation extends Fake implements Station {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeStation());
  });

  late _MockRepo repo;
  late ToggleFavoriteUseCase useCase;
  const station = Station(id: 7, name: 'X', streams: []);

  setUp(() {
    repo = _MockRepo();
    useCase = ToggleFavoriteUseCase(repo);
  });

  test('removes when isFavorite emits true', () async {
    when(() => repo.isFavorite(7)).thenAnswer((_) => Stream.value(true));
    when(() => repo.remove(7)).thenAnswer((_) async {});
    await useCase(station);
    verify(() => repo.remove(7)).called(1);
    verifyNever(() => repo.add(any()));
  });

  test('adds when isFavorite emits false', () async {
    when(() => repo.isFavorite(7)).thenAnswer((_) => Stream.value(false));
    when(() => repo.add(any())).thenAnswer((_) async {});
    await useCase(station);
    verify(() => repo.add(station)).called(1);
    verifyNever(() => repo.remove(any()));
  });

  test(
    'propagates failure from isFavorite without calling add/remove',
    () async {
      when(
        () => repo.isFavorite(7),
      ).thenAnswer((_) => Stream.error(const UnauthenticatedFailure()));
      await expectLater(
        useCase(station),
        throwsA(isA<UnauthenticatedFailure>()),
      );
      verifyNever(() => repo.add(any()));
      verifyNever(() => repo.remove(any()));
    },
  );
}
