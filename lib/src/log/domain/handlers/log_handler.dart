import 'package:ham/src/flavors/flavors.dart';
import 'package:ham/src/log/domain/entities/entities.dart';

/// {@template log_handler}
/// [LogHandler] provides methods to log messages or errors.
/// {@endtemplate}
abstract interface class LogHandler {
  /// Logs error manually.
  HamLogError errorLog({
    required Object error,
    required StackTrace stackTrace,
    required String appVersion,
    required Enviroment enviroment,
    required Flag flag,
  });

  /// logs messages or errors manually.
  /// Helps to handle the development environment.
  HamLog log({
    required String message,
    StackTrace? stack,
    Object? error,
    String? appVersion,
    Enviroment? enviroment,
    Flag? flag,
  });
}
