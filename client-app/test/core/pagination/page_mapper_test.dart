import 'package:flutter_test/flutter_test.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_dto.dart';
import 'package:radio/core/pagination/page_mapper.dart';
import 'package:radio/core/pagination/page_meta_dto.dart';

void main() {
  group('PageMetaDtoX.toEntity', () {
    test('preserves all fields including optional ones', () {
      const dto = PageMetaDto(page: 2, limit: 20, total: 100, totalPages: 5);
      final entity = dto.toEntity();
      expect(entity.page, 2);
      expect(entity.limit, 20);
      expect(entity.total, 100);
      expect(entity.totalPages, 5);
    });

    test('keeps optionals null when absent', () {
      const dto = PageMetaDto(page: 1, limit: 20);
      final entity = dto.toEntity();
      expect(entity.total, isNull);
      expect(entity.totalPages, isNull);
    });
  });

  group('PageDtoX.toEntity', () {
    test('maps each item via the supplied itemMapper', () {
      const dto = PageDto<int>(
        data: [1, 2, 3],
        meta: PageMetaDto(page: 1, limit: 20),
      );
      final Page<String> entity = dto.toEntity((i) => i.toString());
      expect(entity.data, ['1', '2', '3']);
      expect(entity.meta.page, 1);
      expect(entity.keywords, isNull);
    });

    test('passes through keywords when present', () {
      const dto = PageDto<int>(
        data: [1],
        meta: PageMetaDto(page: 1, limit: 20),
        keywords: ['rock', 'jazz'],
      );
      final entity = dto.toEntity((i) => i.toString());
      expect(entity.keywords, ['rock', 'jazz']);
    });
  });

  group('PageDto JSON', () {
    test('round-trips with a generic decoder', () {
      final json = {
        'data': [1, 2, 3],
        'meta': {'page': 1, 'limit': 20, 'total': 3, 'totalPages': 1},
        'keywords': ['k'],
      };
      final dto = PageDto<int>.fromJson(json, (v) => v! as int);
      expect(dto.data, [1, 2, 3]);
      expect(dto.meta.total, 3);
      expect(dto.keywords, ['k']);
    });
  });
}
