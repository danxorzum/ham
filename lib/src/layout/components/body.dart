import 'package:ham/src/layout/core/core.dart';
import 'package:ham/src/layout/layout_controller.dart';

/// {@template body}
/// Body of the layout.
///
/// Is used to define the main content of the layout in adaptive layouts.
/// Remember mobile first approach.
///
/// [bodyBuilder] is used to define the main content of the layout. if
/// [secondaryBodyBuilder] or [tertiaryBodyBuilder] is not provided,
/// [bodyBuilder] will be used for all screen sizes.
///
/// In mobile devices, each body will used in individual stack.
/// example:
///
/// ```dart
///
///  final class ProductsBody extends Body {
///    @override
///    AdaptiveBuilder get bodyBuilder =>
///    (BuildContext context, WindowSize size) {
///      return const ProductsListView();
///    }
///
///    @override
///    AdaptiveBuilder? get secondaryBodyBuilder =>
///    (BuildContext context, WindowSize size) {
///      return const ProductDetailsView();
///    }
///
///    @override
///    AdaptiveBuilder? get tertiaryBodyBuilder =>
///    (BuildContext context, WindowSize size) {
///      return const ProductExtraInfoView();
///    }
///
///    @override
///    AdaptiveBuilder? get topWidget =>
///    (BuildContext context, WindowSize size) {
///      return const LinearProgressIndicator();
///    }
///
///    @override
///    AdaptiveBuilder? get bottomWidget =>
///    (BuildContext context, WindowSize size) {
///      return const Footer();
///    }
///  }
/// ```
/// Each body will be used in individual stack. like:
///     - app/products
///     - app/products/1
///     - app/products/1/info
/// In larger screens, the page will be splitted in two, if th screen is biggest
/// then could split in three.
/// Also, you can show or hide the secondary or tertiary body by using
/// [LayoutController].
/// {@endtemplate}
abstract class Body {
  /// Defines the main content of the layout.
  ///
  ///
  AdaptiveBuilder get bodyBuilder;

  /// Defines the secondary content of the layout.
  ///
  /// [secondaryBodyBuilder] is used to define the secondary content of the
  /// layout. If it's not provided, the main content will be used for all
  /// screen sizes.
  AdaptiveBuilder? get secondaryBodyBuilder => null;

  /// Defines the tertiary content of the layout.
  ///
  /// [tertiaryBodyBuilder] is used to define the tertiary content of the
  /// layout. If it's not provided, the main content will be used for all
  /// screen sizes.
  AdaptiveBuilder? get tertiaryBodyBuilder => null;

  /// [topWidget] use all width available. before bodies.
  ///
  /// Use like a banner or header or progress bar.
  AdaptiveBuilder? get topWidget => null;

  /// [bottomWidget] use all width available. after bodies.
  ///
  /// Use like a footer or progress bar.
  AdaptiveBuilder? get bottomWidget => null;
}
