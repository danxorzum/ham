import 'package:flutter/widgets.dart';
import 'package:ham/src/layout/layout_controller.dart';

/// {@template InheritedController}
/// Insert and listener for the layout controller of the view.
/// {@endtemplate}
final class InheritedController extends InheritedNotifier<LayoutController> {
  /// {@macro InheritedController}
  const InheritedController({
    required LayoutController notifier,
    required super.child,
    super.key,
  }) : super(notifier: notifier);

  ///Returns the layout controller of the app or null if it's not found.
  static LayoutController of(BuildContext context) {
    final controller =
        context
            .dependOnInheritedWidgetOfExactType<InheritedController>()
            ?.notifier;
    assert(
      controller != null,
      //Message to long so we ignore 80 chars rule.
      // ignore: lines_longer_than_80_chars
      'No LayoutController found in context ensure you are using InheritedController or HamNavigatorLayout',
    );
    return controller!;
  }
}
