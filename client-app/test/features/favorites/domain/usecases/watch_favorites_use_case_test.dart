import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/favorites/domain/entities/favorite_station.dart';
import 'package:radio/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:radio/features/favorites/domain/usecases/watch_favorites_use_case.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockRepo extends Mock implements FavoritesRepository {}

void main() {
  late _MockRepo repo;
  late WatchFavoritesUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = WatchFavoritesUseCase(repo);
  });

  test('forwards the repository stream', () async {
    final fav = FavoriteStation(
      station: const Station(id: 1, name: 'X', streams: []),
      addedAt: DateTime.utc(2026, 5, 3),
    );
    when(() => repo.watchAll()).thenAnswer((_) => Stream.value([fav]));
    final result = await useCase().first;
    expect(result.first.station.id, 1);
  });
}
