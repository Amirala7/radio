import 'package:flutter/painting.dart';

import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String _jost = 'Jost';
  static const String _inter = 'Inter';
  static const String _plex = 'IBMPlexSans';
  static const String _mono = 'RobotoMono';
  static const String _lcd = 'DSEG14';

  static const FontVariation _wght400 = FontVariation('wght', 400);
  static const FontVariation _wght500 = FontVariation('wght', 500);
  static const FontVariation _wght600 = FontVariation('wght', 600);
  static const FontVariation _wght700 = FontVariation('wght', 700);

  // App wordmark — `raDio` in the header.
  static const TextStyle wordmark = TextStyle(
    fontFamily: _jost,
    fontVariations: [_wght700],
    fontSize: 28,
    height: 1,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  // Bold sentence-case station names in the list.
  static const TextStyle stationName = TextStyle(
    fontFamily: _inter,
    fontVariations: [_wght600],
    fontSize: 18,
    height: 1.2,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  // Default body — Inter Regular.
  static const TextStyle body = TextStyle(
    fontFamily: _inter,
    fontVariations: [_wght400],
    fontSize: 15,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // Section labels like `ALL STATIONS` — uppercase, generously letter-spaced.
  static const TextStyle sectionLabel = TextStyle(
    fontFamily: _plex,
    fontWeight: FontWeight.w400,
    fontSize: 11,
    height: 1.2,
    letterSpacing: 2,
    color: AppColors.textSecondary,
  );

  // Genre / location / bitrate meta lines.
  static const TextStyle meta = TextStyle(
    fontFamily: _plex,
    fontWeight: FontWeight.w500,
    fontSize: 11,
    height: 1.4,
    letterSpacing: 1.6,
    color: AppColors.textSecondary,
  );

  // The `LIVE` token rendered in the accent color.
  static const TextStyle metaLive = TextStyle(
    fontFamily: _plex,
    fontWeight: FontWeight.w500,
    fontSize: 11,
    height: 1.4,
    letterSpacing: 1.6,
    color: AppColors.accentLive,
  );

  // Hardware micro-labels — `POWER`, `VOLUME`, `MIN`, `MAX`.
  static const TextStyle microLabel = TextStyle(
    fontFamily: _mono,
    fontVariations: [_wght500],
    fontSize: 9,
    height: 1.2,
    letterSpacing: 1.4,
    color: AppColors.textPrimary,
  );

  // LCD station name (the big `NTS RADIO` line).
  static const TextStyle lcdLarge = TextStyle(
    fontFamily: _lcd,
    fontWeight: FontWeight.w700,
    fontSize: 22,
    height: 1,
    color: AppColors.textLcd,
  );

  // LCD secondary lines (track, status, elapsed time).
  static const TextStyle lcdSmall = TextStyle(
    fontFamily: _lcd,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.1,
    color: AppColors.textLcd,
  );
}
