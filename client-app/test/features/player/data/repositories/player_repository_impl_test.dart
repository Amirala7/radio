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
    when(() => ds.setUrlAndPlay(any())).thenAnswer((_) async {});
    when(() => ds.pause()).thenAnswer((_) async {});
    when(() => ds.resume()).thenAnswer((_) async {});
    when(() => ds.stop()).thenAnswer((_) async {});
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
      verify(() => ds.setUrlAndPlay('https://good')).called(1);

      await sub.cancel();
    });

    test('emits error and skips data source when streams are empty', () async {
      const empty = Station(id: 2, name: 'Y', streams: []);
      final emitted = <PlaybackState>[];
      final sub = repo.state.listen(emitted.add);

      await repo.play(empty);
      await Future<void>.delayed(Duration.zero);

      expect(emitted.last.status, PlaybackStatus.error);
      expect(emitted.last.error, isA<UnknownFailure>());
      verifyNever(() => ds.setUrlAndPlay(any()));

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
