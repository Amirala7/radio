/// Recursively coerces values returned by Firebase plugins
/// (Cloud Functions, Firestore on iOS) into the shapes that
/// `package:json_serializable`-generated `fromJson` constructors
/// expect — `Map<String, dynamic>` and `List<dynamic>` everywhere.
///
/// `Map.cast<String, dynamic>()` is a *view* that defers casting until
/// each value is read, so nested `e as Map<String, dynamic>` inside
/// generated code still throws on a `_Map<Object?, Object?>`.
/// This helper produces real instances all the way down.
Object? coerceJson(Object? value) {
  if (value is Map) {
    return value.map<String, dynamic>(
      (k, v) => MapEntry(k.toString(), coerceJson(v)),
    );
  }
  if (value is List) {
    return value.map(coerceJson).toList();
  }
  return value;
}

Map<String, dynamic> coerceJsonMap(Object? value) {
  final coerced = coerceJson(value);
  if (coerced is Map<String, dynamic>) return coerced;
  throw StateError('Expected a Map, got ${value.runtimeType}');
}
