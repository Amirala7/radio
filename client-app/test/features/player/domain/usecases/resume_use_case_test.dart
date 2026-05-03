import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/player/domain/repositories/player_repository.dart';
import 'package:radio/features/player/domain/usecases/resume_use_case.dart';

class _MockRepo extends Mock implements PlayerRepository {}

void main() {
  late _MockRepo repo;
  late ResumeUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = ResumeUseCase(repo);
  });

  test('calls repo.resume', () async {
    when(() => repo.resume()).thenAnswer((_) async {});
    await useCase();
    verify(() => repo.resume()).called(1);
  });
}
