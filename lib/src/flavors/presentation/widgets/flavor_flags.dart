import 'package:flutter/widgets.dart';
import 'package:ham_framework/src/flavors/domain/enums/enums.dart';
import 'package:ham_framework/src/flavors/presentation/widgets/flavor_notifier.dart';

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
  Enviroment get flavor => notifier!.flavor;

  /// Get the flag of the app.
  Flag get flag => notifier!.flag;

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
