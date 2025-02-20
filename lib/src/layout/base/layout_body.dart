import 'package:flutter/widgets.dart';

/// {@template LayoutConfiguration}
/// Class to configure the layout of the app.
/// {@endtemplate}
final class LayoutBody extends StatelessWidget {
  /// {@macro LayoutConfiguration}
  const LayoutBody({
    required this.body,
    super.key,
    this.bodyMedium,
    this.bodyExpanded,
    this.bodyLarge,
    this.bodyExtraLarger,
    this.secondaryBody,
    this.secondaryExpandedBody,
    this.secondaryLargeBody,
    this.secondaryExtraLargerBody,
    this.tertiaryBody,
  });

  ///Body
  final Widget body;

  ///Body Medium
  final Widget? bodyMedium;

  ///Body Expanded
  final Widget? bodyExpanded;

  ///Body Large
  final Widget? bodyLarge;

  ///Body Extra Large
  final Widget? bodyExtraLarger;

  ///Secondary Body
  final Widget? secondaryBody;

  ///Secondary Expanded Body
  final Widget? secondaryExpandedBody;

  ///Secondary Large Body
  final Widget? secondaryLargeBody;

  ///Secondary Extra Large Body
  final Widget? secondaryExtraLargerBody;

  ///Tertiary Body
  final Widget? tertiaryBody;

  @override
  Widget build(BuildContext context) {
    return body;
  }
}
