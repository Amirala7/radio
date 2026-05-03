import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/player/domain/entities/playback_state.dart';
import 'package:radio/features/player/domain/usecases/pause_use_case.dart';
import 'package:radio/features/player/domain/usecases/play_station_use_case.dart';
import 'package:radio/features/player/domain/usecases/resume_use_case.dart';
import 'package:radio/features/player/domain/usecases/stop_use_case.dart';
import 'package:radio/features/player/domain/usecases/watch_playback_use_case.dart';
import 'package:radio/features/player/presentation/view_models/player_view_model.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockWatch extends Mock implements WatchPlaybackUseCase {}

class _MockPlay extends Mock implements PlayStationUseCase {}

class _MockPause extends Mock implements PauseUseCase {}

class _MockResume extends Mock implements ResumeUseCase {}

class _MockStop extends Mock implements StopUseCase {}

void main() {
  late StreamController<PlaybackState> controller;
  late _MockWatch watch;
  late _MockPlay play;
  late _MockPause pause;
  late _MockResume resume;
  late _MockStop stop;
  late PlayerViewModel vm;

  const station = Station(id: 1, name: 'A', streams: []);

  setUpAll(() {
    registerFallbackValue(station);
  });

  setUp(() {
    controller = StreamController<PlaybackState>.broadcast();
    watch = _MockWatch();
    play = _MockPlay();
    pause = _MockPause();
    resume = _MockResume();
    stop = _MockStop();
    when(() => watch()).thenAnswer((_) => controller.stream);
    when(() => play(any())).thenAnswer((_) async {});
    when(() => pause()).thenAnswer((_) async {});
    when(() => resume()).thenAnswer((_) async {});
    when(() => stop()).thenAnswer((_) async {});
    vm = PlayerViewModel(
      watchPlayback: watch,
      playStation: play,
      pause: pause,
      resume: resume,
      stop: stop,
    );
  });

  tearDown(() async {
    vm.dispose();
    await controller.close();
  });

  test('initial state is the default PlaybackState', () {
    expect(vm.state, const PlaybackState());
    expect(vm.isPlaying, false);
    expect(vm.isPaused, false);
    expect(vm.isLoading, false);
    expect(vm.hasError, false);
    expect(vm.currentStation, isNull);
  });

  test('mirrors emitted PlaybackState', () async {
    controller.add(
      const PlaybackState(
        status: PlaybackStatus.playing,
        currentStation: station,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(vm.state.status, PlaybackStatus.playing);
    expect(vm.isPlaying, true);
    expect(vm.currentStation, station);
  });

  test('isLoading is true when status is loading or isBuffering', () async {
    controller.add(const PlaybackState(status: PlaybackStatus.loading));
    await Future<void>.delayed(Duration.zero);
    expect(vm.isLoading, true);

    controller.add(
      const PlaybackState(status: PlaybackStatus.playing, isBuffering: true),
    );
    await Future<void>.delayed(Duration.zero);
    expect(vm.isLoading, true);

    controller.add(const PlaybackState(status: PlaybackStatus.playing));
    await Future<void>.delayed(Duration.zero);
    expect(vm.isLoading, false);
  });

  test('intent methods call matching use cases', () async {
    await vm.play(station);
    await vm.pause();
    await vm.resume();
    await vm.stop();

    verify(() => play(station)).called(1);
    verify(() => pause()).called(1);
    verify(() => resume()).called(1);
    verify(() => stop()).called(1);
  });

  test('dispose cancels subscription', () async {
    vm.dispose();
    controller.add(const PlaybackState(status: PlaybackStatus.playing));
    await Future<void>.delayed(Duration.zero);

    // state did not update after dispose
    expect(vm.state.status, PlaybackStatus.idle);
  });
}
