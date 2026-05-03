import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppColors.textPrimary,
      onPrimary: AppColors.surfaceBody,
      secondary: AppColors.accentLive,
      onSecondary: Color(0xFFFFFFFF),
      surface: AppColors.surfaceBody,
      onSurface: AppColors.textPrimary,
      error: AppColors.indicatorPower,
      onError: Color(0xFFFFFFFF),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surfaceBody,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: AppTypography.wordmark,
        titleMedium: AppTypography.stationName,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.body,
        labelLarge: AppTypography.sectionLabel,
        labelMedium: AppTypography.meta,
        labelSmall: AppTypography.microLabel,
      ),
      dividerColor: AppColors.divider,
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: AppSpacing.hairline,
        space: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceBody,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }
}
