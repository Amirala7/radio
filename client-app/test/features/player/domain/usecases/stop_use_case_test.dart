import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/player/domain/repositories/player_repository.dart';
import 'package:radio/features/player/domain/usecases/stop_use_case.dart';

class _MockRepo extends Mock implements PlayerRepository {}

void main() {
  late _MockRepo repo;
  late StopUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = StopUseCase(repo);
  });

  test('calls repo.stop', () async {
    when(() => repo.stop()).thenAnswer((_) async {});
    await useCase();
    verify(() => repo.stop()).called(1);
  });
}
