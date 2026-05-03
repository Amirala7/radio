import 'package:just_audio/just_audio.dart';

enum SfxId { click, switchKnob, tuning1, tuning3 }

typedef AudioPlayerFactory = AudioPlayer Function(SfxId id);

class SfxPlayer {
  SfxPlayer({AudioPlayerFactory? playerFactory})
    : _factory = playerFactory ?? ((_) => AudioPlayer());

  final AudioPlayerFactory _factory;
  final Map<SfxId, AudioPlayer> _players = {};
  SfxId? _activeLoop;

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
    for (final id in SfxId.values) {
      final player = _factory(id);
      await player.setAsset(assetFor(id));
      _players[id] = player;
    }
  }

  Future<void> playOnce(SfxId id) async {
    final p = _players[id];
    if (p == null) return;
    await p.seek(Duration.zero);
    await p.play();
  }

  Future<void> startLoop(SfxId id) async {
    final p = _players[id];
    if (p == null) return;
    await p.setLoopMode(LoopMode.one);
    await p.play();
    _activeLoop = id;
  }

  Future<void> stopLoop() async {
    final id = _activeLoop;
    if (id == null) return;
    await _players[id]?.stop();
    _activeLoop = null;
  }

  Future<void> dispose() async {
    for (final p in _players.values) {
      await p.dispose();
    }
    _players.clear();
  }
}
