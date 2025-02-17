import 'package:flutter/widgets.dart';
import 'package:ham_framework/src/flavors/enviroments.dart';

///{@template InheritedNotifier}
/// Notifier class to manage the flavor and flag of the app.
/// It is a singleton class.
///It extends [ChangeNotifier] to notify the listeners when the flag is changed,
///you can redraw the app when the flag is changed.
///{@endtemplate}
final class FlavorNotifier extends ChangeNotifier {
  ///{@macro InheritedNotifier}
  factory FlavorNotifier() => _instance;
  FlavorNotifier._internal();

  //Singleton
  static final FlavorNotifier _instance = FlavorNotifier._internal();

  late Enviroment _flavor;
  late Flag _flag;

  /// Configure the flavor and flag of the app.
  /// called in the main method.
  void configure(Enviroment flavor, Flag flag) {
    _flavor = flavor;
    _flag = flag;
  }

  /// Change the flag of the app.
  /// It notifies the listeners to redraw the app.
  void changeFlag(Flag flag) {
    _flag = flag;
    notifyListeners();
  }
}

///{@template FlavorFlags}
/// InheritedNotifier class to provide the flavor and flag of the app.
/// Use this class to get the flavor and flag of the app.
///
/// When the flag is changed, it redraws the app.
/// {@endtemplate}
final class FlavorFlags extends InheritedNotifier<FlavorNotifier> {
  ///{@macro FlavorFlags}
  const FlavorFlags({
    required super.child,
    required super.notifier,
    super.key,
  });

  //getters
  /// Get the environment of the app.
  Enviroment get flavor => notifier!._flavor;

  /// Get the flag of the app.
  Flag get flag => notifier!._flag;

  /// Find the FlavorFlags in the context.
  static FlavorFlags of(BuildContext context) {
    final inh = context.dependOnInheritedWidgetOfExactType<FlavorFlags>();
    assert(inh != null, 'No FlavorFlags found in context');
    return inh!;
  }

  @override
  bool updateShouldNotify(FlavorFlags oldWidget) {
    return oldWidget.flavor != flavor || oldWidget.flag != flag;
  }
}
