import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:ham_framework/src/core/core.dart';
import 'package:ham_framework/src/layout/base/base.dart';
import 'package:ham_framework/src/utils/utils.dart';

/// {@template NavLayout}
/// [NavLayout] is a responsive navigation layout.
/// It cares about the navigation bar and the bottom navigation bar, FAB etc.
///
/// Provides the Layout Controller to control the layout of the app.
/// {@endtemplate}
class NavLayout extends StatefulWidget {
  ///{@macro NavLayout}
  const NavLayout({
    required this.body,
    this.halfScaffold = false,
    this.controller,
    this.drawer,
    this.endDrawer,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.extendedFloatingActionButton,
    super.key,
  });

  /// The Layout Controller to control the layout of the app.
  final LayoutController? controller;

  /// The drawer to show on the left side of the screen.
  final Widget? drawer;

  /// The end drawer to show on the right side of the screen.
  final Widget? endDrawer;

  /// Body of the layout
  final Widget body;

  /// The app bar to show on the top of the screen.
  final PreferredSizeWidget? appBar;

  /// The bottom navigation bar to show on the bottom of the screen.
  final Widget? bottomNavigationBar;

  /// The floating action button to show on the bottom right of the screen.
  final Widget? floatingActionButton;

  /// The extended floating action button, is used when layout is extra large.
  final Widget? extendedFloatingActionButton;

  ///Half Scaffold.
  ///
  ///If true, the scaffold will be half of the screen.
  final bool halfScaffold;

  @override
  State<NavLayout> createState() => _NavLayoutState();
}

class _NavLayoutState extends State<NavLayout> {
  late final LayoutController _controller;
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    late final LayoutController controller;
    try {
      _scaffoldKey = Inyector.I.getIt<GlobalKey<ScaffoldState>>();
    } on Exception {
      _scaffoldKey = GlobalKey<ScaffoldState>();
    }
    if (widget.controller == null) {
      try {
        controller = Inyector.I.get<LayoutController>();
      } on Exception {
        controller = LayoutController();
      }
    }
    _controller = widget.controller ?? controller;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedController(
      notifier: _controller,
      child: _Body(
        scaffoldKey: _scaffoldKey,
        widget: widget,
        key: widget.key,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required this.widget,
    super.key,
  }) : _scaffoldKey = scaffoldKey;

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final NavLayout widget;

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
              key: const Key('bodySmall'),
              builder: (context) {
                return const Scaffold();
              },
            ),
          },
        ),
      ),
    );
  }
}
