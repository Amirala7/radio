import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/audio/sfx_player.dart';

class _MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  setUpAll(() {
    registerFallbackValue(LoopMode.off);
  });

  late List<_MockAudioPlayer> created;
  late SfxPlayer sfx;

  setUp(() {
    created = [];
    sfx = SfxPlayer(
      playerFactory: () {
        final p = _MockAudioPlayer();
        when(() => p.setAsset(any())).thenAnswer((_) async => Duration.zero);
        when(() => p.setLoopMode(any())).thenAnswer((_) async {});
        when(() => p.seek(any())).thenAnswer((_) async {});
        when(() => p.play()).thenAnswer((_) async {});
        when(() => p.dispose()).thenAnswer((_) async {});
        created.add(p);
        return p;
      },
    );
  });

  test('init creates one player per one-shot SFX and loads its asset', () async {
    await sfx.init();
    expect(created.length, 2);
    verify(
      () => created[0].setAsset(SfxPlayer.assetFor(SfxId.click)),
    ).called(1);
    verify(
      () => created[1].setAsset(SfxPlayer.assetFor(SfxId.switchKnob)),
    ).called(1);
  });

  test('playOnce seeks the matching pre-loaded player and plays', () async {
    await sfx.init();
    await sfx.playOnce(SfxId.click);
    verifyInOrder([
      () => created[0].seek(Duration.zero),
      () => created[0].play(),
    ]);
  });

  test('startLoop creates a fresh player, sets it up, and plays', () async {
    await sfx.init();
    await sfx.startLoop(SfxId.tuning1);
    final loop = created.last;
    verify(
      () => loop.setAsset(SfxPlayer.assetFor(SfxId.tuning1)),
    ).called(1);
    verify(() => loop.setLoopMode(LoopMode.one)).called(1);
    verify(() => loop.play()).called(1);
  });

  test('stopLoop disposes the active loop player', () async {
    await sfx.init();
    await sfx.startLoop(SfxId.tuning1);
    final loop = created.last;
    await sfx.stopLoop();
    verify(() => loop.dispose()).called(1);
  });

  test('startLoop disposes the previous loop before creating a new one', () async {
    await sfx.init();
    await sfx.startLoop(SfxId.tuning1);
    final first = created.last;
    await sfx.startLoop(SfxId.tuning3);
    verify(() => first.dispose()).called(1);
    expect(created.length, 4); // 2 one-shots + 2 loops
  });

  test('dispose tears down every player', () async {
    await sfx.init();
    await sfx.startLoop(SfxId.tuning1);
    await sfx.dispose();
    for (final p in created) {
      verify(() => p.dispose()).called(1);
    }
  });
}
