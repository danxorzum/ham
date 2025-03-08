import 'package:flutter/widgets.dart';
import 'package:ham_framework/src/flavors/domain/enums/enums.dart';
import 'package:ham_framework/src/flavors/presentation/widgets/widgets.dart';

///Extension for [BuildContext] to use flavors.
extension FlavorContext on BuildContext {
  ///Get the [FlavorNotifier] of the context
  ///[FlavorNotifier] is a class that provides the flavor and flag of the app
  ///use to control the continuous integration of the app.
  ///
  ///You can hide functionality based on the flavor of the app. or flags to
  ///control from backend.
  FlavorNotifier get flavors => FlavorFlags.of(this).notifier!;

  ///Get the current  [Flag] of the context
  Flag get flag => flavors.flag;

  ///Get the current  [Enviroment] of the context
  Enviroment get flavor => flavors.flavor;

  ///Get the current app version of the context
  String get version => flavors.version;
}
