import 'package:freezed_annotation/freezed_annotation.dart';

import 'page_meta.dart';

part 'page.freezed.dart';

@freezed
abstract class Page<T> with _$Page<T> {
  const factory Page({
    required List<T> data,
    required PageMeta meta,
    List<String>? keywords,
  }) = _Page<T>;
}
