import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_dial.freezed.dart';

@freezed
abstract class StationDial with _$StationDial {
  const factory StationDial({
    String? band,
    String? dial,
    String? dialStripped,
  }) = _StationDial;
}
