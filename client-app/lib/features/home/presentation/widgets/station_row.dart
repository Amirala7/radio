import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../player/domain/pick_best_stream.dart';
import '../../../player/presentation/view_models/player_view_model.dart';
import '../../../stations/domain/entities/station.dart';
import '../../../stations/domain/entities/station_location.dart';
import 'favorite_heart_button.dart';
import 'station_logo_tile.dart';

enum _RowPlaybackState { idle, tuning, live }

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
    final playbackState = context.select<PlayerViewModel, _RowPlaybackState>((
      vm,
    ) {
      if (vm.currentStation?.id != station.id) return _RowPlaybackState.idle;
      if (vm.isLoading) return _RowPlaybackState.tuning;
      if (vm.isPlaying) return _RowPlaybackState.live;
      return _RowPlaybackState.idle;
    });
    final genreText = _genreText(station.genre?.text);
    final locationText = _fullLocationText(station.location);
    final picked = pickBestStream(station.streams);
    final bitrate = picked?.bitrate;

    final statusParts = <String>[];
    switch (playbackState) {
      case _RowPlaybackState.live:
        statusParts.add('LIVE');
      case _RowPlaybackState.tuning:
        statusParts.add('TUNING');
      case _RowPlaybackState.idle:
        if (bitrate != null) statusParts.add('${bitrate}KBPS');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (playbackState != _RowPlaybackState.idle) ...[
              _LiveDot(pulsing: playbackState == _RowPlaybackState.tuning),
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
        if (genreText != null) ...[
          const SizedBox(height: 2),
          Text(
            genreText,
            style: AppTypography.meta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (locationText != null) ...[
          const SizedBox(height: 2),
          Text(
            locationText,
            style: AppTypography.meta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (statusParts.isNotEmpty) ...[
          const SizedBox(height: 2),
          _MetaLine(parts: statusParts, playbackState: playbackState),
        ],
      ],
    );
  }
}

String? _genreText(String? raw) {
  if (raw == null) return null;
  final cleaned = raw.trim().toUpperCase();
  return cleaned.isEmpty ? null : cleaned;
}

String? _fullLocationText(StationLocation? loc) {
  final city = loc?.cityName?.trim();
  final country = loc?.countryName?.trim();
  final hasCity = city != null && city.isNotEmpty;
  final hasCountry = country != null && country.isNotEmpty;
  if (hasCity && hasCountry) return '$city, $country'.toUpperCase();
  if (hasCity) return city.toUpperCase();
  if (hasCountry) return country.toUpperCase();
  return null;
}

class _LiveDot extends StatefulWidget {
  const _LiveDot({required this.pulsing});

  final bool pulsing;

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    if (widget.pulsing) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_LiveDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulsing && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.pulsing && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.accentLive,
        shape: BoxShape.circle,
      ),
    );
    if (!widget.pulsing) return dot;
    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 0.3).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: dot,
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.parts, required this.playbackState});

  final List<String> parts;
  final _RowPlaybackState playbackState;

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    final firstIsAccent = playbackState != _RowPlaybackState.idle;
    for (var i = 0; i < parts.length; i++) {
      final accent = i == 0 && firstIsAccent;
      spans.add(
        TextSpan(
          text: parts[i],
          style: accent ? AppTypography.metaLive : AppTypography.meta,
        ),
      );
      if (i < parts.length - 1) {
        spans.add(TextSpan(text: '  •  ', style: AppTypography.meta));
      }
    }
    return Text.rich(TextSpan(children: spans));
  }
}
