import 'package:volume_controller/volume_controller.dart' as plugin;

abstract interface class SystemVolumeSink {
  Future<void> set(double volume);
}

class PluginSystemVolumeSink implements SystemVolumeSink {
  PluginSystemVolumeSink() {
    // Hide the system volume slider on Android while the user is dragging
    // the in-app knob. Has no effect on iOS.
    plugin.VolumeController.instance.showSystemUI = false;
  }

  @override
  Future<void> set(double volume) async {
    await plugin.VolumeController.instance.setVolume(volume.clamp(0.0, 1.0));
  }
}
