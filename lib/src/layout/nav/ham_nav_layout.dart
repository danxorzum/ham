import 'package:flutter/material.dart';
import 'package:ham/src/core/core.dart';
import 'package:ham/src/layout/base/base.dart';

/// {@template NavLayout}
/// [HamNavLayout] is a stateful widget that configures the [LayoutController]
/// and add the [LayoutController] to the widget context.
/// {@endtemplate}
class HamNavLayout extends StatefulWidget {
  /// {@macro NavLayout}
  const HamNavLayout({required this.builder, this.controller, super.key});

  ///Builder for the body of the layout
  final Widget Function(BuildContext context, LayoutController controller)
  builder;

  ///Layout controller
  final LayoutController? controller;

  @override
  State<HamNavLayout> createState() => _NavLayoutState();
}

class _NavLayoutState extends State<HamNavLayout> {
  late final LayoutController _controller;

  LayoutController get controller => _controller;

  @override
  void initState() {
    super.initState();
    late final LayoutController controller;
    if (widget.controller == null) {
      try {
        controller = Inyector.get<LayoutController>();
      } on Exception {
        controller = LayoutController();
      }
    }
    _controller = widget.controller ?? controller;
    if (controller.canAnimate) {
      Future.delayed(
        controller.animationDuration,
        () => controller.update(canAnimate: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedController(
      notifier: _controller,
      child: Builder(
        builder: (context) {
          return widget.builder(context, _controller);
        },
      ),
    );
  }
}
