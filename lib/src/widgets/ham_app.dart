//Some names are too long so we ignore the rule
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ham_framework/src/core/core.dart';
import 'package:ham_framework/src/flavors/flavors.dart';
import 'package:ham_framework/src/layout/layouts.dart';

/// {@template HamApp}
/// The main widget of the app.
///
/// Use `MatertialApp.router` and add some utils for Hamframework.
/// {@endtemplate}
class HamApp extends StatefulWidget {
  /// {@macro HamApp}
  const HamApp({
    required this.router,
    required this.flavor,
    required this.flag,
    required this.version,
    this.themeAnimationCurve = Curves.linear,
    this.themeAnimationStyle,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.checkerboardOffscreenLayers = false,
    this.checkerboardRasterCacheImages = false,
    this.debugShowCheckedModeBanner = false,
    this.debugShowMaterialGrid = false,
    this.showSemanticsDebugger = false,
    this.themeMode = ThemeMode.system,
    this.showPerformanceOverlay = false,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.key,
    this.actions,
    this.backButtonDispatcher,
    this.builder,
    this.color,
    this.darkTheme,
    this.highContrastDarkTheme,
    this.highContrastTheme,
    this.locale,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.localizationsDelegates,
    this.onGenerateTitle,
    this.onNavigationNotification,
    this.restorationScopeId,
    this.routeInformationParser,
    this.routeInformationProvider,
    this.routerDelegate,
    this.scrollBehavior,
    this.shortcuts,
    this.theme,
    this.title,
  }) : super(key: key);

  ///{@macro flutter.widgets.widgetsApp.actions.seeAlso}
  final Map<Type, Action<Intent>>? actions;

  /// {@macro flutter.widgets.widgetsApp.backButtonDispatcher.seeAlso}
  final BackButtonDispatcher? backButtonDispatcher;

  /// Material specific features such as [showDialog] and [showMenu],
  /// and widgets such as [Tooltip], [PopupMenuButton], also require a
  /// [Navigator] to properly function.
  final Widget Function(BuildContext, Widget?)? builder;

  /// Turns on checkerboarding of layers rendered to offscreen bitmaps.
  final bool checkerboardOffscreenLayers;

  ///Turns on checkerboarding of raster cache images.
  final bool checkerboardRasterCacheImages;

  /// {@macro flutter.widgets.widgetsApp.color.seeAlso}
  final Color? color;

  /// dark theme
  final ThemeData? darkTheme;

  /// debugShowCheckedModeBanner
  final bool debugShowCheckedModeBanner;

  ///debugShowMaterialGrid
  final bool debugShowMaterialGrid;

  ///highContrastDarkTheme
  final ThemeData? highContrastDarkTheme;

  ///highContrastTheme
  final ThemeData? highContrastTheme;

  ///Locale
  final Locale? locale;

  ///Key
  // ignore: annotate_overrides, overridden_fields
  final Key? key;

  ///localeListResolutionCallback
  final Locale? Function(List<Locale>?, Iterable<Locale>)?
      localeListResolutionCallback;

  ///localeResolutionCallback
  final Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallback;

  ///localizationsDelegates
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  ///onGenerateTitle: ,
  final String Function(BuildContext)? onGenerateTitle;

  ///onNavigationNotification
  final bool Function(NavigationNotification)? onNavigationNotification;

  ///restorationScopeId
  final String? restorationScopeId;

  ///routeInformationParser
  final RouteInformationParser<Object>? routeInformationParser;

  ///routeInformationProvider
  final RouteInformationProvider? routeInformationProvider;

  ///routerConfig
  final GoRouter router;

  ///routerDelegate
  final RouterDelegate<Object>? routerDelegate;

  ///scrollBehavior
  final ScrollBehavior? scrollBehavior;

  ///showPerformanceOverlay
  final bool showPerformanceOverlay;

  ///shortcuts
  final Map<ShortcutActivator, Intent>? shortcuts;

  ///showSemanticsDebugger
  final bool showSemanticsDebugger;

  ///supportedLocales
  final Iterable<Locale> supportedLocales;

  ///theme
  final ThemeData? theme;

  ///themeAnimationCurve
  final Curve themeAnimationCurve;

  ///themeAnimationDuration
  final Duration themeAnimationDuration;

  ///themeAnimationStyle
  final AnimationStyle? themeAnimationStyle;

  ///themeMode
  final ThemeMode themeMode;

  ///title
  final String? title;

  ///Flavor
  final Enviroment flavor;

  ///Flag
  final Flag flag;

  ///App version
  final String version;

  @override
  State<HamApp> createState() => _HamAppState();
}

class _HamAppState extends State<HamApp> {
  @override
  void initState() {
    Inyector.I.add(LayoutController.new);
    Inyector.I.register(
      FlavorNotifier(
        version: widget.version,
        flavor: widget.flavor,
        flag: widget.flag,
      ),
    );
    Inyector.I.register<GoRouter>(widget.router);
    Inyector.I.register(GlobalKey<ScaffoldMessengerState>());
    Inyector.I.register(GlobalKey<ScaffoldState>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Inyector.I.layoutController.update(canAnimate: true);

    return FlavorFlags(
      notifier: Inyector.I.getIt<FlavorNotifier>(),
      child: MaterialApp.router(
        actions: widget.actions,
        backButtonDispatcher: widget.backButtonDispatcher,
        builder: widget.builder,
        checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
        checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
        color: widget.color,
        darkTheme: widget.darkTheme,
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        debugShowMaterialGrid: widget.debugShowMaterialGrid,
        highContrastDarkTheme: widget.highContrastDarkTheme,
        highContrastTheme: widget.highContrastTheme,
        locale: widget.locale,
        key: widget.key,
        localeListResolutionCallback: widget.localeListResolutionCallback,
        localeResolutionCallback: widget.localeResolutionCallback,
        localizationsDelegates: widget.localizationsDelegates,
        onGenerateTitle: widget.onGenerateTitle,
        onNavigationNotification: widget.onNavigationNotification,
        restorationScopeId: widget.restorationScopeId,
        routeInformationParser: widget.routeInformationParser,
        routeInformationProvider: widget.routeInformationProvider,
        routerConfig: widget.router,
        routerDelegate: widget.routerDelegate,
        scaffoldMessengerKey: Inyector.I.scaffoldMessengerKey,
        scrollBehavior: widget.scrollBehavior,
        showPerformanceOverlay: widget.showPerformanceOverlay,
        shortcuts: widget.shortcuts,
        showSemanticsDebugger: widget.showSemanticsDebugger,
        supportedLocales: widget.supportedLocales,
        theme: widget.theme,
        themeAnimationCurve: widget.themeAnimationCurve,
        themeAnimationDuration: widget.themeAnimationDuration,
        themeAnimationStyle: widget.themeAnimationStyle,
        themeMode: widget.themeMode,
        title: widget.title,
      ),
    );
  }
}
