import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'failures.dart';

AppFailure mapException(Object error) {
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
  return UnknownFailure(error.toString());
}
