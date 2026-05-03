import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:radio/core/audio/sfx_player.dart';
import 'package:radio/features/player/domain/entities/playback_state.dart';
import 'package:radio/features/player/presentation/view_models/player_view_model.dart';
import 'package:radio/features/player/presentation/widgets/lcd_display.dart';
import 'package:radio/features/stations/domain/entities/radio_stream.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockPlayer extends Mock implements PlayerViewModel {}

class _FakeSfx implements SfxPlayer {
  @override
  Future<void> dispose() async {}
  @override
  Future<void> init() async {}
  @override
  Future<void> playOnce(SfxId id) async {}
  @override
  Future<void> startLoop(SfxId id) async {}
  @override
  Future<void> stopLoop() async {}
}

void main() {
  late _MockPlayer player;

  setUp(() {
    player = _MockPlayer();
    if (GetIt.I.isRegistered<SfxPlayer>()) {
      GetIt.I.unregister<SfxPlayer>();
    }
    GetIt.I.registerSingleton<SfxPlayer>(_FakeSfx());
  });

  tearDown(() {
    if (GetIt.I.isRegistered<SfxPlayer>()) {
      GetIt.I.unregister<SfxPlayer>();
    }
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<PlayerViewModel>.value(
          value: player,
          child: const Scaffold(body: LcdDisplay()),
        ),
      ),
    );
  }

  testWidgets('idle state shows STANDBY', (tester) async {
    when(() => player.state).thenReturn(const PlaybackState());
    when(() => player.isPlaying).thenReturn(false);
    when(() => player.isPaused).thenReturn(false);
    when(() => player.isLoading).thenReturn(false);
    when(() => player.hasError).thenReturn(false);
    when(() => player.currentStation).thenReturn(null);

    await pump(tester);
    expect(find.text('STANDBY'), findsOneWidget);
    expect(find.text('TAP A STATION'), findsOneWidget);
  });

  testWidgets('playing state shows station name', (tester) async {
    const station = Station(
      id: 1,
      name: 'NTS Radio',
      streams: [RadioStream(url: 'https://x', isHttps: true)],
    );
    when(() => player.state).thenReturn(
      const PlaybackState(
        status: PlaybackStatus.playing,
        currentStation: station,
      ),
    );
    when(() => player.isPlaying).thenReturn(true);
    when(() => player.isPaused).thenReturn(false);
    when(() => player.isLoading).thenReturn(false);
    when(() => player.hasError).thenReturn(false);
    when(() => player.currentStation).thenReturn(station);

    await pump(tester);
    expect(find.text('NTS RADIO'), findsOneWidget);
  });

  testWidgets('error state shows NO SIGNAL', (tester) async {
    when(
      () => player.state,
    ).thenReturn(const PlaybackState(status: PlaybackStatus.error));
    when(() => player.isPlaying).thenReturn(false);
    when(() => player.isPaused).thenReturn(false);
    when(() => player.isLoading).thenReturn(false);
    when(() => player.hasError).thenReturn(true);
    when(() => player.currentStation).thenReturn(null);

    await pump(tester);
    expect(find.text('NO SIGNAL'), findsOneWidget);
  });
}
