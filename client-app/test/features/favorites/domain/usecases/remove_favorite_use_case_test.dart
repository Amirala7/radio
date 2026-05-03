import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:radio/features/favorites/domain/usecases/remove_favorite_use_case.dart';

class _MockRepo extends Mock implements FavoritesRepository {}

void main() {
  late _MockRepo repo;
  late RemoveFavoriteUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = RemoveFavoriteUseCase(repo);
  });

  test('forwards stationId', () async {
    when(() => repo.remove(9)).thenAnswer((_) async {});
    await useCase(9);
    verify(() => repo.remove(9)).called(1);
  });
}
