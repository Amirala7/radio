import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PanelDecoration extends StatelessWidget {
  const PanelDecoration({super.key});

  @override
  Widget build(BuildContext context) =>
      const Positioned.fill(child: CustomPaint(painter: _Painter()));
}

class _Painter extends CustomPainter {
  const _Painter();

  @override
  void paint(Canvas canvas, Size size) {
    final screwPaint = Paint()..color = AppColors.knobDark;
    final screwSlot = Paint()
      ..color = const Color(0xFF3F3B36)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    const screwR = 4.0;
    const inset = 12.0;
    final screws = [
      Offset(inset, inset),
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      Offset(size.width - inset, size.height - inset),
    ];
    for (final c in screws) {
      canvas.drawCircle(c, screwR, screwPaint);
      canvas.drawLine(
        Offset(c.dx - screwR + 1, c.dy),
        Offset(c.dx + screwR - 1, c.dy),
        screwSlot,
      );
    }

    final grillePaint = Paint()
      ..color = AppColors.knobDark.withValues(alpha: 0.45)
      ..strokeWidth = 0.5;
    const grilleStartY = 0.78;
    for (var i = 0; i < 5; i++) {
      final y = size.height * grilleStartY + i * 4;
      if (y > size.height - 6) break;
      canvas.drawLine(
        Offset(size.width * 0.02, y),
        Offset(size.width * 0.62, y),
        grillePaint,
      );
    }

    final braun = TextPainter(
      text: TextSpan(
        text: 'BRAUN',
        style: TextStyle(
          fontFamily: 'Jost',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1A).withValues(alpha: 0.55),
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    braun.paint(
      canvas,
      Offset(size.width - braun.width - 14, size.height - braun.height - 14),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
