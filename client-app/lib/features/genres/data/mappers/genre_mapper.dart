import '../../domain/entities/genre.dart';
import '../models/genre_dto.dart';

extension GenreDtoX on GenreDto {
  Genre toEntity() => Genre(
        id: id,
        slug: slug,
        name: name,
        radioCount: radioCount,
      );
}
