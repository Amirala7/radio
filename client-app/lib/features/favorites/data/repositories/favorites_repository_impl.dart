import '../../../../core/auth/auth_service.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../../stations/domain/entities/station.dart';
import '../../domain/entities/favorite_station.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_data_source.dart';
import '../mappers/favorite_station_mapper.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({
    required FavoritesRemoteDataSource dataSource,
    required AuthService authService,
  }) : _dataSource = dataSource,
       _authService = authService;

  final FavoritesRemoteDataSource _dataSource;
  final AuthService _authService;

  String? _uid() => _authService.currentUser?.uid;

  @override
  Stream<List<FavoriteStation>> watchAll() {
    final uid = _uid();
    if (uid == null) {
      return Stream<List<FavoriteStation>>.error(
        const UnauthenticatedFailure(),
      );
    }
    return _dataSource
        .watchAll(uid)
        .map((dtos) => dtos.map((d) => d.toEntity()).toList())
        .handleError((Object e) => throw mapException(e));
  }

  @override
  Stream<bool> isFavorite(int stationId) {
    final uid = _uid();
    if (uid == null) {
      return Stream<bool>.error(const UnauthenticatedFailure());
    }
    return _dataSource
        .watchIsFavorite(uid, stationId)
        .handleError((Object e) => throw mapException(e));
  }

  @override
  Future<void> add(Station station) async {
    final uid = _uid();
    if (uid == null) throw const UnauthenticatedFailure();
    final dto = station.toFavoriteDto(addedAt: DateTime.now());
    try {
      await _dataSource.add(uid, dto);
    } catch (e) {
      throw mapException(e);
    }
  }

  @override
  Future<void> remove(int stationId) async {
    final uid = _uid();
    if (uid == null) throw const UnauthenticatedFailure();
    try {
      await _dataSource.remove(uid, stationId);
    } catch (e) {
      throw mapException(e);
    }
  }
}
