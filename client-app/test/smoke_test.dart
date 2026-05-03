import 'package:flutter_test/flutter_test.dart';
import 'package:radio/core/errors/failures.dart';

void main() {
  test('UnknownFailure carries its message', () {
    const failure = UnknownFailure('boom');
    expect(failure.message, 'boom');
    expect(failure, isA<AppFailure>());
  });
}
