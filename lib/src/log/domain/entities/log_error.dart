/// {@template logger_error}
/// [LogError] helps to handle the error logging.
/// {@endtemplate}
final class LogError {
  /// {@macro logger_error}
  LogError({
    required this.appversion,
    required this.error,
    required this.stackTrace,
  });

  ///The current app version
  final String appversion;

  ///The error
  final Object error;

  ///The stack trace
  final StackTrace stackTrace;
}
