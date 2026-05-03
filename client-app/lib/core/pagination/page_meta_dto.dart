import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_meta_dto.freezed.dart';
part 'page_meta_dto.g.dart';

@freezed
abstract class PageMetaDto with _$PageMetaDto {
  const factory PageMetaDto({
    required int page,
    required int limit,
    int? total,
    int? totalPages,
  }) = _PageMetaDto;

  factory PageMetaDto.fromJson(Map<String, dynamic> json) =>
      _$PageMetaDtoFromJson(json);
}
