import 'package:freezed_annotation/freezed_annotation.dart';

import 'station_aliases_dto.dart';
import 'station_dial_dto.dart';
import 'station_genre_dto.dart';
import 'station_language_dto.dart';
import 'station_location_dto.dart';
import 'station_popularity_dto.dart';
import 'stream_dto.dart';

part 'station_dto.freezed.dart';
part 'station_dto.g.dart';

@freezed
abstract class StationDto with _$StationDto {
  const factory StationDto({
    required int id,
    required String name,
    required List<StreamDto> streams,
    String? slug,
    bool? isActive,
    String? logo,
    StationDialDto? dial,
    StationAliasesDto? aliases,
    StationLocationDto? location,
    StationGenreDto? genre,
    StationPopularityDto? popularity,
    List<StationLanguageDto>? languages,
  }) = _StationDto;

  factory StationDto.fromJson(Map<String, dynamic> json) =>
      _$StationDtoFromJson(json);
}
