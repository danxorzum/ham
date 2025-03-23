///Base class for `Ham` exceptions
///
///[HamException] has message and stack trace
abstract class HamException implements Exception {
  ///Message of the exception.
  String get message;

  ///Suggestion of the exception
  String get suggestion;

  ///Stack trace.
  StackTrace? get stackTrace;
}
