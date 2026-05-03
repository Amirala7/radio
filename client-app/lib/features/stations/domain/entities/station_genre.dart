import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_genre.freezed.dart';

@freezed
abstract class StationGenre with _$StationGenre {
  const factory StationGenre({
    String? text,
    List<String>? tags,
  }) = _StationGenre;
}
