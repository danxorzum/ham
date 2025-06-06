part of 'layout_widgets.dart';

///{@template LayoutViewContainer}
///Container for `Material 3` layouts.
///
///Use in screens bigger than compact.
///{@endtemplate}
class LayoutViewContainer extends StatelessWidget {
  ///{@macro LayoutViewContainer}
  const LayoutViewContainer({required this.child, super.key});

  /// Child.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 16, 25, 25),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: child,
    );
  }
}
