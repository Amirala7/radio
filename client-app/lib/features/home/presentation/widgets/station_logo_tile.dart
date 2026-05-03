import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class StationLogoTile extends StatelessWidget {
  const StationLogoTile({
    super.key,
    required this.name,
    this.logoUrl,
    this.size = 96,
  });

  final String name;
  final String? logoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final url = logoUrl;
    return SizedBox(
      width: size,
      height: size,
      child: ColoredBox(
        color: const Color(0xFF1A1A1A),
        child: url == null || url.isEmpty
            ? _Initials(name: name, dark: true)
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _Initials(name: name, dark: true),
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : _Initials(name: name, dark: true),
              ),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.name, required this.dark});

  final String name;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final initials = _initialsOf(name);
    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1A1A1A) : AppColors.surfaceBody,
        border: Border.all(
          color: dark ? const Color(0xFF1A1A1A) : AppColors.textPrimary,
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            initials,
            textAlign: TextAlign.center,
            style: AppTypography.stationName.copyWith(
              color: dark ? AppColors.surfaceBody : AppColors.textPrimary,
              fontSize: 22,
              height: 1.05,
            ),
          ),
        ),
      ),
    );
  }
}

String _initialsOf(String name) {
  final words = name
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList(growable: false);
  if (words.isEmpty) return '?';
  final letters = words.take(4).map((w) => w[0].toUpperCase()).join();
  return letters;
}
