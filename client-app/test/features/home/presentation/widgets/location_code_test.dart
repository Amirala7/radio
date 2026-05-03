import 'package:flutter_test/flutter_test.dart';
import 'package:radio/features/home/presentation/widgets/location_code.dart';
import 'package:radio/features/stations/domain/entities/station_location.dart';

void main() {
  test('null location returns null', () {
    expect(deriveLocationCode(null), null);
  });

  test('uses first three letters of cityName uppercased', () {
    expect(
      deriveLocationCode(const StationLocation(cityName: 'London')),
      'LON',
    );
    expect(
      deriveLocationCode(const StationLocation(cityName: 'Berlin')),
      'BER',
    );
  });

  test('cityName under 3 chars is returned as-is uppercased', () {
    expect(deriveLocationCode(const StationLocation(cityName: 'LA')), 'LA');
  });

  test('falls back to countryCode when cityName is missing', () {
    expect(deriveLocationCode(const StationLocation(countryCode: 'us')), 'US');
  });

  test('returns null when both city and countryCode are missing', () {
    expect(
      deriveLocationCode(const StationLocation(countryName: 'United States')),
      null,
    );
  });

  test('cityName whitespace is trimmed before slicing', () {
    expect(
      deriveLocationCode(const StationLocation(cityName: '  Tokyo')),
      'TOK',
    );
  });
}
