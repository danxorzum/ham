import 'package:ham/src/core/core.dart';

/// {@template bootstrap}
/// Bootstrap base class.
///
/// Bootstrap gets the dependencies to use `Ham`
/// `Ham` use `Inyector` to inject dependencies.
///
/// - use `Inyector` in [bootstrap] to inject dependencies.
/// - framework dependencies are injected in `runHamApp` before [bootstrap]
/// {@endtemplate}.
abstract base class Bootstrap {
  ///`Ham` bootstrap is called before the application starts.
  /// Loads and configure your external libraries & dependencies
  ///
  /// If you need to inyect dependencies ise `Inyector` in [bootstrap]
  ///
  /// `runHamApp` calls [bootstrap] method after the framework dependencies are
  /// injected, so you can get all global dependencies from [Inyector] in
  ///[bootstrap].
  ///
  ///Bostrap is called before the application starts. and after the dependencies
  ///are injected.
  Future<void> bootstrap();

  ///Use your favorite logging service
  void logger(Object object, StackTrace stackTrace);

  ///Use to configure your logging service
  ///
  ///Only configure your logging service here.
  ///
  ///For inject dependencies or other configuration use [bootstrap]
  Future<void> loadLogger();
}
