import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'core/audio/sfx_player.dart';
import 'core/auth/auth_service.dart';
import 'core/di/dependencies.dart';
import 'core/theme/app_spacing.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_typography.dart';
import 'features/favorites/domain/usecases/add_favorite_use_case.dart';
import 'features/favorites/domain/usecases/remove_favorite_use_case.dart';
import 'features/favorites/domain/usecases/toggle_favorite_use_case.dart';
import 'features/favorites/domain/usecases/watch_favorites_use_case.dart';
import 'features/favorites/presentation/view_models/favorites_view_model.dart';
import 'features/genres/domain/usecases/list_genres_use_case.dart';
import 'features/home/presentation/view_models/home_view_model.dart';
import 'features/genres/presentation/view_models/genres_view_model.dart';
import 'features/player/domain/usecases/pause_use_case.dart';
import 'features/player/domain/usecases/play_station_use_case.dart';
import 'features/player/domain/usecases/resume_use_case.dart';
import 'features/player/domain/usecases/stop_use_case.dart';
import 'features/player/domain/usecases/watch_playback_use_case.dart';
import 'features/player/presentation/view_models/player_view_model.dart';
import 'features/stations/domain/usecases/get_popular_stations_use_case.dart';
import 'features/stations/domain/usecases/get_stations_by_genre_use_case.dart';
import 'features/stations/domain/usecases/list_stations_use_case.dart';
import 'features/stations/domain/usecases/search_stations_use_case.dart';
import 'features/stations/presentation/view_models/stations_view_model.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final auth = AuthService();
  await auth.ensureSignedIn();

  configureDependencies(authService: auth);
  await GetIt.I<SfxPlayer>().init();

  runApp(const RadioApp());
}

class RadioApp extends StatelessWidget {
  const RadioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final di = GetIt.I;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StationsViewModel(
            listStations: ListStationsUseCase(di()),
            popularStations: GetPopularStationsUseCase(di()),
            searchStations: SearchStationsUseCase(di()),
            stationsByGenre: GetStationsByGenreUseCase(di()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => GenresViewModel(
            listGenres: ListGenresUseCase(di()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesViewModel(
            watchFavorites: WatchFavoritesUseCase(di()),
            addFavorite: AddFavoriteUseCase(di()),
            removeFavorite: RemoveFavoriteUseCase(di()),
            toggleFavorite: ToggleFavoriteUseCase(di()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PlayerViewModel(
            watchPlayback: WatchPlaybackUseCase(di()),
            playStation: PlayStationUseCase(di()),
            pause: PauseUseCase(di()),
            resume: ResumeUseCase(di()),
            stop: StopUseCase(di()),
          ),
        ),
        ChangeNotifierProxyProvider<StationsViewModel, HomeViewModel>(
          create: (ctx) =>
              HomeViewModel(stations: ctx.read<StationsViewModel>()),
          update: (_, stations, prev) =>
              prev ?? HomeViewModel(stations: stations),
        ),
      ],
      child: MaterialApp(
        title: 'Radio',
        theme: AppTheme.light,
        home: const _BootHome(),
      ),
    );
  }
}

class _BootHome extends StatelessWidget {
  const _BootHome();

  @override
  Widget build(BuildContext context) {
    final user = GetIt.I<AuthService>().currentUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('raDio', style: AppTypography.wordmark),
              const SizedBox(height: AppSpacing.xl),
              const Text('ALL STATIONS', style: AppTypography.sectionLabel),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                user == null ? 'Not signed in' : 'Signed in as ${user.uid}',
                style: AppTypography.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}