import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../features/player/domain/repositories/player_repository.dart';
import 'system_volume_sink.dart';

class VolumeController extends ChangeNotifier {
  VolumeController({
    required PlayerRepository player,
    required SystemVolumeSink system,
    double initialVolume = 0.5,
  }) : _player = player,
       _system = system,
       _volume = initialVolume.clamp(0.0, 1.0) {
    _sub = _system.changes.listen(_onSystemChange);
  }

  final PlayerRepository _player;
  final SystemVolumeSink _system;
  StreamSubscription<double>? _sub;
  double _volume;
  bool _userDriving = false;
  double? _pendingSystemValue;

  double get volume => _volume;

  Future<void> setVolume(double v) async {
    final clamped = v.clamp(0.0, 1.0).toDouble();
    if (clamped == _volume) return;
    _volume = clamped;
    notifyListeners();
    await Future.wait([_player.setVolume(clamped), _system.set(clamped)]);
  }

  /// Call when the user starts dragging the in-app slider. While driving,
  /// system volume emissions are buffered instead of immediately overriding
  /// the displayed value — iOS quantizes volume to ~16 steps and echoing
  /// every snap back into the slider makes the drag jitter.
  void beginUserDrag() {
    _userDriving = true;
    _pendingSystemValue = null;
  }

  /// Call when the drag finishes. Aligns the slider to whatever the system
  /// last reported (the quantized step), so the visual settles where the
  /// hardware actually is.
  void endUserDrag() {
    _userDriving = false;
    final pending = _pendingSystemValue;
    _pendingSystemValue = null;
    if (pending == null) return;
    if ((pending - _volume).abs() < 0.001) return;
    _volume = pending;
    notifyListeners();
    unawaited(_player.setVolume(pending));
  }

  void _onSystemChange(double v) {
    final clamped = v.clamp(0.0, 1.0).toDouble();
    if (_userDriving) {
      _pendingSystemValue = clamped;
      return;
    }
    // Ignore echo of our own writes — guard against pump loops.
    if ((clamped - _volume).abs() < 0.001) return;
    _volume = clamped;
    notifyListeners();
    unawaited(_player.setVolume(clamped));
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
