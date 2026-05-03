// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenreDto _$GenreDtoFromJson(Map<String, dynamic> json) => _GenreDto(
  id: (json['id'] as num).toInt(),
  slug: json['slug'] as String?,
  name: json['name'] as String?,
  radioCount: (json['radioCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$GenreDtoToJson(_GenreDto instance) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'name': instance.name,
  'radioCount': instance.radioCount,
};
