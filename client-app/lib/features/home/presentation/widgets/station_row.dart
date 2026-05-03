import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../player/domain/pick_best_stream.dart';
import '../../../player/presentation/view_models/player_view_model.dart';
import '../../../stations/domain/entities/station.dart';
import 'favorite_heart_button.dart';
import 'location_code.dart';
import 'signal_strength_glyph.dart';
import 'station_logo_tile.dart';

class StationRow extends StatelessWidget {
  const StationRow({super.key, required this.station});

  final Station station;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<PlayerViewModel>().play(station),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StationLogoTile(name: station.name, logoUrl: station.logo),
            const SizedBox(width: AppSpacing.lg),
            Expanded(child: _Body(station: station)),
            FavoriteHeartButton(station: station),
            const SizedBox(width: AppSpacing.sm),
            const SignalStrengthGlyph(),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.station});

  final Station station;

  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select<PlayerViewModel, bool>(
      (vm) => vm.currentStation?.id == station.id && vm.isPlaying,
    );
    final genres = (station.genre?.text ?? '').toUpperCase();
    final locationCode = deriveLocationCode(station.location);
    final picked = pickBestStream(station.streams);
    final bitrate = picked?.bitrate;

    final third = <String>[];
    if (isPlaying) {
      third.add('LIVE');
    } else if (bitrate != null) {
      third.add('${bitrate}KBPS');
    }
    if (locationCode != null) third.add(locationCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (isPlaying) ...[
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.accentLive,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                station.name,
                style: AppTypography.stationName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (genres.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(genres, style: AppTypography.meta),
        ],
        if (third.isNotEmpty) ...[
          const SizedBox(height: 2),
          _MetaLine(parts: third, isPlaying: isPlaying),
        ],
      ],
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.parts, required this.isPlaying});

  final List<String> parts;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    for (var i = 0; i < parts.length; i++) {
      final isLive = i == 0 && isPlaying;
      spans.add(
        TextSpan(
          text: parts[i],
          style: isLive ? AppTypography.metaLive : AppTypography.meta,
        ),
      );
      if (i < parts.length - 1) {
        spans.add(TextSpan(text: '  •  ', style: AppTypography.meta));
      }
    }
    return Text.rich(TextSpan(children: spans));
  }
}
