/// {@template logger_handler}
/// [LoggerHandler] provides methods to log messages or errors.
/// {@endtemplate}
abstract interface class LoggerHandler {
  ///Initializes the logger.
  ///
  ///This method should be called after the `Bindings` are initialized. Use
  ///[globalErrorLogger] before `runZonedGuarded` is called. It will store the
  ///exceptions in memory until the logger is initialized.
  ///Usage:
  ///
  ///```dart
  ///void main() async {
  ///  final logger = HamLogger();
  ///  FlutterError.onError = logger.globalErrorLogger;
  ///  await runZonedGuarded(() async {
  ///  WidgetsFlutterBinding.ensureInitialized();
  ///  logger.initialize();
  ///  runApp(MyApp());
  ///  }, logger.globalErrorLogger);
  ///}
  ///```

  ///
  ///Before [initialize], exceptions will be stored in memory until
  ///the logger is initialized. After initialization, the exceptions will be
  ///logged calling [globalErrorLogger].
  ///
  ///After [initialize], exceptions will be logged calling [globalErrorLogger].
  void initialize();

  /// Logs error manually.
  void globalErrorLogger({
    required Object error,
    required StackTrace stackTrace,
  });

  /// logs messages or errors manually.
  /// Helps to handle the development environment.
  /// if [shouldHandle] is true, sould call logger api. if false only log on
  /// console.
  ///
  /// [isWarn] is a flag that indicates whether the log is a warning or not.
  /// if [shouldHandle] is true, [isWarn] is ignored.
  void log({
    required String message,
    StackTrace? stack,
    Object? error,
    bool isWarn = false,
    bool shouldHandle = false,
  });
}
