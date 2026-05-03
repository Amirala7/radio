import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinates_dto.dart';

part 'station_location_dto.freezed.dart';
part 'station_location_dto.g.dart';

@freezed
abstract class StationLocationDto with _$StationLocationDto {
  const factory StationLocationDto({
    int? cityId,
    String? cityName,
    String? countryName,
    String? countryCode,
    String? locationText,
    CoordinatesDto? coordinates,
  }) = _StationLocationDto;

  factory StationLocationDto.fromJson(Map<String, dynamic> json) =>
      _$StationLocationDtoFromJson(json);
}
