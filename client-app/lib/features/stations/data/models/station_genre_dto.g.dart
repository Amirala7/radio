// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_genre_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StationGenreDto _$StationGenreDtoFromJson(Map<String, dynamic> json) =>
    _StationGenreDto(
      text: json['text'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$StationGenreDtoToJson(_StationGenreDto instance) =>
    <String, dynamic>{'text': instance.text, 'tags': instance.tags};
