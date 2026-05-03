import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_meta.freezed.dart';

@freezed
abstract class PageMeta with _$PageMeta {
  const factory PageMeta({
    required int page,
    required int limit,
    int? total,
    int? totalPages,
  }) = _PageMeta;
}
