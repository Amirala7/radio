// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinates_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoordinatesDto _$CoordinatesDtoFromJson(Map<String, dynamic> json) =>
    _CoordinatesDto(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$CoordinatesDtoToJson(_CoordinatesDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
