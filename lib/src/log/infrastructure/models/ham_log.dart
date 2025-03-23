import 'package:ham/src/flavors/flavors.dart';

/// {@template ham_log}
/// HamLogr is a class that adds  information to the logger, before
/// is sent to the crashlytics.
///
/// Adds:
/// - enviroment
/// - flag
/// - appversion
/// - error
/// {@endtemplate}
final class HamLog {
  /// {@macro ham_log}
  HamLog({
    required this.enviroment,
    required this.flag,
    required this.appversion,
    required this.message,
    this.error,
  });

  ///The message
  final String message;

  ///The current enviroment
  final Enviroment enviroment;

  ///The current flag
  final Flag flag;

  ///The current app version
  final String appversion;

  ///The error
  final Object? error;
}
