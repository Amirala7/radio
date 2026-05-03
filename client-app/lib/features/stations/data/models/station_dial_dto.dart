import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_dial_dto.freezed.dart';
part 'station_dial_dto.g.dart';

@freezed
abstract class StationDialDto with _$StationDialDto {
  const factory StationDialDto({
    String? band,
    String? dial,
    String? dialStripped,
  }) = _StationDialDto;

  factory StationDialDto.fromJson(Map<String, dynamic> json) =>
      _$StationDialDtoFromJson(json);
}
