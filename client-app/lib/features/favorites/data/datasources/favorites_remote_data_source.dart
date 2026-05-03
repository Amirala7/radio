import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/favorite_station_dto.dart';

class FavoritesRemoteDataSource {
  FavoritesRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _favoritesCol(String uid) =>
      _firestore.collection('users').doc(uid).collection('favorites');

  Stream<List<FavoriteStationDto>> watchAll(String uid) {
    return _favoritesCol(uid)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => FavoriteStationDto.fromMap(d.data()))
            .toList());
  }

  Stream<bool> watchIsFavorite(String uid, int stationId) {
    return _favoritesCol(uid)
        .doc(stationId.toString())
        .snapshots()
        .map((d) => d.exists);
  }

  Future<void> add(String uid, FavoriteStationDto dto) async {
    await _favoritesCol(uid)
        .doc(dto.station.id.toString())
        .set(dto.toMap());
  }

  Future<void> remove(String uid, int stationId) async {
    await _favoritesCol(uid).doc(stationId.toString()).delete();
  }
}
