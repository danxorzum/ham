import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ham/src/routes/route.dart';
// import 'package:go_router/go_router.dart';

///Extension for [BuildContext] to use all the Ham features.
extension HamContext on BuildContext {
  ///Get the size of the screen
  Size get sizeOf => MediaQuery.sizeOf(this);

  ///Get the [MediaQueryData] of the screen
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  ///Get the width of the context
  double get width => sizeOf.width;

  ///Get the height of the context
  double get height => sizeOf.height;

  ///Get the [ScaffoldMessengerState] of the context
  ScaffoldMessengerState get messenger => ScaffoldMessenger.of(this);

  ///Get the [ScaffoldState] of the context
  ScaffoldState get scaffold => Scaffold.of(this);

  ///Get the current [ThemeData].
  ThemeData get theme => Theme.of(this);

  ///Get the current [TextTheme].
  TextTheme get textTheme => theme.textTheme;

  ///Get the current [ColorScheme].
  ColorScheme get colorScheme => theme.colorScheme;

  //Rouer
  ///Get the [GoRouter] of the context
  GoRouter get router => GoRouter.of(this);

  ///Go to a route using the [NavigationRoute] system from eco_chillers_core.
  void goRoute(
    NavigationRoute route, {
    Object? extra,
    Map<String, String>? params,
    Map<String, String>? queryParams,
  }) {
    final resolvedPath = route.withQueryParamsAndParams(
      queryParams ?? {},
      params ?? {},
    );
    router.go(resolvedPath, extra: extra);
  }

  ///Shortcut to show a dialog.
  Future<T?> sDialog<T>(Widget dialog) =>
      showDialog(context: this, builder: (context) => dialog);
}
