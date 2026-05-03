// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PageDto<T> _$PageDtoFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _PageDto<T>(
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
  meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
  keywords: (json['keywords'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$PageDtoToJson<T>(
  _PageDto<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'data': instance.data.map(toJsonT).toList(),
  'meta': instance.meta.toJson(),
  'keywords': instance.keywords,
};
