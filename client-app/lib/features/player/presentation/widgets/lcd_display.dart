import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../core/audio/sfx_player.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/playback_state.dart';
import '../view_models/player_view_model.dart';

class LcdDisplay extends StatefulWidget {
  const LcdDisplay({super.key});

  @override
  State<LcdDisplay> createState() => _LcdDisplayState();
}

class _LcdDisplayState extends State<LcdDisplay> {
  Timer? _scanTimer;
  String _scanText = '';
  PlaybackStatus? _lastStatus;
  bool _useTuning1 = true;

  static const _scanChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ0123456789-_';

  @override
  void dispose() {
    _scanTimer?.cancel();
    GetIt.I<SfxPlayer>().stopLoop();
    super.dispose();
  }

  void _onStatusChanged(PlaybackStatus status) {
    if (status == _lastStatus) return;
    _lastStatus = status;
    final sfx = GetIt.I<SfxPlayer>();
    if (status == PlaybackStatus.loading) {
      _startScan();
      final id = _useTuning1 ? SfxId.tuning1 : SfxId.tuning3;
      _useTuning1 = !_useTuning1;
      unawaited(sfx.startLoop(id));
    } else {
      _stopScan();
      unawaited(sfx.stopLoop());
    }
  }

  void _startScan() {
    _scanTimer?.cancel();
    _scanTimer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      final rnd = Random();
      final buf = List.generate(
        8,
        (_) => _scanChars[rnd.nextInt(_scanChars.length)],
      ).join();
      if (mounted) setState(() => _scanText = buf);
    });
  }

  void _stopScan() {
    _scanTimer?.cancel();
    _scanTimer = null;
    if (mounted) setState(() => _scanText = '');
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
    final time = _timeText(state);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLcd,
        border: Border.all(color: AppColors.textLcd, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
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
              Text('FM', style: AppTypography.lcdSmall),
              Text('STEREO', style: AppTypography.lcdSmall),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 28,
            child: Center(
              child: Text(
                big,
                style: AppTypography.lcdLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (mid.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                mid,
                style: AppTypography.lcdSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(live, style: AppTypography.lcdSmall),
              Text(time, style: AppTypography.lcdSmall),
            ],
          ),
        ],
      ),
    );
  }

  String _bigText(PlaybackState state) {
    switch (state.status) {
      case PlaybackStatus.idle:
        return 'STANDBY';
      case PlaybackStatus.loading:
        return _scanText.isEmpty ? 'TUNING…' : _scanText;
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
    return error.toString();
  }

  String _liveText(PlaybackState state) {
    if (state.status == PlaybackStatus.playing) {
      final city = state.currentStation?.location?.cityName;
      final code = (city != null && city.length >= 3)
          ? city.substring(0, 3).toUpperCase()
          : (state.currentStation?.location?.countryCode ?? '').toUpperCase();
      return code.isEmpty ? 'LIVE' : 'LIVE • $code';
    }
    return '';
  }

  String _timeText(PlaybackState state) {
    if (state.status == PlaybackStatus.idle ||
        state.status == PlaybackStatus.error) {
      return '--:--';
    }
    final secs = state.position.inSeconds;
    final mm = (secs ~/ 60).toString().padLeft(2, '0');
    final ss = (secs % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}
