import 'package:flutter/foundation.dart';
import 'package:ham/src/layout/core/entities/layout_controller.dart';

/// {@template controllable_ui}
/// Control the UI behavior of the current layout.
/// {@endtemplate}
abstract class Layoutcontroller extends ChangeNotifier {
  /// Get the current layout state
  LayoutState get layoutState;

  /// Show the top navigation if it layout has one.
  void showTopNavigation();

  /// Hide the top navigation if it layout has one.
  void hideTopNavigation();

  /// Show the bottom navigation if it layout has one.
  void showBottomNavigation();

  /// Hide the bottom navigation if it layout has one.
  void hideBottomNavigation();

  /// Show the primary navigation if it layout has one.
  void showPrimaryNavigation();

  /// Hide the primary navigation if it layout has one.
  void hidePrimaryNavigation();

  /// Show the secondary navigation if it layout has one.
  void showSecondaryNavigation();

  /// Hide the secondary navigation if it layout has one.
  void hideSecondaryNavigation();

  ///Show the secondary body if it layout has one.
  void showSecondaryBody();

  ///Hide the secondary body if it layout has one.
  void hideSecondaryBody();

  ///Show the tertiary body if it layout has one.
  void showTertiaryBody();

  ///Hide the tertiary body if it layout has one.
  void hideTertiaryBody();

  ///Enables layout animations
  void enableAnimation();

  ///Disables layout animations
  void disableAnimation();
}
