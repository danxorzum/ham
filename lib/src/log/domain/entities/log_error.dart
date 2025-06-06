import 'package:ham/src/flavors/flavors.dart';

/// {@template logger_error}
/// [HamLogError] helps to handle the error logging.
/// {@endtemplate}
final class HamLogError {
  /// {@macro logger_error}
  HamLogError({
    required this.appversion,
    required this.error,
    required this.stackTrace,
    required this.enviroment,
    required this.flag,
  });

  ///The current app version
  final String appversion;

  ///The error
  final Object error;

  ///Enviroment
  final Enviroment enviroment;

  ///Flag
  final Flag flag;

  ///The stack trace
  final StackTrace stackTrace;

  @override
  String toString() =>
      '''
HamLogError:
appversion: $appversion 
enviroment: $enviroment
flag: $flag
error: $error
''';
}
