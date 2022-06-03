// Login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class TooManyRequestsAuthException implements Exception {}

// register exceptions
class EmailAlreadyInUseAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class UserAlreadyLinked implements Exception {}

class InvalidVerificationCode implements Exception {}

class InvalidVerificationId implements Exception {}

class UserMissMatch implements Exception {}

class WrongEmail implements Exception {}

class InvalidCredential implements Exception {}

class OperationNotAllowed implements Exception {}

// generic exceptions

class GenericAuthException implements Exception {}

class UserNotLoggedInException implements Exception {}

class InternalErrorException implements Exception {}

class NetworkErrorException implements Exception {}
