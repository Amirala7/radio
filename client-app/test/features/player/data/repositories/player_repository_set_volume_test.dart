import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/player/data/datasources/audio_player_data_source.dart';
import 'package:radio/features/player/data/repositories/player_repository_impl.dart';

class _MockAudioPlayerDataSource extends Mock implements AudioPlayerDataSource {}

void main() {
  late _MockAudioPlayerDataSource ds;
  late PlayerRepositoryImpl repo;

  setUp(() {
    ds = _MockAudioPlayerDataSource();
    when(() => ds.events).thenAnswer((_) => const Stream.empty());
    when(() => ds.setVolume(any())).thenAnswer((_) async {});
    repo = PlayerRepositoryImpl(ds);
  });

  test('setVolume forwards clamped value to data source', () async {
    await repo.setVolume(0.42);
    verify(() => ds.setVolume(0.42)).called(1);
  });

  test('setVolume clamps below 0', () async {
    await repo.setVolume(-1.5);
    verify(() => ds.setVolume(0.0)).called(1);
  });

  test('setVolume clamps above 1', () async {
    await repo.setVolume(2.1);
    verify(() => ds.setVolume(1.0)).called(1);
  });
}
