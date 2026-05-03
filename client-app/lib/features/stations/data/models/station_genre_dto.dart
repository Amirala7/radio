import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_genre_dto.freezed.dart';
part 'station_genre_dto.g.dart';

@freezed
abstract class StationGenreDto with _$StationGenreDto {
  const factory StationGenreDto({
    String? text,
    List<String>? tags,
  }) = _StationGenreDto;

  factory StationGenreDto.fromJson(Map<String, dynamic> json) =>
      _$StationGenreDtoFromJson(json);
}
