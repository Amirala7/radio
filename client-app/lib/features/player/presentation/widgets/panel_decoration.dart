import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PanelDecoration extends StatelessWidget {
  const PanelDecoration({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('BRAUN', style: _braunStyle),
        Text('DESIGN BY DIETER RAMS', style: _captionStyle),
      ],
    ),
  );
}

const TextStyle _braunStyle = TextStyle(
  fontFamily: 'Jost',
  fontSize: 12,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.2,
  color: AppColors.textOnDark,
);

const TextStyle _captionStyle = TextStyle(
  fontFamily: 'RobotoMono',
  fontSize: 8,
  letterSpacing: 1.4,
  color: AppColors.textOnDark,
);
