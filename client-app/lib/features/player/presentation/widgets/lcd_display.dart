import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../core/audio/sfx_player.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/playback_state.dart';
import '../view_models/player_view_model.dart';
import 'lcd_playing_indicator.dart';

class LcdDisplay extends StatefulWidget {
  const LcdDisplay({super.key});

  @override
  State<LcdDisplay> createState() => _LcdDisplayState();
}

class _LcdDisplayState extends State<LcdDisplay> {
  PlaybackStatus? _lastStatus;
  bool _useTuning1 = true;

  // Locked geometry — every row reserves its space so the bezel never grows
  // or shrinks as state changes.
  static const double _bigRowHeight = 30;
  static const double _midRowHeight = 16;

  @override
  void dispose() {
    GetIt.I<SfxPlayer>().stopLoop();
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
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select<PlayerViewModel, PlaybackState>(
      (vm) => vm.state,
    );
    _onStatusChanged(state.status);

    final big = _bigText(state);
    final mid = _midText(state);
    final live = _liveText(state);

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
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('FM', style: AppTypography.lcdSmall),
                    Text('STEREO', style: AppTypography.lcdSmall),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: _bigRowHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (state.status == PlaybackStatus.playing) ...[
                        const LcdPlayingIndicator(),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          big,
                          style: AppTypography.lcdLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: _midRowHeight,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      mid,
                      style: AppTypography.lcdSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(live, style: AppTypography.lcdSmall),
                  ],
                ),
              ],
            ),
          ),
          // Inner shadow on the top edge — subtle "the LCD sits below the
          // bezel lip" cue. Top-only and very light.
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 6,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x1F000000), Color(0x00000000)],
                  ),
                ),
              ),
            ),
          ),
          // Inner shadow on the top edge — subtle "the LCD sits below the
          // bezel lip" cue. Top-only and very light.
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 20,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color.fromARGB(13, 0, 0, 0), Color(0x00000000)],
                  ),
                ),
              ),
            ),
          ),
          // Soft white highlight on the bottom edge — completes the inset
          // bevel feel: dark above, light below.
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 6,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00FFFFFF), Color(0x1FFFFFFF)],
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
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: screen,
          ),
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

  String _midText(PlaybackState state) {
    switch (state.status) {
      case PlaybackStatus.idle:
        return 'TAP A STATION';
      case PlaybackStatus.loading:
        return '';
      case PlaybackStatus.playing:
      case PlaybackStatus.paused:
        return '';
      case PlaybackStatus.error:
        return _failureText(state.error) ?? 'RETRY';
    }
  }

  String? _failureText(Object? error) {
    if (error == null) return null;
    return 'Something went wrong';
  }

  String _liveText(PlaybackState state) {
    if (state.status != PlaybackStatus.playing) return '';
    final loc = state.currentStation?.location;
    final city = loc?.cityName?.toUpperCase().trim();
    final country = loc?.countryCode?.toUpperCase().trim();
    final tag = (city != null && city.isNotEmpty)
        ? city
        : (country ?? '');
    return tag.isEmpty ? 'LIVE' : 'LIVE • $tag';
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
