// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StationDto _$StationDtoFromJson(Map<String, dynamic> json) => _StationDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  streams: (json['streams'] as List<dynamic>)
      .map((e) => StreamDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  slug: json['slug'] as String?,
  isActive: json['isActive'] as bool?,
  logo: json['logo'] as String?,
  dial: json['dial'] == null
      ? null
      : StationDialDto.fromJson(json['dial'] as Map<String, dynamic>),
  aliases: json['aliases'] == null
      ? null
      : StationAliasesDto.fromJson(json['aliases'] as Map<String, dynamic>),
  location: json['location'] == null
      ? null
      : StationLocationDto.fromJson(json['location'] as Map<String, dynamic>),
  genre: json['genre'] == null
      ? null
      : StationGenreDto.fromJson(json['genre'] as Map<String, dynamic>),
  popularity: json['popularity'] == null
      ? null
      : StationPopularityDto.fromJson(
          json['popularity'] as Map<String, dynamic>,
        ),
  languages: (json['languages'] as List<dynamic>?)
      ?.map((e) => StationLanguageDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StationDtoToJson(_StationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'streams': instance.streams.map((e) => e.toJson()).toList(),
      'slug': instance.slug,
      'isActive': instance.isActive,
      'logo': instance.logo,
      'dial': instance.dial?.toJson(),
      'aliases': instance.aliases?.toJson(),
      'location': instance.location?.toJson(),
      'genre': instance.genre?.toJson(),
      'popularity': instance.popularity?.toJson(),
      'languages': instance.languages?.map((e) => e.toJson()).toList(),
    };
