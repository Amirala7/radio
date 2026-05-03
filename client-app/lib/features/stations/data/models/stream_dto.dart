import 'package:freezed_annotation/freezed_annotation.dart';

part 'stream_dto.freezed.dart';
part 'stream_dto.g.dart';

@freezed
abstract class StreamDto with _$StreamDto {
  const factory StreamDto({
    required String url,
    int? id,
    int? bitrate,
    String? contentType,
    String? codec,
    String? protocol,
    bool? isHttps,
    bool? works,
  }) = _StreamDto;

  factory StreamDto.fromJson(Map<String, dynamic> json) =>
      _$StreamDtoFromJson(json);
}
