import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SignalStrengthGlyph extends StatelessWidget {
  const SignalStrengthGlyph({
    super.key,
    this.color = AppColors.textPrimary,
    this.size = const Size(22, 18),
  });

  final Color color;
  final Size size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: size, painter: _Painter(color));
}

class _Painter extends CustomPainter {
  _Painter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final barWidth = size.width / 5;
    for (var i = 0; i < 3; i++) {
      final h = size.height * (0.4 + i * 0.3);
      final x = i * barWidth * 1.6;
      final y = size.height - h;
      canvas.drawRect(Rect.fromLTWH(x, y, barWidth, h), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _Painter oldDelegate) =>
      oldDelegate.color != color;
}
