import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class GenreChip extends StatelessWidget {
  const GenreChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: active ? AppColors.textPrimary : Colors.transparent,
        border: Border.all(color: AppColors.textPrimary, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.meta.copyWith(
          color: active ? AppColors.surfaceBody : AppColors.textPrimary,
        ),
      ),
    ),
  );
}
