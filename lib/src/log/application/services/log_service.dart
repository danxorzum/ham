import 'package:ham/src/flavors/flavors.dart';
import 'package:ham/src/log/domain/domain.dart';

/// {@template log_service}
/// [LogService] provides methods to log messages or errors.
/// {@endtemplate}
final class LogService implements LogHandler {
  @override
  HamLogError errorLog({
    required Object error,
    required StackTrace stackTrace,
    required String appVersion,
    required Enviroment enviroment,
    required Flag flag,
  }) {
    return HamLogError(
      error: error,
      stackTrace: stackTrace,
      appversion: appVersion,
      enviroment: enviroment,
      flag: flag,
    );
  }

  @override
  HamLog log({
    required String message,
    StackTrace? stack,
    Object? error,
    String? appVersion,
    Enviroment? enviroment,
    Flag? flag,
  }) {
    assert(
      (error != null &&
              stack != null &&
              appVersion != null &&
              enviroment != null &&
              flag != null) ||
          (error == null &&
              stack == null &&
              appVersion == null &&
              enviroment == null &&
              flag == null),
      'when shouldHandle is true, error and stack must not be null',
    );

    return HamLog(
      message: message,
      error: error != null
          ? HamLogError(
              appversion: appVersion!,
              error: error,
              stackTrace: stack!,
              enviroment: enviroment!,
              flag: flag!,
            )
          : null,
    );
  }
}
