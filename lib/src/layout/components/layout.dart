// Copyright (c) 2025, Ham by Miguel Angel A. Navarro
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// This file is part of the Ham framework, licensed under the BSD 3-Clause License.

import 'package:flutter/material.dart';
import 'package:ham/src/core/core.dart' hide Durations;

import 'package:ham/src/layout/components/body.dart';
import 'package:ham/src/layout/components/inherited/inherited_controller.dart';
import 'package:ham/src/layout/core/core.dart';

import 'package:ham/src/layout/helpers/window_constraints.dart';
import 'package:ham/src/layout/layout_controller.dart';

/// {@template layout}
/// {@endtemplate}
abstract class Layout extends StatefulWidget {
  /// {@macro layout}
  const Layout({
    required this.body,
    super.key,
    this.controller,
    this.floatingActionButton,
  });

  /// [Body] that will be used in the layout.
  final Body body;

  /// FAB for the [Scaffold].
  final Widget? floatingActionButton;

  /// [LayoutController] that will be used in the layout.
  ///
  /// If not provided, [Layout] will found one in the [Inyector] if can't found
  /// will create a new one.
  final LayoutController? controller;

  /// [AdaptivePreferredSizeBuilder] that will be used in the top of the layout.
  ///
  /// AppBar or other preferred size widgets.
  AdaptivePreferredSizeBuilder? get topNav => null;

  /// [AdaptiveBuilder] that will be used in the bottom of the layout.
  ///
  /// BottomNavigationBar or other widgets.
  AdaptiveBuilder? get bottomNav => null;

  /// [AdaptiveBuilder] that will be used in the primary navigation of the layout.
  ///
  /// Rails, side menu, drawer, etc.
  ///
  /// On compact screens, this will be used inside the Drawer.
  /// [Scaffold.of(context).openDrawer] can open the drawer.
  AdaptiveBuilder? get primaryNav => null;

  /// [AdaptiveBuilder] that will be used in the secondary navigation of the layout.
  ///
  /// End drawer or other widgets
  ///
  /// On compact screens, this will be used inside the end drawer.
  /// [Scaffold.of(context).openEndDrawer] can open the drawer.
  AdaptiveBuilder? get secondaryNav => null;

  @override
  State<Layout> createState() => _LayoutState();
}

final class _LayoutState extends State<Layout> with TickerProviderStateMixin {
  late final LayoutController controller;
  @override
  void initState() {
    late final AnimationController animationController;
    late final Animation<double> animation;

    super.initState();
    try {
      controller = widget.controller ?? Inyector.get<LayoutController>();
    } on Exception {
      controller = LayoutController(layoutState: const LayoutState());
    }
    animationController = AnimationController(
      vsync: this,
      duration: Durations.long1,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: controller.layoutState.curve,
    );
    controller.addListener(() {
      if (controller.layoutState.canAnimate) {
        animationController.forward();
      }
    });
  }

  PreferredSizeWidget? _appBarr(BuildContext context, WindowSize screenSize) {
    return widget.topNav == null
        ? null
        : _AppbarContainer(child: widget.topNav!.call(context, screenSize));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = windowSizeFromContext(context);
    return InheritedController(
      notifier: controller,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: _appBarr(context, screenSize),
            body: const Center(child: Text('Body')),
            floatingActionButton: widget.floatingActionButton,
          );
        },
      ),
    );
  }
}

final class _AppbarContainer extends StatelessWidget
    implements PreferredSizeWidget {
  const _AppbarContainer({required this.child});

  final PreferredSizeWidget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
SlideTransition(position: position)          duration: Durations.long1,
          top: 0,
          height: 0,
          child: child,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => child.preferredSize;
}
