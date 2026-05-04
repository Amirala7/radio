import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart' as ja;

/// `audio_service`-backed handler for the single station-playback engine.
///
/// We use `audio_service` directly instead of `just_audio_background`
/// because the latter's `mediaItem.add(...)` is gated behind
/// `.distinct(TrackInfo(currentIndex, duration))` — for a live radio
/// that's always `(0, null)`, so every station switch past the first
/// gets suppressed and the lock-screen stays stuck on station A.
/// Owning the handler lets us push [mediaItem] explicitly per
/// [openStation], which sidesteps the dedup entirely.
///
/// Known iOS limitation: the lock-screen widget shows on the first
/// background but disappears once the app is foregrounded and
/// re-backgrounded. iOS picks a "now playing app" via opaque heuristics
/// at the moment of backgrounding; pushing `setActive(true)`,
/// re-publishing `playbackState`, toggling pause/play — none reliably
/// re-claim source-app status from this layer. Fixing it would require
/// custom platform channels around `MPRemoteCommandCenter`.
class RadioAudioHandler extends BaseAudioHandler {
  RadioAudioHandler() {
    _attach();
  }

  final ja.AudioPlayer _player = ja.AudioPlayer();

  /// Exposed for the data source to layer its own RawPlayerSnapshot
  /// stream on top — the data source's contract with the repository is
  /// independent of the handler's `mediaItem`/`playbackState` plumbing.
  ja.AudioPlayer get player => _player;

  // Set in [stop], cleared in [openStation]. Gates whether we forward
  // `ja.ProcessingState.idle` to audio_service: a transient idle from
  // just_audio (AVAudioSession interruption, platform suspend) trips
  // audio_service's `_observePlaybackState` into calling `stopService`,
  // which clears `MPNowPlayingInfoCenter.nowPlayingInfo` and
  // `commandCenter` for the rest of the process — there's no path back
  // to the lock-screen widget without a fresh
  // `commandCenter == nil → playing` transition.
  bool _stopRequested = false;

  StreamSubscription<ja.PlayerState>? _stateSub;

  Future<void> openStation({
    required String id,
    required String url,
    required String title,
    String? artUrl,
  }) async {
    _stopRequested = false;
    final item = MediaItem(
      id: id,
      title: title,
      artUri: (artUrl != null && artUrl.isNotEmpty)
          ? Uri.tryParse(artUrl)
          : null,
      // Tells the iOS plugin to mark this as a live stream
      // (`MPNowPlayingInfoPropertyIsLiveStream`) — hides the scrubber.
      extras: const {'isLive': true},
    );
    // Push the new MediaItem BEFORE setAudioSource so audio_service
    // already holds the right tag by the time playback events flow.
    mediaItem.add(item);
    queue.add([item]);
    await _player.setAudioSource(ja.AudioSource.uri(Uri.parse(url)));
    // just_audio's play() Future only resolves when playback STOPS —
    // for a live stream that's effectively never. Fire-and-forget.
    unawaited(_player.play());
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    _stopRequested = true;
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    // Live stream: ignore.
  }

  Future<void> setVolume(double v) => _player.setVolume(v.clamp(0.0, 1.0));

  void _attach() {
    _stateSub = _player.playerStateStream.listen((_) => _publishState());
  }

  void _publishState() {
    final s = _player.playerState;
    // Mask transient just_audio idles unless we asked to stop. See the
    // [_stopRequested] field comment.
    final processing =
        (s.processingState == ja.ProcessingState.idle && !_stopRequested)
            ? AudioProcessingState.ready
            : _mapProcessing(s.processingState);
    playbackState.add(
      PlaybackState(
        controls: [
          if (s.playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
        ],
        systemActions: const {MediaAction.play, MediaAction.pause},
        androidCompactActionIndices: const [0, 1],
        processingState: processing,
        playing: s.playing,
        updatePosition: Duration.zero,
        bufferedPosition: _player.bufferedPosition,
        speed: 1.0,
      ),
    );
  }

  AudioProcessingState _mapProcessing(ja.ProcessingState s) {
    switch (s) {
      case ja.ProcessingState.idle:
        return AudioProcessingState.idle;
      case ja.ProcessingState.loading:
        return AudioProcessingState.loading;
      case ja.ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ja.ProcessingState.ready:
        return AudioProcessingState.ready;
      case ja.ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  Future<void> shutdown() async {
    await _stateSub?.cancel();
    await _player.dispose();
  }
}
