import 'dart:developer' as developer;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'failures.dart';

AppFailure mapException(Object error, [StackTrace? stackTrace]) {
  final failure = _classify(error);
  developer.log(
    '${failure.runtimeType} ← ${error.runtimeType}: $error',
    name: 'failure',
    error: error,
    stackTrace: stackTrace,
  );
  return failure;
}

AppFailure _classify(Object error) {
  if (error is FirebaseFunctionsException) {
    switch (error.code) {
      case 'unauthenticated':
        return const UnauthenticatedFailure();
      case 'invalid-argument':
        return InvalidArgumentFailure(
          error.message ?? 'invalid argument',
          code: error.code,
        );
      case 'unavailable':
      case 'deadline-exceeded':
        return const NetworkFailure();
      default:
        return UnknownFailure(error.message ?? error.code);
    }
  }
  if (error is FirebaseAuthException) {
    return const UnauthenticatedFailure();
  }
  if (error is FirebaseException) {
    switch (error.code) {
      case 'permission-denied':
        return const UnauthenticatedFailure();
      case 'unavailable':
      case 'deadline-exceeded':
        return const NetworkFailure();
      default:
        return UnknownFailure(error.message ?? error.code);
    }
  }
  return UnknownFailure(error.toString());
}
