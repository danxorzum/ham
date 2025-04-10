import 'package:flutter/widgets.dart';
import 'package:ham/src/layout/core/enums/window_size.dart';

/// Returns the window size based on the context.
///
///{@template windowSize}
/// Screen siezes are based on [Material 3]
///
/// [WindowSize.compact] - Usually a portrait phone.
/// [WindowSize.medium] - Usually a landscape phone. or portrait tablet.
/// [WindowSize.expanded] - Usually a landscape tablet or a small desktop.
/// [WindowSize.large] - Usually a large desktot or big landscape tablet.
/// [WindowSize.extraLarge] - Usually a big desktop.
///
/// Returns [WindowSize.compact] if the width is less than 600.
/// Returns [WindowSize.medium] if the width is less than 1024.
/// Returns [WindowSize.expanded] if the width is less than 1280.
/// Returns [WindowSize.large] if the width is less than 1920.
/// Returns [WindowSize.extraLarge] if the width is greater than large.
/// {@endtemplate}
WindowSize windowSizeFromContext(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 600) {
    return WindowSize.compact;
  } else if (width < 1024) {
    return WindowSize.medium;
  } else if (width < 1280) {
    return WindowSize.expanded;
  } else if (width < 1920) {
    return WindowSize.large;
  } else {
    return WindowSize.extraLarge;
  }
}

/// Returns the window size based Constrains
///
/// {@macro windowSize}
WindowSize windowSizeFromConstraints(BoxConstraints constraints) {
  if (constraints.maxWidth < 600) {
    return WindowSize.compact;
  } else if (constraints.maxWidth < 1024) {
    return WindowSize.medium;
  } else if (constraints.maxWidth < 1280) {
    return WindowSize.expanded;
  } else if (constraints.maxWidth < 1920) {
    return WindowSize.large;
  } else {
    return WindowSize.extraLarge;
  }
}
