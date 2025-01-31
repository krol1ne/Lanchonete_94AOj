abstract class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException([String message = 'Invalid email or password'])
      : super(message);
}

class ServerException extends AuthException {
  ServerException([String message = 'Failed to connect to the server'])
      : super(message);
}

class CacheException extends AuthException {
  CacheException([String message = 'Failed to access local storage'])
      : super(message);
}
