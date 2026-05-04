import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SpeakerGrille extends StatelessWidget {
  const SpeakerGrille({super.key, this.cols = 8, this.rows = 6});

  final int cols;
  final int rows;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _GrillePainter(cols: cols, rows: rows));
}

class _GrillePainter extends CustomPainter {
  const _GrillePainter({required this.cols, required this.rows});

  final int cols;
  final int rows;

  @override
  void paint(Canvas canvas, Size size) {
    if (cols < 2 || rows < 2) return;
    final paint = Paint()..color = AppColors.bezelDark;
    final stepX = size.width / (cols - 1);
    final stepY = size.height / (rows - 1);
    final radius = (stepX < stepY ? stepX : stepY) * 0.18;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        canvas.drawCircle(Offset(c * stepX, r * stepY), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GrillePainter oldDelegate) =>
      oldDelegate.cols != cols || oldDelegate.rows != rows;
}
