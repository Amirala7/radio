import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_aliases_dto.freezed.dart';
part 'station_aliases_dto.g.dart';

@freezed
abstract class StationAliasesDto with _$StationAliasesDto {
  const factory StationAliasesDto({String? cleanName, String? alsoKnownAs}) =
      _StationAliasesDto;

  factory StationAliasesDto.fromJson(Map<String, dynamic> json) =>
      _$StationAliasesDtoFromJson(json);
}
