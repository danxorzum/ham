import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:ham/src/layout/base/base.dart';
import 'package:ham/src/layout/nav/ham_nav_layout.dart';
import 'package:ham/src/utils/utils.dart';

/// {@template NavLayout}
/// [NavlessLayout] is a responsive navigation layout.
///It's a layout without a bottom navigation bar, top app bar or any other one.

///
/// Provides the Layout Controller to control the layout of the app.
/// {@endtemplate}
class NavlessLayout extends StatelessWidget {
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
  Widget build(BuildContext _) {
    log('NavlessLayout build');
    return HamNavLayout(
      builder: (context, controller) {
        log('HamNavlessLayout builder');
        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.theme.scaffoldBackgroundColor,
          ),
          child: AdaptiveLayout(
            internalAnimations: controller.canAnimate,
            transitionDuration: controller.animationDuration,
            body: SlotLayout(
              config: {
                Breakpoints.smallAndUp: SlotLayout.from(
                  key: const Key('body'),
                  builder: (context) => body,
                ),
              },
            ),
          ),
        );
      },
    );
  }
}
