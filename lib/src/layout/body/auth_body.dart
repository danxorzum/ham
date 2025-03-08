import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

///{@template AuthLayout}
///[AuthBody] it's adaptive layout for auth screens from any app.
///It's a layout that has a body and a secondary body.
///
///It's a layout without a bottom navigation bar, top app bar or any other one.
///{@endtemplate}
class AuthBody extends StatelessWidget {
  ///{@macro AuthLayout}
  const AuthBody({
    required this.body,
    required this.secondaryBody,
    this.bodymedium,
    this.bodyexpanded,
    this.bodylarge,
    this.bodyextralarge,
    super.key,
  });

  ///The body of the layout. If the others sizes are not provided, it will use
  ///the same one.
  ///
  ///The body in adaptive apps represents the movile portrait view in small
  ///screens. It's equal to `Material 3` Compact window size.
  final Widget body;

  ///The secondary body of the layout.
  ///
  ///Higly recommended use an Image widget.
  ///
  ///The secondary body appears in allsized except the compact one.
  final Widget secondaryBody;

  ///The medium body of the layout.
  ///
  ///It's equal to `Material 3` Medium window size.
  final Widget? bodymedium;

  ///The expanded body of the layout.
  ///
  ///It's equal to `Material 3` expanded window size.
  final Widget? bodyexpanded;

  ///The large body of the layout.
  ///
  ///It's equal to `Material 3` Large window size.
  final Widget? bodylarge;

  ///The extra large body of the layout.
  ///
  ///It's equal to `Material 3` Extra large window size.
  final Widget? bodyextralarge;

  Widget _scaffold(Widget body) => Scaffold(body: body);

  double _getBodyRatio(BuildContext context) {
    final currenBreakpoint = Breakpoint.activeBreakpointOf(context);
    if (currenBreakpoint < Breakpoints.large) {
      return 0.6;
    }
    return 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      bodyRatio: _getBodyRatio(context),
      body: SlotLayout(
        key: const Key('AuthBody'),
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.small: SlotLayout.from(
            key: const Key('bodySmall'),
            builder: (_) => _scaffold(body),
          ),
          Breakpoints.medium: SlotLayout.from(
            key: const Key('bodyMedium'),
            builder: (_) => _scaffold(bodymedium ?? body),
          ),
          Breakpoints.mediumLarge: SlotLayout.from(
            key: const Key('bodyExpanded'),
            builder: (_) => _scaffold(
              bodyexpanded ?? bodymedium ?? body,
            ),
          ),
          Breakpoints.large: SlotLayout.from(
            key: const Key('bodyLarge'),
            builder: (_) => _scaffold(
              bodylarge ?? bodyexpanded ?? bodymedium ?? body,
            ),
          ),
          Breakpoints.extraLarge: SlotLayout.from(
            key: const Key('bodyExtraLarge'),
            builder: (_) => _scaffold(
              bodyextralarge ?? bodylarge ?? bodyexpanded ?? bodymedium ?? body,
            ),
          ),
        },
      ),
      secondaryBody: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.small: SlotLayoutConfig.empty(),
          Breakpoints.mediumAndUp: SlotLayout.from(
            key: const Key('secondaryBodySmall'),
            builder: (_) => secondaryBody,
          ),
        },
      ),
    );
  }
}
