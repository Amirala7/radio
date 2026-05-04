import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import 'lcd_display.dart';
import 'power_button.dart';
import 'speaker_grille.dart';
import 'volume_slider.dart';

class HardwarePanel extends StatelessWidget {
  const HardwarePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      height: AppSpacing.panelHeight + bottomInset,
      decoration: const BoxDecoration(
        color: AppColors.panelDarkTop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: const LcdDisplay(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const PowerButton(),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(child: const VolumeSlider()),
                  const SizedBox(width: AppSpacing.lg),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: const SpeakerGrille(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
