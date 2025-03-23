import 'package:ham/src/core/core.dart';
import 'package:ham/src/log/domain/entities/entities.dart';

/// {@template log_handler}
/// [LogHandler] provides methods to log messages or errors.
/// {@endtemplate}
abstract interface class LogHandler {
  /// Logs error manually.
  LogError errorLog({
    required Object error,
    required StackTrace stackTrace,
    required String appVersion,
  });

  /// logs messages or errors manually.
  /// Helps to handle the development environment.
  /// if [shouldHandle] is true, sould call logger api. if false only log on
  /// console.
  ///
  /// [isWarn] is a flag that indicates whether the log is a warning or not.
  /// if [shouldHandle] is true, [isWarn] is ignored.
  Either<Log, bool> log({
    required String message,
    StackTrace? stack,
    Object? error,
    bool isWarn = false,
    bool shouldHandle = false,
  });
}
