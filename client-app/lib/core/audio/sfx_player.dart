import 'dart:async';
import 'dart:developer' as developer;

import 'package:just_audio/just_audio.dart';

enum SfxId { click, switchKnob, tuning1, tuning3 }

typedef AudioPlayerFactory = AudioPlayer Function(SfxId id);

class SfxPlayer {
  SfxPlayer({AudioPlayerFactory? playerFactory})
    : _factory = playerFactory ?? ((_) => AudioPlayer());

  static const _logName = 'sfx';
  static const _loopIds = <SfxId>[SfxId.tuning1, SfxId.tuning3];

  final AudioPlayerFactory _factory;
  final Map<SfxId, AudioPlayer> _players = {};

  // Synchronous source of truth — set immediately by start/stop callers.
  bool _wantPlaying = false;
  SfxId? _desiredLoopId;

  // Serialised op chain so async work doesn't interleave.
  Future<void> _chain = Future<void>.value();

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

  Future<void> startLoop(SfxId id) {
    _wantPlaying = true;
    _desiredLoopId = id;
    developer.log('startLoop($id) requested', name: _logName);
    return _enqueue();
  }

  Future<void> stopLoop() {
    _wantPlaying = false;
    _desiredLoopId = null;
    developer.log('stopLoop requested', name: _logName);
    return _enqueue();
  }

  Future<void> _enqueue() {
    final next = _chain.catchError((_) {}).then((_) => _reconcile());
    _chain = next;
    return next;
  }

  /// Drives all loop players to the most recently-requested intent.
  /// Reads `_wantPlaying`/`_desiredLoopId` at run time, so a stop that
  /// arrives between a start being enqueued and this op executing wins.
  Future<void> _reconcile() async {
    final wantPlaying = _wantPlaying;
    final desired = _desiredLoopId;
    developer.log(
      'reconcile → wantPlaying=$wantPlaying desired=$desired',
      name: _logName,
    );

    if (wantPlaying && desired != null) {
      // Pause any other loop player.
      for (final id in _loopIds) {
        if (id == desired) continue;
        await _safePause(_players[id]);
      }
      final p = _players[desired];
      if (p == null) return;
      await p.setLoopMode(LoopMode.one);
      await p.seek(Duration.zero);
      await p.play();
      return;
    }

    // Stop intent — pause every loop player, regardless of which we
    // think was active. Cheap insurance against drift.
    for (final id in _loopIds) {
      await _safePause(_players[id]);
    }
  }

  Future<void> _safePause(AudioPlayer? p) async {
    if (p == null) return;
    try {
      await p.pause();
      await p.seek(Duration.zero);
    } catch (e) {
      developer.log('pause failed: $e', name: _logName, error: e);
    }
  }

  Future<void> dispose() async {
    for (final p in _players.values) {
      await p.dispose();
    }
    _players.clear();
  }
}
