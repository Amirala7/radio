import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinates.dart';

part 'station_location.freezed.dart';

@freezed
abstract class StationLocation with _$StationLocation {
  const factory StationLocation({
    int? cityId,
    String? cityName,
    String? countryName,
    String? countryCode,
    String? locationText,
    Coordinates? coordinates,
  }) = _StationLocation;
}
