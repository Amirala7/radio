import 'package:flutter/painting.dart';

class AppColors {
  AppColors._();

  // Surfaces — the app reads as two distinct materials.
  static const Color surfaceBody = Color(0xFFEFEBE2);
  static const Color surfacePanelLight = Color(0xFFB6B1A8);
  static const Color surfacePanelDark = Color(0xFF8E8881);
  static const Color surfaceLcd = Color(0xFFB8C2A8);

  // Dark hardware panel — bottom-of-screen control surface.
  static const Color panelDark = Color(0xFF1C1C1E);
  static const Color panelDarkTop = Color(0xFF2A2A2C);
  static const Color bezelDark = Color(0xFF0E0E10);
  static const Color bezelHighlight = Color(0xFF3A3A3C);
  static const Color trackDot = Color(0xFF6E6862);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF8E8881);
  static const Color textLcd = Color(0xFF2A2E22);
  static const Color textOnDark = Color(0xFFC8C5BD);

  // Accent and indicators — one accent only, used sparingly for active states.
  static const Color accentLive = Color(0xFFE96A2D);
  static const Color indicatorPower = Color(0xFFD43A2A);

  // Knob metallics — top and bottom of the brushed gradient.
  static const Color knobLight = Color(0xFFD9D5CC);
  static const Color knobDark = Color(0xFF6E6862);

  // Hairline divider between list rows.
  static const Color divider = Color(0xFFD9D2C5);
}
