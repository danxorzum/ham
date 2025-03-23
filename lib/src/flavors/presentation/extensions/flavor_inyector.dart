import 'package:ham/src/core/inyector_di/inyector.dart';
import 'package:ham/src/flavors/presentation/widgets/widgets.dart';

///Extension for [Inyector] to use flavors.
extension FlavorInyector on Inyector {
  ///Get the [FlavorNotifier] of the inyector
  ///[FlavorNotifier] is a class that provides the flavor and flags.
  ///Use to control the continuous integration of the app.
  ///
  ///You can hide functionality based on the flavor of the app. or flags to
  ///control from backend.
  FlavorNotifier get flavorFlags => Inyector.get<FlavorNotifier>();
}
