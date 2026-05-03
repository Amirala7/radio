import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/audio/sfx_player.dart';

class _MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  setUpAll(() {
    registerFallbackValue(LoopMode.off);
  });

  late Map<SfxId, _MockAudioPlayer> players;
  late SfxPlayer sfx;

  setUp(() {
    players = {for (final id in SfxId.values) id: _MockAudioPlayer()};
    for (final p in players.values) {
      when(() => p.setAsset(any())).thenAnswer((_) async => Duration.zero);
      when(() => p.setLoopMode(any())).thenAnswer((_) async {});
      when(() => p.seek(any())).thenAnswer((_) async {});
      when(() => p.play()).thenAnswer((_) async {});
      when(() => p.stop()).thenAnswer((_) async {});
      when(() => p.dispose()).thenAnswer((_) async {});
    }
    sfx = SfxPlayer(playerFactory: (id) => players[id]!);
  });

  test('init pre-loads each asset on its dedicated player', () async {
    await sfx.init();
    for (final entry in players.entries) {
      verify(
        () => entry.value.setAsset(SfxPlayer.assetFor(entry.key)),
      ).called(1);
    }
  });

  test('playOnce seeks to zero then plays', () async {
    await sfx.init();
    await sfx.playOnce(SfxId.click);
    verifyInOrder([
      () => players[SfxId.click]!.seek(Duration.zero),
      () => players[SfxId.click]!.play(),
    ]);
  });

  test('startLoop enables LoopMode.one and plays', () async {
    await sfx.init();
    await sfx.startLoop(SfxId.tuning1);
    verify(() => players[SfxId.tuning1]!.setLoopMode(LoopMode.one)).called(1);
    verify(() => players[SfxId.tuning1]!.play()).called(1);
  });

  test('stopLoop stops the active loop player only', () async {
    await sfx.init();
    await sfx.startLoop(SfxId.tuning1);
    await sfx.stopLoop();
    verify(() => players[SfxId.tuning1]!.stop()).called(1);
    verifyNever(() => players[SfxId.click]!.stop());
  });

  test(
    'stopLoop fired before startLoop completes still stops the player',
    () async {
      await sfx.init();

      // Hold the in-flight startLoop's play() until we say so.
      final playGate = Completer<void>();
      when(
        () => players[SfxId.tuning1]!.play(),
      ).thenAnswer((_) => playGate.future);

      // Fire startLoop without awaiting (mirrors LCD's unawaited(...)).
      // ignore: unawaited_futures
      sfx.startLoop(SfxId.tuning1);

      // Stop while the start is still pending — this is the race that
      // previously left the tuning loop running forever.
      final stopFuture = sfx.stopLoop();

      // Let the in-flight play() finally resolve.
      playGate.complete();
      await stopFuture;

      verify(() => players[SfxId.tuning1]!.play()).called(1);
      verify(() => players[SfxId.tuning1]!.stop()).called(1);
    },
  );

  test('dispose disposes every player', () async {
    await sfx.init();
    await sfx.dispose();
    for (final p in players.values) {
      verify(() => p.dispose()).called(1);
    }
  });
}
