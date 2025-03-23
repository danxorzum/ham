import 'package:ham/src/core/value_objects/outcome.dart';
import 'package:meta/meta.dart';

/// {@template tuple}
/// A tuple is a class that represents a pair of values.
/// {@endtemplate}
@immutable
final class Tuple<L, R> extends Outcome<L, R> {
  /// {@macro tuple}
  Tuple(this.left, this.right);

  @override
  final L left;

  @override
  final R right;

  @override
  String toString() => 'Tuple(left: $left, right: $right)';

  @override
  int get hashCode => left.hashCode ^ right.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tuple<L, R> &&
          runtimeType == other.runtimeType &&
          left == other.left &&
          right == other.right;
}
