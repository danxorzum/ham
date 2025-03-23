/// {@template ham_log_port}
/// Port for logging service.
/// {@endtemplate}
abstract interface class HamLogPort {
  ///Log error should use in runzoneguard or main function to catch uncaught
  ///errors and report them using console or firebase crashlytics or sentry or
  ///any other error logger.
  void globalErrorLogger(Object error, StackTrace stackTrace);

  /// A function that logs messages or errors manually.
  /// Helps to handle the production environment.
  /// if [shouldHandle] is true, sould call logger api. if false only log on
  /// console.
  void log({
    required String message,
    bool isWarn = false,
    StackTrace? stack,
    Object? error,
    bool shouldHandle = false,
  });
}
