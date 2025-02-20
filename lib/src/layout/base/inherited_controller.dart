import 'package:flutter/material.dart';
import 'package:ham_framework/src/layout/base/layout_controller.dart';

/// {@template InheritedController}
/// InheritedNotifier class to manage the layout controller of the app.
/// {@endtemplate}
final class InheritedController extends InheritedNotifier<LayoutController> {
  /// {@macro InheritedController}
  const InheritedController({
    required LayoutController notifier,
    required super.child,
    super.key,
  }) : super(notifier: notifier);

  ///Returns the layout controller of the app or null if it's not found.
  static LayoutController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedController>()
        ?.notifier;
  }
}
