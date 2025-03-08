import 'dart:developer' as developer;

import 'package:ham_framework/src/core/core.dart';
import 'package:ham_framework/src/flavors/flavors.dart';
import 'package:ham_framework/src/log/domain/ham_logger_error.dart';

/// {@template logger}
/// Logger is logging service. Can handle production, staging and development
/// environments.
///
/// You should add to [Inyector] before `HamApp` initialization.
/// Use to add firebase crashlytics, sentry, etc.
///
/// if you don't provide development logger, logger use a dart logger.
/// {@endtemplate}
final class Logger implements Mortal {
  /// {@macro logger}
  Logger(
    this.appVersion,
    Enviroment enviroment, {
    required void Function(Object, StackTrace) productionLogger,
    required void Function(Object, StackTrace) stagingLogger,
    void Function(Object, StackTrace)? developmentLogger,
  })  : _enviroment = enviroment,
        _productionLogger = productionLogger,
        _stagingLogger = stagingLogger,
        _developmentLogger = developmentLogger;

  final void Function(Object, StackTrace) _productionLogger;
  final void Function(Object, StackTrace) _stagingLogger;
  final void Function(Object, StackTrace)? _developmentLogger;

  final Enviroment _enviroment;

  ///App version
  final String appVersion;

  @override
  void onAsk() {}

  @override
  void onBirth() {
    if (_enviroment == Enviroment.development) {
      developer.log(
        '\x1B[32mLogger initialized\x1B[30m',
        name: '\x1B[32mLogger\x1B[30m',
      );
    }
  }

  @override
  void onDie() {}

  @override
  Mortal onReproduce() => this;

  void _log(String message, {StackTrace? stack, Object? error}) {
    developer.log(
      '\x1B[32m$message\x1B[32m',
      stackTrace: stack,
      name: 'develop_Glogab_log',
      error: error,
    );
  }

  ///Log error to the right logger.
  ///if you don't provide flag, you must register the flag in [Inyector].
  void globalLogger({
    required Object error,
    required StackTrace stackTrace,
    Flag? flag,
  }) {
    late Flag loadedFlag;
    if (flag == null) {
      try {
        loadedFlag = Inyector.I.getIt<FlavorNotifier>().flag;
      } on Exception {
        rethrow;
      }
    } else {
      loadedFlag = flag;
    }
    final hamError = HamLoggerError(
      enviroment: _enviroment,
      flag: loadedFlag,
      appversion: appVersion,
      error: error,
      stackTrace: stackTrace,
    );

    switch (_enviroment) {
      case Enviroment.development:
        {
          if (_developmentLogger != null) {
            _developmentLogger.call(hamError.error, hamError.stackTrace);
          } else {
            developer.log(
              '\x1B[31m$hamError\x1B[30m',
              name: '\x1B[31mLogger Error\x1B[30m',
              error: hamError.error,
              stackTrace: hamError.stackTrace,
            );
          }
        }

      case Enviroment.staging:
        _stagingLogger.call(hamError, stackTrace);

      case Enviroment.production:
        _productionLogger.call(hamError, stackTrace);
    }
  }

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
  }) {
    switch (_enviroment) {
      case Enviroment.development:
        if (shouldHandle) {
          assert(
            error != null && stack != null,
            'when shouldHandle is true, error and stack must not be null',
          );
          _developmentLogger == null
              ? _log(message, stack: stack, error: error)
              : _developmentLogger(message, stack!);
        } else {
          _log(message, stack: stack, error: error);
        }
      case Enviroment.staging:
        if (shouldHandle) {
          assert(
            error != null && stack != null,
            'when shouldHandle is true, error and stack must not be null',
          );
          _stagingLogger(message, stack!);
        }
      case Enviroment.production:
        if (shouldHandle) {
          assert(
            error != null && stack != null,
            'when shouldHandle is true, error and stack must not be null',
          );
          _productionLogger(message, stack!);
        }
    }
  }
}
