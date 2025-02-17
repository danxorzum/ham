import 'package:flutter/material.dart';

///{@template layout_controller}
///[LayoutController] is a class that controls the layout of the app.
///
///It's ise to control some behaviors of the layouts like animations.
///witout lose states or change on demand.
///
///Isn't a singleton class because you can create more than one instance of it
///and control different layouts independently. But should be used at top level.
///or you can lose the state of the layout.
///
///`Important`: [secondaryBodyRatio] + [bodyRatio] must be equal to 1.
///{@endtemplate}
class LayoutController extends ChangeNotifier {
  ///{@macro layout_controller}
  LayoutController({
    bool canAnimate = true,
    bool showTopNavigation = true,
    bool showBottomNavigation = true,
    bool showPrimaryNavigation = true,
    bool showSecondaryNavigation = true,
    double bodyRatio = 0.5,
    double? secondaryBodyRatio,
  })  : _canAnimate = canAnimate,
        _showTopNavigation = showTopNavigation,
        _showBottomNavigation = showBottomNavigation,
        _showPrimaryNavigation = showPrimaryNavigation,
        _showSecondaryNavigation = showSecondaryNavigation,
        _secondaryBodyRatio = secondaryBodyRatio,
        _bodyRatio = bodyRatio,
        assert(
          bodyRatio + (secondaryBodyRatio ?? 0) <= 1,
          'bodyRatio + secondaryBodyRatio must be less than 1.',
        );

  bool _canAnimate;

  bool _showTopNavigation;

  bool _showBottomNavigation;

  bool _showPrimaryNavigation;

  bool _showSecondaryNavigation;

  double _bodyRatio;

  final double? _secondaryBodyRatio;

  ///Update the state of the layout.
  void update({
    bool? canAnimate,
    bool? showTopNavigation,
    bool? showBottomNavigation,
    bool? showPrimaryNavigation,
    bool? showSecondaryNavigation,
    double? bodyRatio,
    double? secondaryBodyRatio,
  }) {
    assert(
      canAnimate != null ||
          showTopNavigation != null ||
          showBottomNavigation != null ||
          showPrimaryNavigation != null ||
          showSecondaryNavigation != null ||
          bodyRatio != null ||
          secondaryBodyRatio != null,
      'At least one of the parameters must be not null.',
    );
    assert(
      _bodyRatio + (_secondaryBodyRatio ?? 0) <= 1,
      'bodyRatio + secondaryBodyRatio must be less than 1.',
    );

    _canAnimate = canAnimate ?? _canAnimate;
    _showTopNavigation = showTopNavigation ?? _showTopNavigation;
    _showBottomNavigation = showBottomNavigation ?? _showBottomNavigation;
    _showPrimaryNavigation = showPrimaryNavigation ?? _showPrimaryNavigation;
    _showSecondaryNavigation =
        showSecondaryNavigation ?? _showSecondaryNavigation;
    _bodyRatio = bodyRatio ?? _bodyRatio;

    notifyListeners();
  }

  /// canAnimate indicates if the layout can animate.
  bool get canAnimate => _canAnimate;

  /// showTopNavigation indicates if the top navigation should be shown.
  bool get showTopNavigation => _showTopNavigation;

  /// showBottomNavigation indicates if the bottom navigation should be shown.
  bool get showBottomNavigation => _showBottomNavigation;

  /// showPrimaryNavigation indicates if the primary navigation should be shown.
  bool get showPrimaryNavigation => _showPrimaryNavigation;

  /// showSecondaryNavigation indicates if the secondary navigation should be
  /// shown.
  bool get showSecondaryNavigation => _showSecondaryNavigation;

  /// bodyRatio indicates the ratio of the body.
  double get bodyRatio => _bodyRatio;

  /// secondaryBodyRatio indicates the ratio of the secondary body.
  /// If it's null, it will be the half of the remaining space.
  double? get secondaryBodyRatio => _secondaryBodyRatio;
}
