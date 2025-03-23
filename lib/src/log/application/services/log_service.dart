import 'package:ham/src/core/core.dart';
import 'package:ham/src/log/domain/domain.dart';

/// {@template log_service}
/// [LogService] provides methods to log messages or errors.
/// {@endtemplate}
final class LogService implements LogHandler {
  @override
  LogError errorLog({
    required Object error,
    required StackTrace stackTrace,
    required String appVersion,
  }) => LogError(error: error, stackTrace: stackTrace, appversion: appVersion);

  @override
  Either<Log, bool> log({
    required String message,
    bool isWarn = false,
    StackTrace? stack,
    Object? error,
    bool shouldHandle = false,
  }) {
    if (shouldHandle) {
      return Either(left: Log(message: message, error: error, stack: stack));
    }
    return Either(right: isWarn);
  }
}
