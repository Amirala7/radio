import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.xl,
      AppSpacing.lg,
      AppSpacing.xl,
      AppSpacing.md,
    ),
    child: Row(
      children: [
        const Text('RADIO', style: AppTypography.wordmark),
        const Spacer(),
        IconButton(
          onPressed: null, // Placeholder for v1.
          icon: const Icon(Icons.more_horiz),
          color: AppColors.textPrimary,
        ),
      ],
    ),
  );
}
