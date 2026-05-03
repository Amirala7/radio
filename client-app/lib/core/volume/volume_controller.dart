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
       _volume = initialVolume.clamp(0.0, 1.0);

  final PlayerRepository _player;
  final SystemVolumeSink _system;
  double _volume;

  double get volume => _volume;

  Future<void> setVolume(double v) async {
    final clamped = v.clamp(0.0, 1.0).toDouble();
    _volume = clamped;
    notifyListeners();
    await Future.wait([_player.setVolume(clamped), _system.set(clamped)]);
  }
}
