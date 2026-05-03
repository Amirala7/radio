import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_language_dto.freezed.dart';
part 'station_language_dto.g.dart';

@freezed
abstract class StationLanguageDto with _$StationLanguageDto {
  const factory StationLanguageDto({
    required String code,
    String? name,
  }) = _StationLanguageDto;

  factory StationLanguageDto.fromJson(Map<String, dynamic> json) =>
      _$StationLanguageDtoFromJson(json);
}
