import 'package:flutter_test/flutter_test.dart';
import 'package:radio/features/genres/data/mappers/genre_mapper.dart';
import 'package:radio/features/genres/data/models/genre_dto.dart';

void main() {
  test('maps id, slug, name, radioCount', () {
    const dto = GenreDto(id: 1, slug: 'rock', name: 'Rock', radioCount: 1234);
    final genre = dto.toEntity();
    expect(genre.id, 1);
    expect(genre.slug, 'rock');
    expect(genre.name, 'Rock');
    expect(genre.radioCount, 1234);
  });

  test('keeps optional fields null', () {
    const dto = GenreDto(id: 2);
    final genre = dto.toEntity();
    expect(genre.slug, isNull);
    expect(genre.name, isNull);
    expect(genre.radioCount, isNull);
  });

  test('GenreDto JSON round-trip', () {
    final json = {'id': 1, 'slug': 'rock', 'name': 'Rock', 'radioCount': 9};
    final dto = GenreDto.fromJson(json);
    expect(dto.id, 1);
    expect(dto.radioCount, 9);
  });
}
