// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StationLocationDto _$StationLocationDtoFromJson(Map<String, dynamic> json) =>
    _StationLocationDto(
      cityId: (json['cityId'] as num?)?.toInt(),
      cityName: json['cityName'] as String?,
      countryName: json['countryName'] as String?,
      countryCode: json['countryCode'] as String?,
      locationText: json['locationText'] as String?,
      coordinates: json['coordinates'] == null
          ? null
          : CoordinatesDto.fromJson(
              json['coordinates'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$StationLocationDtoToJson(_StationLocationDto instance) =>
    <String, dynamic>{
      'cityId': instance.cityId,
      'cityName': instance.cityName,
      'countryName': instance.countryName,
      'countryCode': instance.countryCode,
      'locationText': instance.locationText,
      'coordinates': instance.coordinates,
    };
