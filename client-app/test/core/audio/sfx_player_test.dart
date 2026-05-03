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
      when(() => p.pause()).thenAnswer((_) async {});
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

  test(
    'startLoop enables LoopMode.one, seeks to zero, and plays',
    () async {
      await sfx.init();
      await sfx.startLoop(SfxId.tuning1);
      verifyInOrder([
        () => players[SfxId.tuning1]!.setLoopMode(LoopMode.one),
        () => players[SfxId.tuning1]!.seek(Duration.zero),
        () => players[SfxId.tuning1]!.play(),
      ]);
    },
  );

  test(
    'stopLoop pauses and rewinds every tuning player',
    () async {
      await sfx.init();
      await sfx.startLoop(SfxId.tuning1);
      await sfx.stopLoop();
      verify(() => players[SfxId.tuning1]!.pause()).called(greaterThan(0));
      verify(
        () => players[SfxId.tuning1]!.seek(Duration.zero),
      ).called(greaterThan(0));
      verifyNever(() => players[SfxId.click]!.pause());
      verifyNever(() => players[SfxId.switchKnob]!.pause());
    },
  );

  test(
    'stopLoop fired before startLoop runs preempts the start (no play)',
    () async {
      await sfx.init();

      // Fire start without awaiting — the synchronous flag is set, but
      // the chained _reconcile hasn't run yet.
      // ignore: unawaited_futures
      sfx.startLoop(SfxId.tuning1);

      // Stop before _reconcile runs. Synchronously flips the intent.
      await sfx.stopLoop();

      // play() must not have been invoked — by the time _reconcile ran,
      // the intent was already 'stop'.
      verifyNever(() => players[SfxId.tuning1]!.play());
      // And both tuning players were paused defensively.
      verify(() => players[SfxId.tuning1]!.pause()).called(greaterThan(0));
    },
  );

  test(
    'stop after start and reconcile actually stops the running loop',
    () async {
      await sfx.init();
      await sfx.startLoop(SfxId.tuning1); // fully reconciled — playing.
      verify(() => players[SfxId.tuning1]!.play()).called(1);

      await sfx.stopLoop();
      verify(() => players[SfxId.tuning1]!.pause()).called(greaterThan(0));
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
