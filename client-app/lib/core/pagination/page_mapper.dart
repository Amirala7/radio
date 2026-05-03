import 'page.dart';
import 'page_dto.dart';
import 'page_meta.dart';
import 'page_meta_dto.dart';

extension PageMetaDtoX on PageMetaDto {
  PageMeta toEntity() => PageMeta(
        page: page,
        limit: limit,
        total: total,
        totalPages: totalPages,
      );
}

extension PageDtoX<T> on PageDto<T> {
  Page<E> toEntity<E>(E Function(T) itemMapper) => Page<E>(
        data: data.map(itemMapper).toList(),
        meta: meta.toEntity(),
        keywords: keywords,
      );
}
