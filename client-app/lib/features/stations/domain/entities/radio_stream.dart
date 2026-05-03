import 'package:freezed_annotation/freezed_annotation.dart';

part 'radio_stream.freezed.dart';

@freezed
abstract class RadioStream with _$RadioStream {
  const factory RadioStream({
    required String url,
    int? id,
    int? bitrate,
    String? contentType,
    String? codec,
    String? protocol,
    bool? isHttps,
    bool? works,
  }) = _RadioStream;
}
