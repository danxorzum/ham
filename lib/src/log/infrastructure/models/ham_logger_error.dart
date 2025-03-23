import 'package:ham/src/flavors/flavors.dart';

/// {@template ham_logger_error}
/// HamLoggerError is a class that adds error information to the logger, before
/// the error is sent to the crashlytics.
///
/// Adds:
/// - enviroment
/// - flag
/// - appversion
/// {@endtemplate}
final class HamLoggerError {
  /// {@macro ham_logger_error}
  HamLoggerError({
    required this.enviroment,
    required this.flag,
    required this.appversion,
    required this.error,
  });

  ///The current enviroment
  final Enviroment enviroment;

  ///The current flag
  final Flag flag;

  ///The current app version
  final String appversion;

  ///The error
  final Object error;
}
