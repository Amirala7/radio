import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_popularity_dto.freezed.dart';
part 'station_popularity_dto.g.dart';

@freezed
abstract class StationPopularityDto with _$StationPopularityDto {
  const factory StationPopularityDto({
    int? global,
    Map<String, int>? byCountry,
  }) = _StationPopularityDto;

  factory StationPopularityDto.fromJson(Map<String, dynamic> json) =>
      _$StationPopularityDtoFromJson(json);
}
