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
    final genres = (station.genre?.text ?? '').toUpperCase();
    final locationCode = deriveLocationCode(station.location);
    final picked = pickBestStream(station.streams);
    final bitrate = picked?.bitrate;

    final third = <String>[];
    switch (playbackState) {
      case _RowPlaybackState.live:
        third.add('LIVE');
      case _RowPlaybackState.tuning:
        third.add('TUNING');
      case _RowPlaybackState.idle:
        if (bitrate != null) third.add('${bitrate}KBPS');
    }
    if (locationCode != null) third.add(locationCode);

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
        if (genres.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(genres, style: AppTypography.meta),
        ],
        if (third.isNotEmpty) ...[
          const SizedBox(height: 2),
          _MetaLine(parts: third, playbackState: playbackState),
        ],
      ],
    );
  }
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
