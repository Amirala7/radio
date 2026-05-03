import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:radio/core/errors/failure_mapper.dart';
import 'package:radio/core/errors/failures.dart';

void main() {
  group('mapException — FirebaseFunctionsException', () {
    test('unauthenticated maps to UnauthenticatedFailure', () {
      final f = mapException(
        FirebaseFunctionsException(message: 'no auth', code: 'unauthenticated'),
      );
      expect(f, isA<UnauthenticatedFailure>());
    });

    test('invalid-argument maps to InvalidArgumentFailure', () {
      final f = mapException(
        FirebaseFunctionsException(message: 'bad', code: 'invalid-argument'),
      );
      expect(f, isA<InvalidArgumentFailure>());
      expect((f as InvalidArgumentFailure).message, 'bad');
    });

    test('unavailable maps to NetworkFailure', () {
      final f = mapException(
        FirebaseFunctionsException(message: '', code: 'unavailable'),
      );
      expect(f, isA<NetworkFailure>());
    });
  });

  group('mapException — FirebaseAuthException', () {
    test('any code maps to UnauthenticatedFailure', () {
      final f = mapException(
        FirebaseAuthException(code: 'user-not-found', message: 'gone'),
      );
      expect(f, isA<UnauthenticatedFailure>());
    });
  });

  group('mapException — FirebaseException (Firestore)', () {
    test('permission-denied maps to UnauthenticatedFailure', () {
      final f = mapException(
        FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
      );
      expect(f, isA<UnauthenticatedFailure>());
    });

    test('unavailable maps to NetworkFailure', () {
      final f = mapException(
        FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
      );
      expect(f, isA<NetworkFailure>());
    });

    test('arbitrary code maps to UnknownFailure with message', () {
      final f = mapException(
        FirebaseException(
          plugin: 'cloud_firestore',
          code: 'aborted',
          message: 'tx clash',
        ),
      );
      expect(f, isA<UnknownFailure>());
      expect((f as UnknownFailure).message, contains('tx clash'));
    });
  });

  group('mapException — fallthrough', () {
    test('arbitrary error maps to UnknownFailure', () {
      final f = mapException(StateError('boom'));
      expect(f, isA<UnknownFailure>());
    });
  });
}
