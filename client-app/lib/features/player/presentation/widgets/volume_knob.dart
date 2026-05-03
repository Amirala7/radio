import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../core/audio/sfx_player.dart';
import '../../../../core/haptics/haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/volume/volume_controller.dart';

class VolumeKnob extends StatefulWidget {
  const VolumeKnob({super.key});

  @override
  State<VolumeKnob> createState() => _VolumeKnobState();
}

class _VolumeKnobState extends State<VolumeKnob> {
  late Offset _knobCenter;
  double? _lastAngle;
  final _clickClock = Stopwatch()..start();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VolumeController>();
    final volume = controller.volume;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('VOLUME', style: AppTypography.microLabel),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (ctx, _) {
            return GestureDetector(
              onPanStart: _onStart,
              onPanUpdate: (d) => _onUpdate(d, controller),
              onPanEnd: (_) => _lastAngle = null,
              child: SizedBox(
                width: 96,
                height: 96,
                child: Builder(
                  builder: (ctx) {
                    _knobCenter = const Offset(48, 48);
                    return CustomPaint(painter: _KnobPainter(volume: volume));
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(width: 96, child: _MinMax()),
          ],
        ),
      ],
    );
  }

  void _onStart(DragStartDetails d) {
    _lastAngle = _angleFromCenter(d.localPosition);
  }

  void _onUpdate(DragUpdateDetails d, VolumeController controller) {
    final angle = _angleFromCenter(d.localPosition);
    final last = _lastAngle ?? angle;
    var delta = angle - last;
    // Normalise into [-pi, pi]
    while (delta > math.pi) {
      delta -= 2 * math.pi;
    }
    while (delta < -math.pi) {
      delta += 2 * math.pi;
    }
    _lastAngle = angle;

    // Full sweep across ~270 degrees == 1.0 of volume.
    const sweep = 270 * math.pi / 180;
    final next = (controller.volume + delta / sweep).clamp(0.0, 1.0);
    controller.setVolume(next);

    final speed = (delta.abs() / 0.05).clamp(0.0, 5.0); // crude velocity proxy
    final clickIntervalMs = math.max(20, 200 - (speed * 35).round()).toInt();
    if (_clickClock.elapsedMilliseconds >= clickIntervalMs) {
      _clickClock.reset();
      final di = GetIt.I;
      unawaited(di<SfxPlayer>().playOnce(SfxId.switchKnob));
      unawaited(di<Haptics>().selection());
    }
  }

  double _angleFromCenter(Offset local) {
    final dx = local.dx - _knobCenter.dx;
    final dy = local.dy - _knobCenter.dy;
    return math.atan2(dy, dx);
  }
}

class _KnobPainter extends CustomPainter {
  _KnobPainter({required this.volume});

  final double volume;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 4;

    final body = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.4),
        colors: [AppColors.knobLight, AppColors.knobDark],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, body);

    // Top-semicircle knurl ticks (top 180° only).
    final knurl = Paint()
      ..color = AppColors.knobDark.withValues(alpha: 0.7)
      ..strokeWidth = 1;
    const ticks = 30;
    for (var i = 0; i <= ticks; i++) {
      // Sweep from 200° to 340° (top semicircle visually).
      final t = i / ticks;
      final angle = math.pi + t * math.pi; // pi to 2pi
      final outer = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      final inner = Offset(
        center.dx + math.cos(angle) * (radius - 6),
        center.dy + math.sin(angle) * (radius - 6),
      );
      canvas.drawLine(outer, inner, knurl);
    }

    // Indicator notch on the rim.
    final notchAngle = math.pi * 1.25 + volume * (math.pi * 1.5);
    final notchPaint = Paint()..color = const Color(0xFF1A1A1A);
    final notchOuter = Offset(
      center.dx + math.cos(notchAngle) * (radius - 1),
      center.dy + math.sin(notchAngle) * (radius - 1),
    );
    final notchInner = Offset(
      center.dx + math.cos(notchAngle) * (radius - 10),
      center.dy + math.sin(notchAngle) * (radius - 10),
    );
    canvas.drawLine(notchInner, notchOuter, notchPaint..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant _KnobPainter oldDelegate) =>
      oldDelegate.volume != volume;
}

class _MinMax extends StatelessWidget {
  const _MinMax();

  @override
  Widget build(BuildContext context) => const Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text('MIN', style: AppTypography.microLabel),
      Text('MAX', style: AppTypography.microLabel),
    ],
  );
}
