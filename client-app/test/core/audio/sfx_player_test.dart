import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/audio/sfx_player.dart';

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _FakeAudioContext extends Fake implements AudioContext {}

void main() {
  setUpAll(() {
    registerFallbackValue(ReleaseMode.stop);
    registerFallbackValue(AssetSource('placeholder'));
    registerFallbackValue(Duration.zero);
    registerFallbackValue(_FakeAudioContext());
  });

  late List<_MockAudioPlayer> created;
  late SfxPlayer sfx;

  setUp(() {
    created = [];
    sfx = SfxPlayer(
      playerFactory: () {
        final p = _MockAudioPlayer();
        when(() => p.setAudioContext(any())).thenAnswer((_) async {});
        when(() => p.setReleaseMode(any())).thenAnswer((_) async {});
        when(() => p.setSource(any())).thenAnswer((_) async {});
        when(() => p.seek(any())).thenAnswer((_) async {});
        when(() => p.resume()).thenAnswer((_) async {});
        when(() => p.play(any())).thenAnswer((_) async {});
        when(() => p.stop()).thenAnswer((_) async {});
        when(() => p.dispose()).thenAnswer((_) async {});
        created.add(p);
        return p;
      },
    );
  });

  Matcher isAssetSource(String path) => predicate<Source>(
    (s) => s is AssetSource && s.path == path,
    'AssetSource("$path")',
  );

  test('init creates one player per one-shot SFX and loads its asset', () async {
    await sfx.init();
    expect(created.length, 2);
    verify(
      () => created[0].setSource(
        any(that: isAssetSource(SfxPlayer.assetFor(SfxId.click))),
      ),
    ).called(1);
    verify(
      () => created[1].setSource(
        any(that: isAssetSource(SfxPlayer.assetFor(SfxId.switchKnob))),
      ),
    ).called(1);
  });

  test('init applies a non-disturbing AudioContext to each one-shot', () async {
    await sfx.init();
    for (final p in created) {
      verify(() => p.setAudioContext(any())).called(1);
    }
  });

  test('playOnce seeks the matching pre-loaded player and resumes', () async {
    await sfx.init();
    await sfx.playOnce(SfxId.click);
    verifyInOrder([
      () => created[0].seek(Duration.zero),
      () => created[0].resume(),
    ]);
  });

  test('startLoop creates a fresh player, sets loop mode, and plays', () async {
    await sfx.init();
    await sfx.startLoop(SfxId.tuning1);
    final loop = created.last;
    verify(() => loop.setReleaseMode(ReleaseMode.loop)).called(1);
    verify(
      () => loop.play(
        any(that: isAssetSource(SfxPlayer.assetFor(SfxId.tuning1))),
      ),
    ).called(1);
  });

  test('startLoop applies the non-disturbing AudioContext to the loop player',
      () async {
    await sfx.init();
    await sfx.startLoop(SfxId.tuning1);
    verify(() => created.last.setAudioContext(any())).called(1);
  });

  test('stopLoop stops and disposes the active loop player', () async {
    await sfx.init();
    await sfx.startLoop(SfxId.tuning1);
    final loop = created.last;
    await sfx.stopLoop();
    verify(() => loop.stop()).called(1);
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
