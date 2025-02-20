import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:ham_framework/src/core/core.dart';
import 'package:ham_framework/src/layout/base/base.dart';
import 'package:ham_framework/src/utils/utils.dart';

/// {@template NavLayout}
/// [NavlessLayout] is a responsive navigation layout.
///It's a layout without a bottom navigation bar, top app bar or any other one.

///
/// Provides the Layout Controller to control the layout of the app.
/// {@endtemplate}
class NavlessLayout extends StatefulWidget {
  ///{@macro NavLayout}
  const NavlessLayout({
    required this.body,
    this.halfScaffold = false,
    this.controller,
    super.key,
  });

  /// The Layout Controller to control the layout of the app.
  final LayoutController? controller;

  /// Body of the layout
  final Widget body;

  ///Half Scaffold.
  ///
  ///If true, the scaffold will be half of the screen.
  final bool halfScaffold;

  @override
  State<NavlessLayout> createState() => _NavlessLayoutState();
}

class _NavlessLayoutState extends State<NavlessLayout> {
  late final LayoutController _controller;

  @override
  void initState() {
    late final LayoutController controller;
    if (widget.controller == null) {
      try {
        controller = Inyector.I.get<LayoutController>();
      } on Exception {
        controller = LayoutController();
      }
    }
    _controller = widget.controller ?? controller;

    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return InheritedController(
          notifier: _controller,
          child: _Body(
            body: widget.body,
            // key: widget.key,
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.body,
    super.key,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final controller = InheritedController.of(context);
    assert(controller != null, 'No LayoutController found in context');
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
      ),
      child: AdaptiveLayout(
        body: SlotLayout(
          config: {
            Breakpoints.smallAndUp: SlotLayout.from(
              key: const Key('body'),
              builder: (context) {
                return body;
              },
            ),
          },
        ),
      ),
    );
  }
}
