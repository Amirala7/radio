import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:radio/features/favorites/presentation/view_models/favorites_state.dart';
import 'package:radio/features/favorites/presentation/view_models/favorites_view_model.dart';
import 'package:radio/features/favorites/presentation/widgets/pixel_heart.dart';
import 'package:radio/features/home/presentation/widgets/station_row.dart';
import 'package:radio/features/player/presentation/view_models/player_view_model.dart';
import 'package:radio/features/stations/domain/entities/radio_stream.dart';
import 'package:radio/features/stations/domain/entities/station.dart';
import 'package:radio/features/stations/domain/entities/station_genre.dart';
import 'package:radio/features/stations/domain/entities/station_location.dart';

class _MockFavorites extends Mock implements FavoritesViewModel {}

class _MockPlayer extends Mock implements PlayerViewModel {}

void main() {
  setUpAll(() => registerFallbackValue(_dummyStation()));

  late _MockFavorites favorites;
  late _MockPlayer player;

  setUp(() {
    favorites = _MockFavorites();
    player = _MockPlayer();
    when(() => favorites.state).thenReturn(const FavoritesState());
    when(() => favorites.isFavorite(any())).thenReturn(false);
    when(() => favorites.toggle(any())).thenAnswer((_) async {});
    when(() => player.currentStation).thenReturn(null);
    when(() => player.isPlaying).thenReturn(false);
    when(() => player.play(any())).thenAnswer((_) async {});
  });

  Future<void> pumpRow(WidgetTester tester, Station station) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<FavoritesViewModel>.value(value: favorites),
            ChangeNotifierProvider<PlayerViewModel>.value(value: player),
          ],
          child: Scaffold(body: StationRow(station: station)),
        ),
      ),
    );
  }

  testWidgets('renders station name and genre and location', (tester) async {
    await pumpRow(tester, _dummyStation());
    expect(find.text('NTS Radio'), findsOneWidget);
    expect(find.text('VARIOUS / ELECTRONIC'), findsOneWidget);
    expect(find.textContaining('LON'), findsOneWidget);
  });

  testWidgets('tap row calls play', (tester) async {
    final station = _dummyStation();
    await pumpRow(tester, station);
    await tester.tap(find.text('NTS Radio'));
    verify(() => player.play(station)).called(1);
  });

  testWidgets('tap heart toggles favourite without playing', (tester) async {
    final station = _dummyStation();
    await pumpRow(tester, station);
    await tester.tap(find.byType(PixelHeart));
    verify(() => favorites.toggle(station)).called(1);
    verifyNever(() => player.play(any()));
  });
}

Station _dummyStation() => const Station(
  id: 1,
  name: 'NTS Radio',
  streams: [RadioStream(url: 'https://example/stream', isHttps: true)],
  genre: StationGenre(text: 'various / electronic'),
  location: StationLocation(cityName: 'London'),
);
