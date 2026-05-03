import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre.freezed.dart';

@freezed
abstract class Genre with _$Genre {
  const factory Genre({
    required int id,
    String? slug,
    String? name,
    int? radioCount,
  }) = _Genre;
}
