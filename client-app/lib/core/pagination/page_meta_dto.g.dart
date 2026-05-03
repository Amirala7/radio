// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_meta_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PageMetaDto _$PageMetaDtoFromJson(Map<String, dynamic> json) => _PageMetaDto(
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
);

Map<String, dynamic> _$PageMetaDtoToJson(_PageMetaDto instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
    };
