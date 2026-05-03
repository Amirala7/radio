import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:radio/features/favorites/domain/usecases/is_favorite_use_case.dart';

class _MockRepo extends Mock implements FavoritesRepository {}

void main() {
  late _MockRepo repo;
  late IsFavoriteUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = IsFavoriteUseCase(repo);
  });

  test('forwards stationId', () async {
    when(() => repo.isFavorite(7)).thenAnswer((_) => Stream.value(true));
    final v = await useCase(7).first;
    expect(v, isTrue);
    verify(() => repo.isFavorite(7)).called(1);
  });
}
