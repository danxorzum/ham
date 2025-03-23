import 'dart:developer' as developer;

import 'package:ham/src/core/core.dart';
import 'package:ham/src/flavors/flavors.dart';
import 'package:ham/src/log/application/application.dart';
import 'package:ham/src/log/infrastructure/infrastructure.dart';

/// {@template logger}
/// Logger is logging service. Can handle production, staging and development
/// environments.
///
/// You should add to [Inyector] before `HamApp` initialization or use
/// `runHamApp` instead of `runApp`.
/// Use to add firebase crashlytics, sentry, etc.
/// {@endtemplate}
final class HamLogger implements Mortal, HamLogPort {
  /// {@macro logger}
  HamLogger({
    required LogService logService,
    required void Function(Object, StackTrace) logger,
  }) : _logService = logService,
       _logger = logger;

  final LogService _logService;
  final void Function(Object, StackTrace) _logger;

  @override
  void onAsk() {}

  @override
  void onBirth() {
    if (Inyector.get<FlavorNotifier>().flavor == Enviroment.development) {
      developer.log(
        '\x1B[32mLogger initialized\x1B[30m',
        name: '\x1B[32mLogger\x1B[30m',
      );
    }
  }

  @override
  void onDie() {}

  @override
  Mortal onReproduce() => HamLogger(logService: _logService, logger: _logger);

  void _log(String message, {StackTrace? stack, Object? error}) {
    developer.log(
      '\x1B[32m$message\x1B[32m',
      stackTrace: stack,
      name: 'develop_Glogab_log',
      error: error,
    );
  }

  /// A function that logs messages or errors manually.
  /// Helps to handle the production environment.
  /// if [shouldHandle] is true, sould call logger api. if false only log on
  /// console.
  @override
  void log({
    required String message,
    bool isWarn = false,
    StackTrace? stack,
    Object? error,
    bool shouldHandle = false,
  }) {
    if (shouldHandle) {
      assert(
        error != null && stack != null,
        'when shouldHandle is true, error and stack must not be null',
      );
      final flavor = Inyector.get<FlavorNotifier>();
      final log = HamLog(
        enviroment: flavor.flavor,
        flag: flavor.flag,
        appversion: flavor.version,
        message: message,
        error: error,
      );
      _logger(log, stack ?? StackTrace.current);
    } else {
      _log(message);
    }
  }

  @override
  void globalErrorLogger(Object error, StackTrace stackTrace) {
    final flavor = Inyector.get<FlavorNotifier>();
    final hError = HamLoggerError(
      enviroment: flavor.flavor,
      flag: flavor.flag,
      appversion: flavor.version,
      error: error,
    );
    if (flavor.flavor == Enviroment.development) {
      developer.log(
        '\x1B[31m$hError\x1B[30m',
        name: '\x1B[31mLogger Error\x1B[30m',
        error: hError.error,
        stackTrace: stackTrace,
      );
    } else {
      _logger(hError, stackTrace);
    }
  }
}
