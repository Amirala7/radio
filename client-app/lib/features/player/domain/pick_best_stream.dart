import '../../stations/domain/entities/radio_stream.dart';

/// Picks the best stream from a station's variants.
///
/// Ranking: HTTPS preferred over non-HTTPS, then higher bitrate. Streams with
/// `works == false` are filtered out unless every stream is broken — in that
/// case the first one is returned as a last resort.
RadioStream? pickBestStream(List<RadioStream> streams) {
  if (streams.isEmpty) return null;
  final playable = streams.where((s) => s.works != false).toList();
  if (playable.isEmpty) return streams.first;

  playable.sort((a, b) {
    final httpsCmp = (b.isHttps == true ? 1 : 0) - (a.isHttps == true ? 1 : 0);
    if (httpsCmp != 0) return httpsCmp;
    return (b.bitrate ?? 0) - (a.bitrate ?? 0);
  });
  return playable.first;
}
