sealed class AppFailure {
  const AppFailure();
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure();
}

final class UnauthenticatedFailure extends AppFailure {
  const UnauthenticatedFailure();
}

final class InvalidArgumentFailure extends AppFailure {
  const InvalidArgumentFailure(this.message, {this.code});

  final String message;
  final String? code;
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure(this.message);

  final String message;
}
