import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_aliases.freezed.dart';

@freezed
abstract class StationAliases with _$StationAliases {
  const factory StationAliases({String? cleanName, String? alsoKnownAs}) =
      _StationAliases;
}
