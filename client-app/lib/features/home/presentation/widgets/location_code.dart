import '../../../stations/domain/entities/station_location.dart';

String? deriveLocationCode(StationLocation? location) {
  if (location == null) return null;
  final city = location.cityName?.trim();
  if (city != null && city.isNotEmpty) {
    final n = city.length < 3 ? city.length : 3;
    return city.substring(0, n).toUpperCase();
  }
  final cc = location.countryCode?.trim();
  if (cc != null && cc.isNotEmpty) {
    return cc.toUpperCase();
  }
  return null;
}
