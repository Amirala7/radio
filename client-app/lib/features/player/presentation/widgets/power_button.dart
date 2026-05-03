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
      children: [
        const Text('POWER', style: AppTypography.microLabel),
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: _onTap,
          child: AnimatedScale(
            scale: _pressed ? 0.96 : 1,
            duration: const Duration(milliseconds: 80),
            child: SizedBox(
              width: 48,
              height: 48,
              child: CustomPaint(painter: _ButtonPainter(pressed: _pressed)),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isPlaying
                ? AppColors.indicatorPower
                : AppColors.indicatorPower.withValues(alpha: 0.18),
            shape: BoxShape.circle,
            boxShadow: isPlaying
                ? [
                    BoxShadow(
                      color: AppColors.indicatorPower.withValues(alpha: 0.6),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const _SpeakerGrille(),
      ],
    );
  }
}

class _SpeakerGrille extends StatelessWidget {
  const _SpeakerGrille();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 24,
    height: 24,
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
      ),
      itemBuilder: (_, _) => Container(
        decoration: BoxDecoration(
          color: AppColors.knobDark.withValues(alpha: 0.65),
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}

class _ButtonPainter extends CustomPainter {
  _ButtonPainter({required this.pressed});

  final bool pressed;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outerR = size.shortestSide / 2;
    final innerR = outerR - 4;

    final ringPaint = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.knobDark, AppColors.surfacePanelDark],
        stops: const [0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: outerR));
    canvas.drawCircle(center, outerR, ringPaint);

    final btnPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 0.95,
        colors: pressed
            ? [AppColors.knobLight.withValues(alpha: 0.85), AppColors.knobDark]
            : [AppColors.knobLight, AppColors.knobDark],
      ).createShader(Rect.fromCircle(center: center, radius: innerR));
    canvas.drawCircle(center, innerR, btnPaint);
  }

  @override
  bool shouldRepaint(covariant _ButtonPainter oldDelegate) =>
      oldDelegate.pressed != pressed;
}
