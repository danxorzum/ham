import 'package:flutter/animation.dart';
import 'package:ham/src/core/core.dart';
import 'package:meta/meta.dart';

/// {@template layout_state}
/// Represents the state of the layout.
///
/// Is used to control how the layout is rendered.
/// {@endtemplate}
@immutable
final class LayoutState {
  /// {@macro layout_state}
  const LayoutState({
    this.canAnimate = true,
    this.showTopNavigation = true,
    this.showBottomNavigation = true,
    this.showPrimaryNavigation = true,
    this.showSecondaryNavigation = true,
    this.showSecondaryBody = true,
    this.showTertiaryBody = true,
    this.bodyRatio = 0.5,
    this.secondaryBodyRatio = 0,
    this.duration = Durations.halfSecond,
    this.curve = Curves.fastOutSlowIn,
  });

  /// Enable animations
  final bool canAnimate;

  /// Show top navigation
  final bool showTopNavigation;

  /// Show bottom navigation
  final bool showBottomNavigation;

  /// Show primary navigation
  final bool showPrimaryNavigation;

  /// Show secondary navigation
  final bool showSecondaryNavigation;

  /// Show secondary body
  final bool showSecondaryBody;

  /// Show tertiary body
  final bool showTertiaryBody;

  /// Body ratio between first and second body
  final double bodyRatio;

  /// Secondary body ratio
  final double secondaryBodyRatio;

  /// Animation curve
  final Curve curve;

  /// Animation duration
  final Duration duration;

  /// Copy with new values
  LayoutState copyWith({
    bool? canAnimate,
    bool? showTopNavigation,
    bool? showBottomNavigation,
    bool? showPrimaryNavigation,
    bool? showSecondaryNavigation,
    bool? showSecondaryBody,
    bool? showTertiaryBody,
    double? bodyRatio,
    double? secondaryBodyRatio,
  }) {
    return LayoutState(
      canAnimate: canAnimate ?? this.canAnimate,
      showTopNavigation: showTopNavigation ?? this.showTopNavigation,
      showBottomNavigation: showBottomNavigation ?? this.showBottomNavigation,
      showPrimaryNavigation:
          showPrimaryNavigation ?? this.showPrimaryNavigation,
      showSecondaryNavigation:
          showSecondaryNavigation ?? this.showSecondaryNavigation,
      showSecondaryBody: showSecondaryBody ?? this.showSecondaryBody,
      showTertiaryBody: showTertiaryBody ?? this.showTertiaryBody,
      bodyRatio: bodyRatio ?? this.bodyRatio, // 0.5
      secondaryBodyRatio: secondaryBodyRatio ?? this.secondaryBodyRatio, // 0.5
    );
  }

  @override
  int get hashCode {
    return canAnimate.hashCode ^
        showTopNavigation.hashCode ^
        showBottomNavigation.hashCode ^
        showPrimaryNavigation.hashCode ^
        showSecondaryNavigation.hashCode ^
        showSecondaryBody.hashCode ^
        showTertiaryBody.hashCode ^
        bodyRatio.hashCode ^
        secondaryBodyRatio.hashCode;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayoutState &&
          runtimeType == other.runtimeType &&
          canAnimate == other.canAnimate &&
          showTopNavigation == other.showTopNavigation &&
          showBottomNavigation == other.showBottomNavigation &&
          showPrimaryNavigation == other.showPrimaryNavigation &&
          showSecondaryNavigation == other.showSecondaryNavigation &&
          showSecondaryBody == other.showSecondaryBody &&
          showTertiaryBody == other.showTertiaryBody &&
          bodyRatio == other.bodyRatio &&
          secondaryBodyRatio == other.secondaryBodyRatio;
}
