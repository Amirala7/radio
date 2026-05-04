import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/features/player/data/datasources/audio_player_data_source.dart';
import 'package:radio/features/player/data/repositories/player_repository_impl.dart';
import 'package:radio/features/player/domain/entities/playback_state.dart';
import 'package:radio/features/stations/domain/entities/radio_stream.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockDataSource extends Mock implements AudioPlayerDataSource {}

void main() {
  late _MockDataSource ds;
  late StreamController<RawPlayerSnapshot> events;
  late PlayerRepositoryImpl repo;

  const goodStream = RadioStream(
    url: 'https://good',
    bitrate: 128,
    isHttps: true,
  );
  const station = Station(id: 1, name: 'X', streams: [goodStream]);

  setUp(() {
    ds = _MockDataSource();
    events = StreamController<RawPlayerSnapshot>.broadcast();
    when(() => ds.events).thenAnswer((_) => events.stream);
    when(
      () => ds.setSourceAndPlay(
        id: any(named: 'id'),
        url: any(named: 'url'),
        title: any(named: 'title'),
        artUrl: any(named: 'artUrl'),
      ),
    ).thenAnswer((_) async {});
    when(() => ds.pause()).thenAnswer((_) async {});
    when(() => ds.resume()).thenAnswer((_) async {});
    when(() => ds.stop()).thenAnswer((_) async {});
    when(() => ds.refresh()).thenAnswer((_) {});
    repo = PlayerRepositoryImpl(ds);
  });

  tearDown(() async {
    await events.close();
  });

  group('play(Station)', () {
    test('emits loading then forwards URL to data source', () async {
      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      await repo.play(station);
      await Future<void>.delayed(Duration.zero);

      expect(emitted, isNotEmpty);
      expect(emitted.first.status, PlaybackStatus.loading);
      expect(emitted.first.currentStation, station);
      expect(emitted.first.currentStream, goodStream);
      verify(
        () => ds.setSourceAndPlay(
          id: '1',
          url: 'https://good',
          title: 'X',
          artUrl: any(named: 'artUrl'),
        ),
      ).called(1);

      await sub.cancel();
    });

    test('ignores snapshots that arrive while setSourceAndPlay is in flight',
        () async {
      // Simulate just_audio still emitting the previous station's
      // ready+playing snapshots while we're switching sources.
      final setUrlGate = Completer<void>();
      when(
        () => ds.setSourceAndPlay(
          id: any(named: 'id'),
          url: any(named: 'url'),
          title: any(named: 'title'),
          artUrl: any(named: 'artUrl'),
        ),
      ).thenAnswer((_) => setUrlGate.future);

      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      final pending = repo.play(station);
      await Future<void>.delayed(Duration.zero);
      // Stale snapshot from the prior source — must NOT flip status to playing.
      events.add(
        const RawPlayerSnapshot(
          processingState: RawProcessingState.ready,
          playing: true,
          position: Duration.zero,
          bufferedPosition: Duration.zero,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(emitted.last.status, PlaybackStatus.loading);

      setUrlGate.complete();
      await pending;
      await sub.cancel();
    });

    test(
      'refreshes data source after switch gate drops to unstick fast streams',
      () async {
        // Reproduces the bug where a fast-prepared station played but the
        // LCD stayed on TUNING: every state event for the new source fires
        // inside setSourceAndPlay's await, hits the closed gate, and gets
        // dropped — leaving the repo stuck on the initial loading emit.
        final setUrlGate = Completer<void>();
        when(
          () => ds.setSourceAndPlay(
            id: any(named: 'id'),
            url: any(named: 'url'),
            title: any(named: 'title'),
            artUrl: any(named: 'artUrl'),
          ),
        ).thenAnswer((_) => setUrlGate.future);
        // refresh() in the real data source pulls the latest player state
        // and re-emits. Simulate that with a ready+playing snapshot — the
        // state a fast-prepared stream has settled into by the time the
        // repo asks for a refresh.
        when(() => ds.refresh()).thenAnswer((_) {
          events.add(
            const RawPlayerSnapshot(
              processingState: RawProcessingState.ready,
              playing: true,
              position: Duration.zero,
              bufferedPosition: Duration.zero,
            ),
          );
        });

        final emitted = <PlaybackState>[];
        final sub = repo.state.listen(emitted.add);

        final pending = repo.play(station);
        await Future<void>.delayed(Duration.zero);
        // While the gate is up, the new source's transitions are dropped.
        events.add(
          const RawPlayerSnapshot(
            processingState: RawProcessingState.ready,
            playing: true,
            position: Duration.zero,
            bufferedPosition: Duration.zero,
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(emitted.last.status, PlaybackStatus.loading);

        // Drop the gate. The repo's finally must call refresh() so the
        // settled state surfaces.
        setUrlGate.complete();
        await pending;
        await Future<void>.delayed(Duration.zero);

        verify(() => ds.refresh()).called(1);
        expect(emitted.last.status, PlaybackStatus.playing);

        await sub.cancel();
      },
    );

    test('emits error and skips data source when streams are empty', () async {
      const empty = Station(id: 2, name: 'Y', streams: []);
      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      await repo.play(empty);
      await Future<void>.delayed(Duration.zero);

      expect(emitted.last.status, PlaybackStatus.error);
      expect(emitted.last.error, isA<UnknownFailure>());
      verifyNever(
        () => ds.setSourceAndPlay(
          id: any(named: 'id'),
          url: any(named: 'url'),
          title: any(named: 'title'),
          artUrl: any(named: 'artUrl'),
        ),
      );

      await sub.cancel();
    });
  });

  group('state stream', () {
    test('maps ready+playing snapshot to PlaybackStatus.playing', () async {
      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      await repo.play(station);
      events.add(
        const RawPlayerSnapshot(
          processingState: RawProcessingState.ready,
          playing: true,
          position: Duration(seconds: 3),
          bufferedPosition: Duration(seconds: 5),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(emitted.last.status, PlaybackStatus.playing);
      expect(emitted.last.position, const Duration(seconds: 3));
      expect(emitted.last.bufferedPosition, const Duration(seconds: 5));
      expect(emitted.last.isBuffering, isFalse);

      await sub.cancel();
    });

    test('maps ready+!playing to PlaybackStatus.paused', () async {
      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      await repo.play(station);
      events.add(
        const RawPlayerSnapshot(
          processingState: RawProcessingState.ready,
          playing: false,
          position: Duration.zero,
          bufferedPosition: Duration.zero,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(emitted.last.status, PlaybackStatus.paused);
      await sub.cancel();
    });

    test('maps buffering snapshot to isBuffering=true', () async {
      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      await repo.play(station);
      events.add(
        const RawPlayerSnapshot(
          processingState: RawProcessingState.buffering,
          playing: true,
          position: Duration.zero,
          bufferedPosition: Duration.zero,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(emitted.last.isBuffering, isTrue);
      await sub.cancel();
    });

    test('maps errorMessage to error state via UnknownFailure', () async {
      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      await repo.play(station);
      events.add(
        const RawPlayerSnapshot(
          processingState: RawProcessingState.idle,
          playing: false,
          position: Duration.zero,
          bufferedPosition: Duration.zero,
          errorMessage: 'codec failure',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(emitted.last.status, PlaybackStatus.error);
      expect(emitted.last.error, isA<UnknownFailure>());
      expect(
        (emitted.last.error! as UnknownFailure).message,
        contains('codec failure'),
      );
      await sub.cancel();
    });
  });

  group('pause / resume / stop', () {
    test('forward to data source', () async {
      await repo.pause();
      await repo.resume();
      await repo.stop();
      verify(() => ds.pause()).called(1);
      verify(() => ds.resume()).called(1);
      verify(() => ds.stop()).called(1);
    });
  });
}
