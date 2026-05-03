import 'package:flutter/services.dart';

class Haptics {
  const Haptics();

  Future<void> light() => HapticFeedback.lightImpact();

  Future<void> selection() => HapticFeedback.selectionClick();

  Future<void> medium() => HapticFeedback.mediumImpact();
}

class NoopHaptics implements Haptics {
  const NoopHaptics();

  @override
  Future<void> light() async {}

  @override
  Future<void> selection() async {}

  @override
  Future<void> medium() async {}
}
