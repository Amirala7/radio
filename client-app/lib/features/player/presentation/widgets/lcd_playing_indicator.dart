import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Three chunky bars that flicker at low fps — reads as a vintage LCD
/// equalizer. Sized to fit beside the big station-name row in the LCD.
class LcdPlayingIndicator extends StatefulWidget {
  const LcdPlayingIndicator({super.key});

  @override
  State<LcdPlayingIndicator> createState() => _LcdPlayingIndicatorState();
}

class _LcdPlayingIndicatorState extends State<LcdPlayingIndicator> {
  static const int _bars = 3;
  static const int _rows = 5;
  static const Duration _tick = Duration(milliseconds: 110);

  final Random _rng = Random();
  Timer? _timer;
  List<int> _heights = const [2, 4, 3];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_tick, (_) {
      if (!mounted) return;
      setState(() {
        _heights = List.generate(_bars, (_) => 1 + _rng.nextInt(_rows));
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 16,
    height: 20,
    child: CustomPaint(
      painter: _BarsPainter(heights: _heights, rows: _rows),
    ),
  );
}

class _BarsPainter extends CustomPainter {
  _BarsPainter({required this.heights, required this.rows});

  final List<int> heights;
  final int rows;

  @override
  void paint(Canvas canvas, Size size) {
    final bars = heights.length;
    // Bars + (bars-1) gaps of 1 cell width each.
    final cellW = size.width / (bars * 2 - 1);
    final cellH = size.height / rows;
    final paint = Paint()..color = AppColors.textLcd;
    for (var b = 0; b < bars; b++) {
      final h = heights[b].clamp(0, rows);
      final x = (b * 2) * cellW;
      for (var r = 0; r < h; r++) {
        // Fill from the bottom up; subtract a hair from cellH for
        // visible cell separation.
        final y = size.height - (r + 1) * cellH;
        canvas.drawRect(
          Rect.fromLTWH(x, y, cellW, cellH - 1),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarsPainter old) => old.heights != heights;
}
