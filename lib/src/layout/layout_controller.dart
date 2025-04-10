import 'package:ham/src/layout/core/entities/layout_controller.dart';
import 'package:ham/src/layout/interfaces/controllable_ui.dart';

/// {@template layout_controller}
/// A controller for the layout.
///
/// Is used to control how the layout is rendered.
/// {@endtemplate}
final class LayoutController extends Layoutcontroller {
  /// {@macro layout_controller}
  LayoutController({required this.layoutState});

  @override
  LayoutState layoutState;
  @override
  void disableAnimation() {
    layoutState = layoutState.copyWith(canAnimate: false);
    notifyListeners();
  }

  @override
  void enableAnimation() {
    layoutState = layoutState.copyWith(canAnimate: true);
    notifyListeners();
  }

  @override
  void hideBottomNavigation() {
    layoutState = layoutState.copyWith(showBottomNavigation: false);
    notifyListeners();
  }

  @override
  void hidePrimaryNavigation() {
    layoutState = layoutState.copyWith(showPrimaryNavigation: false);
    notifyListeners();
  }

  @override
  void hideSecondaryBody() {
    layoutState = layoutState.copyWith(showSecondaryBody: false);
    notifyListeners();
  }

  @override
  void hideSecondaryNavigation() {
    layoutState = layoutState.copyWith(showSecondaryNavigation: false);
    notifyListeners();
  }

  @override
  void hideTertiaryBody() {
    layoutState = layoutState.copyWith(showTertiaryBody: false);
    notifyListeners();
  }

  @override
  void hideTopNavigation() {
    layoutState = layoutState.copyWith(showTopNavigation: false);
    notifyListeners();
  }

  @override
  void showBottomNavigation() {
    layoutState = layoutState.copyWith(showBottomNavigation: true);
    notifyListeners();
  }

  @override
  void showPrimaryNavigation() {
    layoutState = layoutState.copyWith(showPrimaryNavigation: true);
    notifyListeners();
  }

  @override
  void showSecondaryBody() {
    layoutState = layoutState.copyWith(showSecondaryBody: true);
    notifyListeners();
  }

  @override
  void showSecondaryNavigation() {
    layoutState = layoutState.copyWith(showSecondaryNavigation: true);
    notifyListeners();
  }

  @override
  void showTertiaryBody() {
    layoutState = layoutState.copyWith(showTertiaryBody: true);
    notifyListeners();
  }

  @override
  void showTopNavigation() {
    layoutState = layoutState.copyWith(showTopNavigation: true);
    notifyListeners();
  }
}
