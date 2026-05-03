import 'package:freezed_annotation/freezed_annotation.dart';

part 'coordinates_dto.freezed.dart';
part 'coordinates_dto.g.dart';

@freezed
abstract class CoordinatesDto with _$CoordinatesDto {
  const factory CoordinatesDto({
    required double latitude,
    required double longitude,
  }) = _CoordinatesDto;

  factory CoordinatesDto.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesDtoFromJson(json);
}
