import 'package:flutter_test/flutter_test.dart';
import 'package:radio/features/player/domain/pick_best_stream.dart';
import 'package:radio/features/stations/domain/entities/radio_stream.dart';

void main() {
  test('returns null for empty list', () {
    expect(pickBestStream(const []), isNull);
  });

  test('returns the only stream', () {
    const a = RadioStream(url: 'https://a');
    expect(pickBestStream(const [a]), a);
  });

  test('prefers higher bitrate', () {
    const low = RadioStream(url: 'https://low', bitrate: 64, isHttps: true);
    const high = RadioStream(url: 'https://high', bitrate: 128, isHttps: true);
    expect(pickBestStream(const [low, high]), high);
  });

  test('prefers HTTPS even when bitrate is lower', () {
    const httpHi = RadioStream(url: 'http://hi', bitrate: 192, isHttps: false);
    const httpsLo = RadioStream(url: 'https://lo', bitrate: 64, isHttps: true);
    expect(pickBestStream(const [httpHi, httpsLo]), httpsLo);
  });

  test('skips works == false candidates', () {
    const broken =
        RadioStream(url: 'https://b', bitrate: 320, isHttps: true, works: false);
    const ok = RadioStream(url: 'https://ok', bitrate: 64, isHttps: true);
    expect(pickBestStream(const [broken, ok]), ok);
  });

  test('falls back to first when all are works == false', () {
    const a = RadioStream(url: 'https://a', works: false);
    const b = RadioStream(url: 'https://b', works: false);
    expect(pickBestStream(const [a, b]), a);
  });

  test('treats missing bitrate as 0 when ranking', () {
    const noBitrate = RadioStream(url: 'https://x', isHttps: true);
    const withBitrate = RadioStream(url: 'https://y', bitrate: 1, isHttps: true);
    expect(pickBestStream(const [noBitrate, withBitrate]), withBitrate);
  });
}
