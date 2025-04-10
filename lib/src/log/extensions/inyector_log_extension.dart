import 'package:ham/src/core/core.dart';
import 'package:ham/src/log/application/ham_logger.dart';

///Add logging shortcuts to [Inyector]
extension ContextLogExtension on Inyector {
  ///Logs a message
  void log({
    required String message,
    bool isWarn = false,
    StackTrace? stack,
    Object? error,
    bool shouldHandle = false,
  }) => Inyector.get<HamLogger>().log(
    message: message,

    isWarn: isWarn,
    stack: stack,
    error: error,
    shouldHandle: shouldHandle,
  );
}
