import 'dart:developer' as developer;

import 'package:ham/src/core/core.dart';
import 'package:ham/src/flavors/flavors.dart';
import 'package:ham/src/log/application/application.dart';
import 'package:ham/src/log/domain/domain.dart';

/// {@template logger}
/// Logger is logging service. Can handle production, staging and development
/// environments.
///
/// You should add to [Inyector] before `HamApp` initialization or use
/// `runHamApp` instead of `runApp`.
/// Use to add firebase crashlytics, sentry, etc.
/// {@endtemplate}
final class HamLogger implements LoggerHandler {
  /// {@macro logger}
  HamLogger({
    required void Function(Object, StackTrace) logger,
    required String appVersion,
    required Enviroment env,
    required Flag flag,
  }) : _logger = logger,
       _appVersion = appVersion,
       _flag = flag,
       _env = env;

  final void Function(Object, StackTrace) _logger;
  final String _appVersion;
  final Enviroment _env;
  final Flag _flag;

  bool _isInitialized = false;
  final _cache = <HamLogError>[];
  final LogService _logService = LogService();

  @override
  void initialize() {
    assert(_isInitialized == false, 'LogService is already initialized');
    _isInitialized = true;
    for (final error in _cache) {
      globalErrorLogger(error: error.error, stackTrace: error.stackTrace);
    }
    _cache.clear();
    developer.log(
      '\x1B[32mLogger initialized\x1B[30m',
      name: '\x1B[32mLogger\x1B[30m',
    );
  }

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
    assert(
      (shouldHandle && _isInitialized) ||
          (!shouldHandle && (_isInitialized || !_isInitialized)),
      'Initialize logger first before handle logs',
    );
    if (shouldHandle) {
      assert(
        error != null && stack != null,
        'when shouldHandle is true, error and stack must not be null',
      );
      final flavor = Inyector.get<FlavorNotifier>();
      final log = _logService.log(
        message: message,
        error: error,
        stack: stack,
        appVersion: _appVersion,
        enviroment: _env,
        flag: flavor.flag,
      );
      if (flavor.flavor == Enviroment.development) {
        developer.log(
          '\x1B[31m$log\x1B[30m',
          name: '\x1B[31mLogger Dev\x1B[30m',
          error: log.error,
          stackTrace: stack,
        );
      } else {
        _logger(log, stack ?? StackTrace.current);
      }
    } else {
      _log(message);
    }
  }

  @override
  void globalErrorLogger({
    required Object error,
    required StackTrace stackTrace,
  }) {
    if (_isInitialized) {
      final flavor = Inyector.get<FlavorNotifier>();
      final hError = _logService.errorLog(
        error: error,
        stackTrace: stackTrace,
        appVersion: _appVersion,
        enviroment: _env,
        flag: flavor.flag,
      );
      if (flavor.flavor == Enviroment.development) {
        developer.log(
          '\x1B[31m$hError\x1B[30m',
          name: '\x1B[31mLogger Dev Error\x1B[30m',
          error: hError.error,
          stackTrace: stackTrace,
        );
      } else {
        _logger(hError, stackTrace);
      }
    } else {
      _cache.add(
        HamLogError(
          error: error,
          stackTrace: stackTrace,
          appversion: _appVersion,
          enviroment: _env,
          flag: _flag,
        ),
      );
    }
  }
}
