import 'package:ham_framework/src/core/inyector/inyector.dart';
import 'package:ham_framework/src/flavors/presentation/widgets/widgets.dart';

///Extension for [Inyector] to use flavors.
extension FlavorInyector on Inyector {
  ///Get the [FlavorNotifier] of the inyector
  ///[FlavorNotifier] is a class that provides the flavor and flags.
  ///Use to control the continuous integration of the app.
  ///
  ///You can hide functionality based on the flavor of the app. or flags to
  ///control from backend.
  FlavorNotifier get flavorFlags => getIt<FlavorNotifier>();
}
