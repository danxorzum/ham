/// {@template log}
/// [Log] helps to handle the logging.
/// {@endtemplate}
final class Log {
  /// {@macro log}
  const Log({required this.message, this.stack, this.error});

  /// Message to be logged
  final String message;

  /// Stack trace to be logged
  final StackTrace? stack;

  /// Error to be logged
  final Object? error;
}
