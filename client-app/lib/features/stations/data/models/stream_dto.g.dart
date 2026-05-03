// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StreamDto _$StreamDtoFromJson(Map<String, dynamic> json) => _StreamDto(
  url: json['url'] as String,
  id: (json['id'] as num?)?.toInt(),
  bitrate: (json['bitrate'] as num?)?.toInt(),
  contentType: json['contentType'] as String?,
  codec: json['codec'] as String?,
  protocol: json['protocol'] as String?,
  isHttps: json['isHttps'] as bool?,
  works: json['works'] as bool?,
);

Map<String, dynamic> _$StreamDtoToJson(_StreamDto instance) =>
    <String, dynamic>{
      'url': instance.url,
      'id': instance.id,
      'bitrate': instance.bitrate,
      'contentType': instance.contentType,
      'codec': instance.codec,
      'protocol': instance.protocol,
      'isHttps': instance.isHttps,
      'works': instance.works,
    };
