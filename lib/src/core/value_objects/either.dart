import 'package:meta/meta.dart';

/// {@template either}
/// A class that represents a value of one of two possible types (a disjoint
/// union).
///
/// An instance of [Either] is either an instance of [Left] or [Right].
/// By convention, [Left] is used for failure and [Right] is used for success.
///
/// This is a sealed class, meaning it can only be extended by [Left] and
/// [Right].
/// {@endtemplate}
@immutable
sealed class Either<L, R> {
  const Either._();

  /// Creates a new [Either] containing a [Left] value.
  ///
  /// Use this when you want to represent a failure case or the first possible
  /// type.
  const factory Either.left(L value) = Left<L, R>;

  /// Creates a new [Either] containing a [Right] value.
  ///
  /// Use this when you want to represent a success case or the second possible
  /// type.
  const factory Either.right(R value) = Right<L, R>;

  /// Returns `true` if this is a [Left] value.
  bool get isLeft => this is Left<L, R>;

  /// Returns `true` if this is a [Right] value.
  bool get isRight => this is Right<L, R>;

  /// Returns the [Left] value.
  ///
  /// Throws a [StateError] if this is a [Right] value.
  /// Use [isLeft] to check if this is a [Left] value before accessing.
  L get left {
    if (this is Left<L, R>) {
      return (this as Left<L, R>).value;
    }
    throw StateError('No left value present');
  }

  /// Returns the [Right] value.
  ///
  /// Throws a [StateError] if this is a [Left] value.
  /// Use [isRight] to check if this is a [Right] value before accessing.
  R get right {
    if (this is Right<L, R>) {
      return (this as Right<L, R>).value;
    }
    throw StateError('No right value present');
  }

  /// Applies [onLeft] if this is a [Left] or [onRight] if this is a [Right].
  ///
  /// This is a way to handle both cases without explicitly checking [isLeft] or
  /// [isRight].
  ///
  /// Example:
  /// ```dart
  /// final result = someEither.fold(
  ///   (left) => 'Left value: $left',
  ///   (right) => 'Right value: $right',
  /// );
  /// ```
  T fold<T>(T Function(L l) onLeft, T Function(R r) onRight) {
    if (this is Left<L, R>) {
      return onLeft((this as Left<L, R>).value);
    } else {
      return onRight((this as Right<L, R>).value);
    }
  }

  @override
  String toString() => fold((l) => 'Left($l)', (r) => 'Right($r)');
}

/// The left side of the disjoint union, as opposed to the [Right] side.
///
/// By convention, [Left] is used to hold an error value.
final class Left<L, R> extends Either<L, R> {
  /// Creates a new [Left] with the given [value].
  const Left(this.value) : super._();

  /// The value this [Left] wraps.
  final L value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Left<L, R> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// The right side of the disjoint union, as opposed to the [Left] side.
///
/// By convention, [Right] is used to hold a successful value.
final class Right<L, R> extends Either<L, R> {
  /// Creates a new [Right] with the given [value].
  const Right(this.value) : super._();

  /// The value this [Right] wraps.
  final R value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Right<L, R> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
