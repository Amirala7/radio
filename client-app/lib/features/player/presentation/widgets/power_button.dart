import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../core/audio/sfx_player.dart';
import '../../../../core/haptics/haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../view_models/player_view_model.dart';

const String _buttonAsset =
    'assets/images/high-resolution-image-of-a-metallic-button-or-knob-with-a-brushed-metal-finish-ideal-for-industrial-mechanical-and-electronic-design-purposes-png.png.webp';

class PowerButton extends StatefulWidget {
  const PowerButton({super.key});

  @override
  State<PowerButton> createState() => _PowerButtonState();
}

class _PowerButtonState extends State<PowerButton> {
  bool _pressed = false;

  Future<void> _onTap() async {
    setState(() => _pressed = true);
    await Future<void>.delayed(const Duration(milliseconds: 80));
    if (mounted) setState(() => _pressed = false);

    final di = GetIt.I;
    unawaited(di<SfxPlayer>().playOnce(SfxId.click));
    unawaited(di<Haptics>().light());

    if (!mounted) return;
    final vm = context.read<PlayerViewModel>();
    if (vm.isPlaying) {
      await vm.stop();
    } else if (vm.isPaused) {
      await vm.resume();
    } else if (vm.currentStation != null) {
      await vm.play(vm.currentStation!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select<PlayerViewModel, bool>(
      (vm) => vm.isPlaying,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('PLAY/STOP', style: AppTypography.microLabel),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _onTap,
              child: AnimatedScale(
                scale: _pressed ? 0.96 : 1,
                duration: const Duration(milliseconds: 80),
                child: Image.asset(
                  _buttonAsset,
                  width: 44,
                  height: 44,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            _Led(on: isPlaying),
          ],
        ),
      ],
    );
  }
}

class _Led extends StatelessWidget {
  const _Led({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) => Container(
    width: 7,
    height: 7,
    decoration: BoxDecoration(
      color: on
          ? AppColors.indicatorPower
          : AppColors.indicatorPower.withValues(alpha: 0.18),
      shape: BoxShape.circle,
      boxShadow: on
          ? [
              BoxShadow(
                color: AppColors.indicatorPower.withValues(alpha: 0.7),
                blurRadius: 6,
                spreadRadius: 0.5,
              ),
            ]
          : null,
    ),
  );
}

