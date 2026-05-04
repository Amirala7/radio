import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../core/audio/sfx_player.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../favorites/presentation/view_models/favorites_view_model.dart';
import '../../../stations/domain/entities/station.dart';
import '../../domain/entities/playback_state.dart';
import '../view_models/player_view_model.dart';
import 'lcd_playing_indicator.dart';

class LcdDisplay extends StatefulWidget {
  const LcdDisplay({super.key});

  @override
  State<LcdDisplay> createState() => _LcdDisplayState();
}

final TextStyle _lcdDecorative = AppTypography.lcdSmall.copyWith(
  fontSize: 10,
  height: 1,
);

class _LcdDisplayState extends State<LcdDisplay> {
  PlaybackStatus? _lastStatus;
  bool _useTuning1 = true;
  int _altIndex = 0;
  Timer? _altTimer;

  // Locked geometry — every row reserves its space so the bezel never grows
  // or shrinks as state changes.
  static const double _bigRowHeight = 30;

  // How long each alternate (location / genre / language) stays on screen.
  static const Duration _altInterval = Duration(seconds: 4);

  @override
  void dispose() {
    GetIt.I<SfxPlayer>().stopLoop();
    _altTimer?.cancel();
    super.dispose();
  }

  void _onStatusChanged(PlaybackStatus status) {
    if (status == _lastStatus) return;
    _lastStatus = status;
    final sfx = GetIt.I<SfxPlayer>();
    if (status == PlaybackStatus.loading) {
      final id = _useTuning1 ? SfxId.tuning1 : SfxId.tuning3;
      _useTuning1 = !_useTuning1;
      unawaited(sfx.startLoop(id));
    } else {
      unawaited(sfx.stopLoop());
    }

    if (status == PlaybackStatus.playing) {
      _startAltTimer();
    } else {
      _stopAltTimer();
    }
  }

  void _startAltTimer() {
    _altTimer?.cancel();
    _altIndex = 0;
    _altTimer = Timer.periodic(_altInterval, (_) {
      if (!mounted) return;
      setState(() => _altIndex++);
    });
  }

  void _stopAltTimer() {
    _altTimer?.cancel();
    _altTimer = null;
    _altIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select<PlayerViewModel, PlaybackState>(
      (vm) => vm.state,
    );
    _onStatusChanged(state.status);

    final isOnline = context.select<ConnectivityService, bool>(
      (s) => s.isOnline,
    );
    final String big;
    final String bottom;
    if (!isOnline) {
      big = 'CONNECTION LOST';
      bottom = 'CHECK NETWORK';
    } else {
      big = _bigText(state);
      bottom = _bottomText(state);
    }

    final screen = ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Stack(
        children: [
          Container(
            color: AppColors.surfaceLcd,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('FM', style: _lcdDecorative),
                    Text('STEREO', style: _lcdDecorative),
                  ],
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: _bigRowHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (state.status == PlaybackStatus.playing) ...[
                        Transform.translate(
                          offset: const Offset(0, 3),
                          child: const LcdPlayingIndicator(),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: _LcdMarquee(
                          text: big,
                          style: AppTypography.lcdLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(bottom, style: AppTypography.lcdSmall),
                    const _LcdFavoriteHeart(),
                  ],
                ),
              ],
            ),
          ),
          // Top inner shadow — the screen is recessed inside the bezel,
          // so the bezel lip casts a shadow on the screen's top edge.
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 2,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x80000000), Color(0x10000000)],
                  ),
                ),
              ),
            ),
          ),
          // Left inner shadow — bezel wall casts shadow on the screen's
          // left edge.
          const Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 2,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0x80000000), Color(0x10000000)],
                  ),
                ),
              ),
            ),
          ),
          // Right inner shadow — same on the right edge.
          const Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 2,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Color(0x80000000), Color(0x10000000)],
                  ),
                ),
              ),
            ),
          ),
          // Bottom inner highlight — reflected light catches the
          // screen's bottom edge, completing the recessed feel.
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 2,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x10FFFFFF), Color(0x80FFFFFF)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bezelHighlight,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x80000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Bezel surface + top-white / bottom-black 3D edges, clipped to
          // the bezel's rounded corners.
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: screen,
                ),
                // Top white highlight on the bezel lip.
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 2,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x80FFFFFF), Color(0x10FFFFFF)],
                        ),
                      ),
                    ),
                  ),
                ),
                // Bottom black shadow on the bezel underside.
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 2,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x10000000), Color(0x80000000)],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Screws sit above the bezel highlights — kept outside the
          // ClipRRect so they aren't clipped at the rounded corners.
          const Positioned(left: 4, top: 4, child: _Screw()),
          const Positioned(right: 4, top: 4, child: _Screw()),
          const Positioned(left: 4, bottom: 4, child: _Screw()),
          const Positioned(right: 4, bottom: 4, child: _Screw()),
        ],
      ),
    );
  }

  String _bigText(PlaybackState state) {
    switch (state.status) {
      case PlaybackStatus.idle:
        return 'STANDBY';
      case PlaybackStatus.loading:
        return 'TUNING…';
      case PlaybackStatus.playing:
      case PlaybackStatus.paused:
        return (state.currentStation?.name ?? '').toUpperCase();
      case PlaybackStatus.error:
        return 'NO SIGNAL';
    }
  }

  String _bottomText(PlaybackState state) {
    switch (state.status) {
      case PlaybackStatus.idle:
        return 'TAP A STATION';
      case PlaybackStatus.loading:
      case PlaybackStatus.paused:
        return '';
      case PlaybackStatus.playing:
        final station = state.currentStation;
        final loc = station?.location;
        final city = loc?.cityName?.toUpperCase().trim();
        final countryName = loc?.countryName?.toUpperCase().trim();
        final hasCity = city != null && city.isNotEmpty;
        final hasCountry = countryName != null && countryName.isNotEmpty;
        // Country code intentionally not used here — fall back to country
        // name only when there's no city.
        final locationText = hasCity
            ? city
            : hasCountry
                ? countryName
                : null;
        final genreText = station?.genre?.text?.toUpperCase().trim();
        final hasGenre = genreText != null && genreText.isNotEmpty;
        final firstLanguage = (station?.languages?.isNotEmpty ?? false)
            ? station!.languages!.first
            : null;
        final languageText =
            (firstLanguage?.name ?? firstLanguage?.code)?.toUpperCase().trim();
        final hasLanguage = languageText != null && languageText.isNotEmpty;
        final candidates = <String>[
          ?locationText,
          if (hasGenre) genreText,
          if (hasLanguage) languageText,
        ];
        if (candidates.isEmpty) return 'LIVE';
        final tag = candidates[_altIndex % candidates.length];
        return 'LIVE - $tag';
      case PlaybackStatus.error:
        return state.error == null ? 'RETRY' : 'SOMETHING WENT WRONG';
    }
  }
}

class _Screw extends StatelessWidget {
  const _Screw();

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/flat-head-cross-slot-screw-close-up-png.png',
    width: 14,
    height: 14,
    fit: BoxFit.contain,
    filterQuality: FilterQuality.medium,
  );
}

class _LcdFavoriteHeart extends StatelessWidget {
  const _LcdFavoriteHeart();

  // 7 columns × 6 rows. Outer rows are the same; the difference between
  // filled and outline lives in the interior cells.
  // .##.##.
  // #######
  // #######
  // .#####.
  // ..###..
  // ...#...
  static const _filled = <List<int>>[
    [0, 1, 1, 0, 1, 1, 0],
    [1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
    [0, 1, 1, 1, 1, 1, 0],
    [0, 0, 1, 1, 1, 0, 0],
    [0, 0, 0, 1, 0, 0, 0],
  ];
  static const _outline = <List<int>>[
    [0, 1, 1, 0, 1, 1, 0],
    [1, 0, 0, 1, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 1],
    [0, 1, 0, 0, 0, 1, 0],
    [0, 0, 1, 0, 1, 0, 0],
    [0, 0, 0, 1, 0, 0, 0],
  ];

  static const double _cell = 2;
  static const double _w = _cell * 7;
  static const double _h = _cell * 6;

  @override
  Widget build(BuildContext context) {
    final station = context.select<PlayerViewModel, Station?>(
      (vm) => vm.currentStation,
    );
    if (station == null) {
      return const SizedBox(width: _w, height: _h);
    }
    final isFavorite = context.select<FavoritesViewModel, bool>(
      (vm) => vm.isFavorite(station.id),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.read<FavoritesViewModel>().toggle(station),
      child: Padding(
        // Expand the tap target without shifting the visual position.
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
        child: SizedBox(
          width: _w,
          height: _h,
          child: CustomPaint(
            painter: _HeartPainter(grid: isFavorite ? _filled : _outline),
          ),
        ),
      ),
    );
  }
}

class _HeartPainter extends CustomPainter {
  _HeartPainter({required this.grid});

  final List<List<int>> grid;

  @override
  void paint(Canvas canvas, Size size) {
    final cols = grid[0].length;
    final rows = grid.length;
    final cellW = size.width / cols;
    final cellH = size.height / rows;
    final paint = Paint()..color = AppColors.textLcd;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        if (grid[r][c] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(c * cellW, r * cellH, cellW, cellH),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeartPainter old) => old.grid != grid;
}

class _LcdMarquee extends StatefulWidget {
  const _LcdMarquee({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  State<_LcdMarquee> createState() => _LcdMarqueeState();
}

class _LcdMarqueeState extends State<_LcdMarquee>
    with SingleTickerProviderStateMixin {
  // Marquee scroll speed in logical pixels per second.
  static const double _speed = 40;
  // Spacer between the trailing copy and the leading copy of the text.
  static const double _gap = 32;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(_LcdMarquee oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _ensureRunning(Duration duration) {
    if (_controller.duration != duration) {
      _controller.duration = duration;
    }
    if (!_controller.isAnimating) _controller.repeat();
  }

  void _ensureStopped() {
    if (_controller.isAnimating) _controller.stop();
    if (_controller.value != 0) _controller.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final tp = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          textDirection: TextDirection.ltr,
          maxLines: 1,
        )..layout();
        final textWidth = tp.width;

        if (textWidth <= maxWidth) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _ensureStopped();
          });
          return Text(
            widget.text,
            style: widget.style,
            maxLines: 1,
            softWrap: false,
          );
        }

        final cycleWidth = textWidth + _gap;
        final duration = Duration(
          milliseconds: (cycleWidth / _speed * 1000).round(),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _ensureRunning(duration);
        });

        return ClipRect(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, _) {
              return OverflowBox(
                alignment: Alignment.centerLeft,
                maxWidth: double.infinity,
                child: Transform.translate(
                  offset: Offset(-cycleWidth * _controller.value, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.text,
                        style: widget.style,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      const SizedBox(width: _gap),
                      Text(
                        widget.text,
                        style: widget.style,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}