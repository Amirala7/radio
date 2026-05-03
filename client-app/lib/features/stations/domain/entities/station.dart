import 'package:freezed_annotation/freezed_annotation.dart';

import 'radio_stream.dart';
import 'station_aliases.dart';
import 'station_dial.dart';
import 'station_genre.dart';
import 'station_language.dart';
import 'station_location.dart';
import 'station_popularity.dart';

part 'station.freezed.dart';

@freezed
abstract class Station with _$Station {
  const factory Station({
    required int id,
    required String name,
    required List<RadioStream> streams,
    String? slug,
    bool? isActive,
    String? logo,
    StationDial? dial,
    StationAliases? aliases,
    StationLocation? location,
    StationGenre? genre,
    StationPopularity? popularity,
    List<StationLanguage>? languages,
  }) = _Station;
}
