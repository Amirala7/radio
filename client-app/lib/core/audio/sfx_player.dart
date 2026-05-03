import 'package:just_audio/just_audio.dart';

enum SfxId { click, switchKnob, tuning1, tuning3 }

typedef AudioPlayerFactory = AudioPlayer Function();

/// One-shots (click, knob) are pre-loaded for fast playback.
/// Loops (tuning) use dispose-and-create — the only way to guarantee
/// audio actually stops is to throw the player away.
class SfxPlayer {
  SfxPlayer({AudioPlayerFactory? playerFactory})
    : _factory = playerFactory ?? AudioPlayer.new;

  static const _oneShotIds = <SfxId>[SfxId.click, SfxId.switchKnob];

  final AudioPlayerFactory _factory;
  final Map<SfxId, AudioPlayer> _oneShots = {};
  AudioPlayer? _loop;

  static String assetFor(SfxId id) {
    switch (id) {
      case SfxId.click:
        return 'assets/sounds/DIA_LG_perc_kata_click.wav';
      case SfxId.switchKnob:
        return 'assets/sounds/SwitchLampKnob_S08FO.2508.wav';
      case SfxId.tuning1:
        return 'assets/sounds/OS_VMT_SFX_Old_Radio_Tuning_1.wav';
      case SfxId.tuning3:
        return 'assets/sounds/OS_VMT_SFX_Old_Radio_Tuning_3.wav';
    }
  }

  Future<void> init() async {
    for (final id in _oneShotIds) {
      final p = _factory();
      await p.setAsset(assetFor(id));
      _oneShots[id] = p;
    }
  }

  Future<void> playOnce(SfxId id) async {
    final p = _oneShots[id];
    if (p == null) return;
    await p.seek(Duration.zero);
    await p.play();
  }

  Future<void> startLoop(SfxId id) async {
    await stopLoop();
    final p = _factory();
    _loop = p;
    try {
      await p.setAsset(assetFor(id));
      await p.setLoopMode(LoopMode.one);
      await p.play();
    } catch (_) {
      // A concurrent stopLoop disposed us mid-setup. Nothing to do.
    }
  }

  Future<void> stopLoop() async {
    final p = _loop;
    _loop = null;
    await p?.dispose();
  }

  Future<void> dispose() async {
    for (final p in _oneShots.values) {
      await p.dispose();
    }
    _oneShots.clear();
    await _loop?.dispose();
    _loop = null;
  }
}
