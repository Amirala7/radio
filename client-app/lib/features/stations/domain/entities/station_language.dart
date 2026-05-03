import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_language.freezed.dart';

@freezed
abstract class StationLanguage with _$StationLanguage {
  const factory StationLanguage({
    required String code,
    String? name,
  }) = _StationLanguage;
}
