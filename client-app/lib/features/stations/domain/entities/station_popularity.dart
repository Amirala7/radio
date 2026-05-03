import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_popularity.freezed.dart';

@freezed
abstract class StationPopularity with _$StationPopularity {
  const factory StationPopularity({int? global, Map<String, int>? byCountry}) =
      _StationPopularity;
}
