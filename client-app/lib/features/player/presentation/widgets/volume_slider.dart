import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../core/audio/sfx_player.dart';
import '../../../../core/haptics/haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/volume/volume_controller.dart';

class VolumeSlider extends StatefulWidget {
  const VolumeSlider({super.key});

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  final _clickClock = Stopwatch()..start();
  double? _lastEmittedVolume;

  static const double _trackHeight = 18;
  static const double _thumbWidth = 28;
  static const double _thumbHeight = 26;
  static const int _trackDots = 22;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VolumeController>();
    final volume = controller.volume;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(child: Text('VOLUME', style: AppTypography.microLabel)),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (d) {
                controller.beginUserDrag();
                _setFromX(d.localPosition.dx, width, controller);
              },
              onPanUpdate: (d) =>
                  _setFromX(d.localPosition.dx, width, controller),
              onPanEnd: (_) => controller.endUserDrag(),
              onPanCancel: () => controller.endUserDrag(),
              child: SizedBox(
                height: _trackHeight + 12,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _DottedTrack(width: width, dots: _trackDots),
                    Positioned(
                      left: _thumbLeft(volume, width),
                      child: const _SliderThumb(
                        width: _thumbWidth,
                        height: _thumbHeight,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.xs),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('MIN', style: AppTypography.microLabel),
              Text('MAX', style: AppTypography.microLabel),
            ],
          ),
        ),
      ],
    );
  }

  double _thumbLeft(double volume, double width) {
    final usable = width - _thumbWidth;
    return (usable * volume).clamp(0, usable);
  }

  void _setFromX(double x, double width, VolumeController controller) {
    final usable = width - _thumbWidth;
    final clamped = (x - _thumbWidth / 2).clamp(0.0, usable);
    final next = usable == 0 ? 0.0 : clamped / usable;
    controller.setVolume(next);

    final delta = (_lastEmittedVolume == null
        ? 0.05
        : (next - _lastEmittedVolume!).abs());
    if (delta >= 0.01 && _clickClock.elapsedMilliseconds >= 40) {
      _clickClock.reset();
      _lastEmittedVolume = next;
      final di = GetIt.I;
      unawaited(di<SfxPlayer>().playOnce(SfxId.switchKnob));
      unawaited(di<Haptics>().selection());
    }
  }
}

class _DottedTrack extends StatelessWidget {
  const _DottedTrack({required this.width, required this.dots});

  final double width;
  final int dots;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    height: 4,
    child: CustomPaint(painter: _TrackPainter(dots: dots)),
  );
}

class _TrackPainter extends CustomPainter {
  const _TrackPainter({required this.dots});

  final int dots;

  @override
  void paint(Canvas canvas, Size size) {
    if (dots < 2) return;
    final paint = Paint()..color = AppColors.trackDot;
    final step = size.width / (dots - 1);
    for (var i = 0; i < dots; i++) {
      canvas.drawCircle(Offset(i * step, size.height / 2), 1.4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrackPainter oldDelegate) =>
      oldDelegate.dots != dots;
}

class _SliderThumb extends StatelessWidget {
  const _SliderThumb({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.knobLight, AppColors.knobDark],
      ),
      border: Border.all(color: AppColors.bezelDark, width: 0.5),
      boxShadow: const [
        BoxShadow(color: Color(0x66000000), blurRadius: 4, offset: Offset(0, 2)),
      ],
    ),
    child: CustomPaint(painter: const _ThumbGripPainter()),
  );
}

class _ThumbGripPainter extends CustomPainter {
  const _ThumbGripPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.bezelDark.withValues(alpha: 0.45)
      ..strokeWidth = 1;
    final cy1 = size.height * 0.3;
    final cy2 = size.height * 0.7;
    for (var i = 0; i < 3; i++) {
      final x = size.width * (0.32 + i * 0.18);
      canvas.drawLine(Offset(x, cy1), Offset(x, cy2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ThumbGripPainter oldDelegate) => false;
}
