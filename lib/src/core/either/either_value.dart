//the class  are immutable because all values are final
// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:ham_framework/src/core/either/either_base.dart';

/// {@template either}
/// Either is a class that represents a value that can be either of two types:
/// a `left` value or a `right` value.
///
/// It is not restricted to having only one value at a time, unlike `ErrorOr`.
/// {@endtemplate}
final class EitherValue<L, R> extends Either<L, R> {
  /// {@macro either}
  EitherValue({this.left, this.right});

  @override
  final L? left;

  @override
  final R? right;

  /// Returns the left value or throws an exception if not present.
  L getOrElseLeft() {
    if (hasLeft) {
      return left!;
    } else {
      throw StateError('No left value available');
    }
  }

  /// Returns the right value or throws an exception if not present.
  R getOrElseRight() {
    if (hasRight) {
      return right!;
    } else {
      throw StateError('No right value available');
    }
  }

  @override
  String toString() => 'Either(left: $left, right: $right)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Either<L, R> && other.left == left && other.right == right;
  }

  @override
  int get hashCode => Object.hash(left, right);
}
