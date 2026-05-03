import 'dart:developer' as developer;

import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsClient {
  CloudFunctionsClient({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instanceFor(region: _region);

  static const _region = 'europe-west1';

  final FirebaseFunctions _functions;

  LoggedCallable call(String name) =>
      LoggedCallable(name, _functions.httpsCallable(name));
}

class LoggedCallable {
  LoggedCallable(this._name, this._inner);

  static const _logName = 'cf';

  final String _name;
  final HttpsCallable _inner;

  Future<HttpsCallableResult<T>> call<T extends Object?>([
    Object? parameters,
  ]) async {
    final sw = Stopwatch()..start();
    developer.log('→ $_name ${_summarise(parameters)}', name: _logName);
    try {
      final result = await _inner.call<T>(parameters);
      sw.stop();
      developer.log('← $_name OK (${sw.elapsedMilliseconds}ms)', name: _logName);
      return result;
    } on FirebaseFunctionsException catch (e, st) {
      sw.stop();
      developer.log(
        '← $_name ERR ${e.code} (${sw.elapsedMilliseconds}ms) ${e.message ?? ''}',
        name: _logName,
        error: e,
        stackTrace: st,
      );
      rethrow;
    } catch (e, st) {
      sw.stop();
      developer.log(
        '← $_name FAIL (${sw.elapsedMilliseconds}ms) $e',
        name: _logName,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }
}

String _summarise(Object? parameters) {
  if (parameters == null) return '';
  if (parameters is Map) {
    final entries = parameters.entries
        .map((e) => '${e.key}=${e.value}')
        .join(' ');
    return entries.isEmpty ? '' : '{$entries}';
  }
  return '$parameters';
}
