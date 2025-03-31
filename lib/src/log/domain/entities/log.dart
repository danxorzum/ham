import 'package:ham/src/log/domain/entities/log_error.dart';

/// {@template log}
/// [HamLog] helps to handle the logging.
/// {@endtemplate}
final class HamLog {
  /// {@macro log}
  const HamLog({required this.message, this.error});

  /// Message to be logged
  final String message;

  /// Error to be logged
  final HamLogError? error;

  @override
  String toString() =>
      'HamLog(message: $message,  ${error != null ? 'error: $error ' : ''})';
}
