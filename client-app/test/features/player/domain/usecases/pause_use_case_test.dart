import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/player/domain/repositories/player_repository.dart';
import 'package:radio/features/player/domain/usecases/pause_use_case.dart';

class _MockRepo extends Mock implements PlayerRepository {}

void main() {
  late _MockRepo repo;
  late PauseUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = PauseUseCase(repo);
  });

  test('calls repo.pause', () async {
    when(() => repo.pause()).thenAnswer((_) async {});
    await useCase();
    verify(() => repo.pause()).called(1);
  });
}
