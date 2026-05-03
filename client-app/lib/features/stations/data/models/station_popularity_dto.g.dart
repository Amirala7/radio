// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_popularity_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StationPopularityDto _$StationPopularityDtoFromJson(
  Map<String, dynamic> json,
) => _StationPopularityDto(
  global: (json['global'] as num?)?.toInt(),
  byCountry: (json['byCountry'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
);

Map<String, dynamic> _$StationPopularityDtoToJson(
  _StationPopularityDto instance,
) => <String, dynamic>{
  'global': instance.global,
  'byCountry': instance.byCountry,
};
