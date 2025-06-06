import 'package:flutter/material.dart';

///{@template AppRoute}
///[NavigationRoute] is a base class to handle the app navigation thinking in
///goRouter.
///
///Use this class to define the routes of the app.
///Implement this class crating a sealed class that extends [NavigationRoute]
///to enable switch sealed class utility.
///{@endtemplate}
abstract class NavigationRoute {
  /// {@macro AppRoute}
  const NavigationRoute({
    required this.name,
    required this.path,
    required this.fullPath,
    required this.labelName,
    required this.icon,
    this.isProtected = true,
    this.enabled = true,
  });

  /// Name of the route.
  final String name;

  /// Relative path of the route
  final String path;

  /// Full path of the route
  final String fullPath;

  /// If the route is protected
  final bool isProtected;

  /// Label name of the route
  ///
  /// Label name would be show on navigation drawer, bottom navigation bar, etc.
  final String labelName;

  /// Indicate if the route is enabled for navigation
  final bool enabled;

  /// Icon of the route.
  ///
  /// Icon would be show on navigation drawer, bottom navigation bar, etc.
  final Widget? icon;

  @override
  String toString() => 'Route $name: $fullPath';

  ///Create a route with params for goRouter.
  String withParams(Map<String, String> params) {
    var fullPath = this.fullPath;
    params.forEach((key, value) {
      fullPath = fullPath.replaceAll(':$key', value);
    });
    return fullPath;
  }

  ///Create a route with query params for goRouter.
  String withQueryParams(Map<String, String> queryParams) {
    if (queryParams.isEmpty) return fullPath;

    final queryString = queryParams.entries.map(_entryBuild).join('&');
    return '$path?$queryString';
  }

  ///Create a route with params and query params for goRouter.
  String withQueryParamsAndParams(
    Map<String, String> queryParams,
    Map<String, String> params,
  ) {
    var fullPath = withParams(
      params,
    ); // Primero reemplaza los parámetros en la ruta
    if (queryParams.isNotEmpty) {
      final queryString = queryParams.entries.map(_entryBuild).join('&');
      fullPath = '$fullPath?$queryString';
    }
    return fullPath;
  }

  String _entryBuild(MapEntry<String, String> entry) =>
      '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}';
}
