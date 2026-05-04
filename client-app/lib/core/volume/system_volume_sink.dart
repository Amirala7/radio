import 'dart:async';

import 'package:volume_controller/volume_controller.dart' as plugin;

abstract interface class SystemVolumeSink {
  Future<void> set(double volume);

  /// Emits the current system volume on subscribe and on every subsequent
  /// change (including hardware button presses outside our UI).
  Stream<double> get changes;
}

class PluginSystemVolumeSink implements SystemVolumeSink {
  PluginSystemVolumeSink() {
    // Hide the system volume HUD on Android while the user drags our slider.
    // No effect on iOS.
    plugin.VolumeController.instance.showSystemUI = false;
    plugin.VolumeController.instance.addListener(
      (v) => _changes.add(v.clamp(0.0, 1.0).toDouble()),
    );
  }

  final StreamController<double> _changes =
      StreamController<double>.broadcast();

  @override
  Stream<double> get changes => _changes.stream;

  @override
  Future<void> set(double volume) async {
    await plugin.VolumeController.instance.setVolume(volume.clamp(0.0, 1.0));
  }
}
