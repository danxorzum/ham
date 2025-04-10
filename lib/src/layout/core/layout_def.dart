import 'package:flutter/widgets.dart';
import 'package:ham/src/layout/core/enums/enums.dart';

/// [AdaptiveBuilder] is a function that returns a [Widget] based on the
/// [BuildContext] and [WindowSize].
typedef AdaptiveBuilder =
    Widget Function(BuildContext context, WindowSize windowSize);

/// Function that returns a [PreferredSizeWidget] based on the [BuildContext]
///and [WindowSize].
typedef AdaptivePreferredSizeBuilder =
    PreferredSizeWidget Function(BuildContext context, WindowSize windowSize);
