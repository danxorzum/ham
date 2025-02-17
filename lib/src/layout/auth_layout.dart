part of 'layouts.dart';

///{@template AuthLayout}
///[AuthLayout] it's adaptive layout for auth screens from any eco chillers app.
///It's a layout that has a body and a secondary body.
///
///It's a layout without a bottom navigation bar, top app bar or any other one.
///{@endtemplate}
class AuthLayout extends StatefulWidget {
  ///{@macro AuthLayout}
  AuthLayout({
    required this.body,
    required this.secondaryBody,
    this.bodymedium,
    this.bodyexpanded,
    this.bodylarge,
    this.bodyextralarge,
    LayoutController? controller,
    super.key,
  }) {
    _controller = controller ?? LayoutController();
  }

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

  ///Layout controller.
  ///
  ///In this layout only listen to the `canAnimate` property.
  late final LayoutController _controller;

  @override
  State<AuthLayout> createState() => AuthLayoutState();
}

///State of [AuthLayout]
class AuthLayoutState extends State<AuthLayout> {
  late bool _canAnimate;

  @override
  void initState() {
    _canAnimate = widget._controller.canAnimate;
    widget._controller.addListener(_onControllerChange);
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _canAnimate = false;
      });
    });
  }

  @override
  void dispose() {
    widget._controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    if (_canAnimate != widget._controller.canAnimate) {
      setState(() => _canAnimate = widget._controller.canAnimate);
    }
  }

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
      internalAnimations: _canAnimate,
      bodyRatio: _getBodyRatio(context),
      body: SlotLayout(
        key: const Key('Auth Layout'),
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.small: SlotLayout.from(
            key: const Key('Body Small'),
            builder: (_) => _scaffold(widget.body),
          ),
          Breakpoints.medium: SlotLayout.from(
            key: const Key('Body Medium'),
            builder: (_) => _scaffold(widget.bodymedium ?? widget.body),
          ),
          Breakpoints.mediumLarge: SlotLayout.from(
            key: const Key('Body Expanded'),
            builder: (_) => _scaffold(
              widget.bodyexpanded ?? widget.bodymedium ?? widget.body,
            ),
          ),
          Breakpoints.large: SlotLayout.from(
            key: const Key('Body Large'),
            builder: (_) => _scaffold(
              widget.bodylarge ??
                  widget.bodyexpanded ??
                  widget.bodymedium ??
                  widget.body,
            ),
          ),
          Breakpoints.extraLarge: SlotLayout.from(
            key: const Key('Body Extra Large'),
            builder: (_) => _scaffold(
              widget.bodyextralarge ??
                  widget.bodylarge ??
                  widget.bodyexpanded ??
                  widget.bodymedium ??
                  widget.body,
            ),
          ),
        },
      ),
      secondaryBody: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.small: SlotLayoutConfig.empty(),
          Breakpoints.mediumAndUp: SlotLayout.from(
            key: const Key('Secondary Body Small'),
            builder: (_) => widget.secondaryBody,
          ),
        },
      ),
    );
  }
}
