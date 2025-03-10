///Base class for `HamFramework` exceptions
///
///[HamException] has message and stack trace
abstract class HamException implements Exception {
  ///Message of the exception.
  String get message;

  ///Stack trace.
  StackTrace? get stackTrace;
}
