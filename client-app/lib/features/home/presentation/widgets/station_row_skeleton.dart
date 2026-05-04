import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class StationsListSkeleton extends StatefulWidget {
  const StationsListSkeleton({super.key, this.rowCount = 8});

  final int rowCount;

  @override
  State<StationsListSkeleton> createState() => _StationsListSkeletonState();
}

class _StationsListSkeletonState extends State<StationsListSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _alpha;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _alpha = Tween<double>(begin: 0.18, end: 0.42).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _alpha,
      builder: (_, _) {
        final color = AppColors.textSecondary.withValues(alpha: _alpha.value);
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.rowCount,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (_, _) => StationRowSkeleton(blockColor: color),
        );
      },
    );
  }
}

class StationRowSkeleton extends StatelessWidget {
  const StationRowSkeleton({super.key, required this.blockColor});

  final Color blockColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Block(
            width: AppSpacing.stationTileSize,
            height: AppSpacing.stationTileSize,
            color: blockColor,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _Line(widthFactor: 0.70, height: 16, color: blockColor),
                const SizedBox(height: 6),
                _Line(widthFactor: 0.50, height: 11, color: blockColor),
                const SizedBox(height: 4),
                _Line(widthFactor: 0.35, height: 11, color: blockColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.widthFactor,
    required this.height,
    required this.color,
  });

  final double widthFactor;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: _Block(height: height, color: color),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({this.width, required this.height, required this.color});

  final double? width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
