import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/volume/system_volume_sink.dart';
import 'package:radio/core/volume/volume_controller.dart';
import 'package:radio/features/player/domain/repositories/player_repository.dart';

class _MockPlayer extends Mock implements PlayerRepository {}

class _MockSink extends Mock implements SystemVolumeSink {}

void main() {
  late _MockPlayer player;
  late _MockSink sink;
  late VolumeController controller;

  setUp(() {
    player = _MockPlayer();
    sink = _MockSink();
    when(() => player.setVolume(any())).thenAnswer((_) async {});
    when(() => sink.set(any())).thenAnswer((_) async {});
    when(() => sink.changes).thenAnswer((_) => const Stream<double>.empty());
    controller = VolumeController(player: player, system: sink);
  });

  test('default volume is 0.5', () {
    expect(controller.volume, 0.5);
  });

  test('setVolume updates state and notifies', () async {
    var notifyCount = 0;
    controller.addListener(() => notifyCount++);

    await controller.setVolume(0.75);

    expect(controller.volume, 0.75);
    expect(notifyCount, 1);
  });

  test('setVolume forwards to both sinks', () async {
    await controller.setVolume(0.3);

    verify(() => player.setVolume(0.3)).called(1);
    verify(() => sink.set(0.3)).called(1);
  });

  test('setVolume clamps below 0 and above 1', () async {
    await controller.setVolume(-0.5);
    expect(controller.volume, 0.0);
    verify(() => player.setVolume(0.0)).called(1);
    verify(() => sink.set(0.0)).called(1);

    await controller.setVolume(1.5);
    expect(controller.volume, 1.0);
    verify(() => player.setVolume(1.0)).called(1);
    verify(() => sink.set(1.0)).called(1);
  });
}
