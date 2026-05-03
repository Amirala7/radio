import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/player/domain/entities/playback_state.dart';
import 'package:radio/features/player/domain/repositories/player_repository.dart';
import 'package:radio/features/player/domain/usecases/watch_playback_use_case.dart';

class _MockRepo extends Mock implements PlayerRepository {}

void main() {
  late _MockRepo repo;
  late WatchPlaybackUseCase useCase;

  setUp(() {
    repo = _MockRepo();
    useCase = WatchPlaybackUseCase(repo);
  });

  test('forwards the repo state stream', () async {
    when(() => repo.state).thenAnswer(
      (_) => Stream<PlaybackState>.value(const PlaybackState()),
    );
    final v = await useCase().first;
    expect(v.status, PlaybackStatus.idle);
  });
}
