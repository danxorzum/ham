import 'package:meta/meta.dart';

/// {@template tuple}
/// A tuple is a class that represents a pair of values.
/// {@endtemplate}
@immutable
final class Tuple<L, R> {
  /// {@macro tuple}
  const Tuple(this.left, this.right);

  /// The left value.
  final L left;

  /// The right value.
  final R right;

  /// Returns a copy of this tuple with optional new values.
  Tuple<L, R> copyWith({L? left, R? right}) {
    return Tuple(left ?? this.left, right ?? this.right);
  }

  @override
  String toString() => 'Tuple(left: $left, right: $right)';

  @override
  int get hashCode => Object.hash(left, right);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tuple<L, R> &&
          runtimeType == other.runtimeType &&
          left == other.left &&
          right == other.right;
}
