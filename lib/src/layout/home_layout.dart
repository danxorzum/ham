part of 'layouts.dart';

///{@template HomeLayout}
///[HomeLayout] it's adaptive layout for home screens from any eco chillers app.
///{@endtemplate}
class HomeLayout extends StatefulWidget {
  ///{@macro HomeLayout}

  HomeLayout({
    required this.body,
    required this.routes,
    required this.currentRoute,
    this.floatingActionButton,
    this.railFloatingActionButton,
    this.logOut,
    this.bodymedium,
    this.bodyexpanded,
    this.bodylarge,
    this.bodyExtralarge,
    this.secondaryMediumBody,
    this.secondaryExpandedBody,
    this.secondaryLargeBody,
    this.secondaryExtralargeBody,
    this.tertiaryExtralargeBody,
    super.key,
    LayoutController? layoutController,
  }) : _controller = layoutController ?? LayoutController();

  ///Body of [HomeLayout] if sized bodies are null it will be used.
  ///
  ///The body in adaptive apps represents the movile portrait view in small
  ///screens. It's equal to `Material 3` Compact window size.
  final Widget body;

  ///The medium body of the layout.
  ///
  ///It's equal to `Material 3` Medium window size.
  final Widget? bodymedium;

  ///The expanded body of the layout.
  ///
  ///It's equal to `Material 3` Expanded window size.
  final Widget? bodyexpanded;

  ///The large body of the layout.
  ///
  ///It's equal to `Material 3` Large window size.
  final Widget? bodylarge;

  ///The extralarge body of the layout.
  ///
  ///It's equal to `Material 3` Extra Large window size.
  final Widget? bodyExtralarge;

  ///Secondary body of the layout. It appears on the right side of the screen
  /// since meium Breakpoint.
  final Widget? secondaryMediumBody;

  ///The medium secondary expanded body of the layout.
  ///
  ///It's equal to `Material 3` expanded window size.
  final Widget? secondaryExpandedBody;

  ///The large secondary body of the layout.
  ///
  ///It's equal to `Material 3` large window size.
  final Widget? secondaryLargeBody;

  ///The extralarge  secondary body of the layout.
  ///
  ///It's equal to `Material 3` Extra Large window size.
  final Widget? secondaryExtralargeBody;

  ///The extralarge  tertiary body of the layout.
  ///
  ///It's equal to `Material 3` Extra Large window size.
  final Widget? tertiaryExtralargeBody;

  ///Layout controller
  final LayoutController _controller;

  ///Avialable routes
  ///
  ///The order is important the first 5 routes will be in the bottom navigation
  final List<NavigationRoute> routes;

  ///Current route
  final NavigationRoute currentRoute;

  ///Log out callback.
  final Callback? logOut;

  ///Floating action button.
  ///
  ///Uses on Compact Breakpoint or Navigation open Drawers on large Breakpoints
  ///For rail use [railFloatingActionButton]
  final Widget? floatingActionButton;

  ///Rail floating action button.
  final Widget? railFloatingActionButton;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    widget._controller.addListener(_onControllerChange);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.canPop() && widget.tertiaryExtralargeBody != null) {
        _globalKey.currentState
            ?.showBottomSheet((_) => widget.tertiaryExtralargeBody!);
      }
    });
  }

  @override
  void dispose() {
    widget._controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {}

  void _onDestinationTap(int index) {
    if (index == widget.routes.length) {
      widget.logOut?.call();
      return;
    }
    context.goRoute(widget.routes[index]);
  }

  int? _getSelectedIndex() {
    for (var i = 0; i < widget.routes.length; i++) {
      if (widget.routes[i].fullPath == widget.currentRoute.fullPath) return i;
    }
    return null;
  }

  AppBar? _appBar() {
    if (widget._controller.showTopNavigation &&
        Breakpoints.small.isActive(context)) {
      return AppBar(
        title: Text(
          widget.currentRoute.labelName,
        ),
        foregroundColor: context.colorScheme.onPrimaryContainer,
        // surfaceTintColor: context.colorScheme.primary,
        backgroundColor:
            context.canPop() ? context.colorScheme.primaryContainer : null,
        centerTitle: true,
      );
    }
    return null;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget._controller,
      builder: (context, child) => Scaffold(
        key: _globalKey,
        appBar: _appBar(),
        drawer: _drawer(),

        // floatingActionButton: _floatingActionButton(),
        body: Builder(
          builder: (context) {
            return SafeArea(
              child: AdaptiveLayout(
                bodyRatio: widget._controller.bodyRatio,
                internalAnimations: widget._controller.canAnimate,
                body: _body(),
                secondaryBody: _secondaryBody(),
                bottomNavigation: _bottonNavBar(),
              ),
            );
          },
        ),
      ),
    );
  }

  SlotLayout? _bottonNavBar() {
    if (context.canPop()) return null;
    final routes =
        widget.routes.length > 5 ? widget.routes.sublist(0, 5) : widget.routes;

    return SlotLayout(
      config: <Breakpoint, SlotLayoutConfig>{
        if (!widget._controller.showBottomNavigation || routes.length < 3)
          Breakpoints.small: SlotLayoutConfig.empty(),
        if (widget._controller.showBottomNavigation && routes.length >= 3)
          Breakpoints.small: SlotLayout.from(
            key: const Key('BottomNavigation'),
            builder: (_) => NavigationBar(
              onDestinationSelected: _onDestinationTap,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex: _getSelectedIndex() ?? 1,
              destinations: routes
                  .map(
                    (route) => NavigationDestination(
                      icon: route.icon ?? const Icon(Icons.home),
                      label: route.labelName,
                    ),
                  )
                  .toList(),
            ),
          ),
        //
      },
    );
  }

  SlotLayout _secondaryBody() {
    return SlotLayout(
      key: const Key('Secondary Body'),
      config: <Breakpoint, SlotLayoutConfig>{
        Breakpoints.mediumAndUp: SlotLayout.from(
          key: const Key('Secondary Body Medium And Up'),
          builder: (_) => Padding(
            padding: const EdgeInsets.fromLTRB(12.5, 25, 25, 25),
            child: widget.secondaryExtralargeBody ??
                widget.secondaryLargeBody ??
                widget.secondaryExpandedBody ??
                widget.secondaryMediumBody ??
                SlotLayoutConfig.empty(),
          ),
        ),
        Breakpoints.extraLarge: SlotLayout.from(
          key: const Key('Secondary Body Extra Large'),
          builder: (_) => Padding(
            padding: const EdgeInsets.fromLTRB(12.5, 25, 25, 25),
            child: Row(
              children: [
                if (widget._controller.secondaryBodyRatio != null)
                  SizedBox(
                    width:
                        context.width * widget._controller.secondaryBodyRatio!,
                    child: widget.secondaryExtralargeBody ??
                        widget.secondaryLargeBody ??
                        widget.secondaryExpandedBody ??
                        widget.secondaryMediumBody ??
                        SlotLayoutConfig.empty(),
                  ),
                if (widget.secondaryExtralargeBody == null)
                  Expanded(
                    child: widget.secondaryExtralargeBody ??
                        widget.secondaryLargeBody ??
                        widget.secondaryExpandedBody ??
                        widget.secondaryMediumBody ??
                        SlotLayoutConfig.empty(),
                  ),
                if (widget.tertiaryExtralargeBody != null &&
                    (widget._controller.secondaryBodyRatio ?? 0) > 0 &&
                    (widget._controller.secondaryBodyRatio ?? 0) < 1) ...[
                  const SizedBox(width: 25),
                  Expanded(child: widget.tertiaryExtralargeBody!),
                ],
              ],
            ),
          ),
        ),
      },
    );
  }

  SlotLayout _body() {
    return SlotLayout(
      key: const Key('PrimaryBody'),
      config: <Breakpoint, SlotLayoutConfig>{
        Breakpoints.small: SlotLayout.from(
          key: const Key('Body Small'),
          builder: (_) => Stack(
            children: [
              if (widget.floatingActionButton != null && !context.canPop())
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: widget.floatingActionButton!,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: widget.body,
              ),
            ],
          ),
        ),
        Breakpoints.mediumAndUp: SlotLayout.from(
          key: const Key('Body Medium And Up'),
          builder: (_) => Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 12.5, 25),
            child: widget.bodyExtralarge ??
                widget.bodylarge ??
                widget.bodyexpanded ??
                widget.bodymedium ??
                widget.body,
          ),
        ),

        // Breakpoints.mediumLarge: SlotLayout.from(
      },
    );
  }

  NavigationDrawer? _drawer() {
    if (context.canPop()) return null;
    if (widget.routes.length < 2) return null;
    return NavigationDrawer(
      selectedIndex: _getSelectedIndex(),
      onDestinationSelected: _onDestinationTap,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'Menu',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ...widget.routes.map(
          (route) => NavigationDrawerDestination(
            icon: route.icon ?? const Icon(Icons.home),
            label: Text(route.labelName),
          ),
        ),
        // SizedBox(
        //   height: context.height * 0.8,
        // ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        NavigationDrawerDestination(
          icon: Icon(
            Icons.logout,
            color: context.colorScheme.error,
          ),
          label: Text(
            'Logout',
            style: TextStyle(color: context.colorScheme.error),
          ),
        ),
      ],
    );
  }
}
