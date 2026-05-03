import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

import '../audio/sfx_player.dart';
import '../auth/auth_service.dart';
import '../haptics/haptics.dart';
import '../network/cloud_functions_client.dart';
import '../volume/system_volume_sink.dart';
import '../volume/volume_controller.dart';
import '../../features/favorites/data/datasources/favorites_remote_data_source.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/genres/data/datasources/genre_remote_data_source.dart';
import '../../features/genres/data/repositories/genre_repository_impl.dart';
import '../../features/genres/domain/repositories/genre_repository.dart';
import '../../features/player/data/datasources/audio_player_data_source.dart';
import '../../features/player/data/repositories/player_repository_impl.dart';
import '../../features/player/domain/repositories/player_repository.dart';
import '../../features/stations/data/datasources/station_remote_data_source.dart';
import '../../features/stations/data/repositories/station_repository_impl.dart';
import '../../features/stations/domain/repositories/station_repository.dart';

void configureDependencies({required AuthService authService}) {
  final di = GetIt.I;

  di.registerSingleton<AuthService>(authService);
  di.registerLazySingleton<CloudFunctionsClient>(() => CloudFunctionsClient());

  di.registerLazySingleton<StationRemoteDataSource>(
    () => StationRemoteDataSource(di()),
  );
  di.registerLazySingleton<GenreRemoteDataSource>(
    () => GenreRemoteDataSource(di()),
  );
  di.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSource(FirebaseFirestore.instance),
  );
  di.registerLazySingleton<AudioPlayerDataSource>(
    () => AudioPlayerDataSource(player: AudioPlayer()),
  );

  di.registerLazySingleton<StationRepository>(
    () => StationRepositoryImpl(di()),
  );
  di.registerLazySingleton<GenreRepository>(
    () => GenreRepositoryImpl(di()),
  );
  di.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      dataSource: di(),
      authService: di(),
    ),
  );
  di.registerLazySingleton<PlayerRepository>(
    () => PlayerRepositoryImpl(di()),
  );

  di.registerLazySingleton<SfxPlayer>(SfxPlayer.new);
  di.registerLazySingleton<Haptics>(() => const Haptics());
  di.registerLazySingleton<SystemVolumeSink>(PluginSystemVolumeSink.new);
  di.registerLazySingleton<VolumeController>(
    () => VolumeController(
      player: di<PlayerRepository>(),
      system: di<SystemVolumeSink>(),
    ),
  );
}
