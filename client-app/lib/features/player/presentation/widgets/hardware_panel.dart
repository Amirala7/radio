import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'lcd_display.dart';
import 'panel_decoration.dart';
import 'power_button.dart';
import 'volume_knob.dart';

class HardwarePanel extends StatelessWidget {
  const HardwarePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      height: AppSpacing.panelHeight + bottomInset,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.surfacePanelLight, AppColors.surfacePanelDark],
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.knobDark.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          const PanelDecoration(),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md + bottomInset,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Expanded(flex: 1, child: Center(child: PowerButton())),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LcdDisplay(),
                        SizedBox(height: AppSpacing.sm),
                        Text('TUNED IN', style: AppTypography.microLabel),
                      ],
                    ),
                  ),
                ),
                Expanded(flex: 1, child: Center(child: VolumeKnob())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
