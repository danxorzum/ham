import 'package:ham/src/core/value_objects/either.dart';

/// Convenience type alias for result-based outcomes.
///
/// [T] is the success type (Right), [E] is the failure type (Left).
typedef Result<T, E> = Either<E, T>;

/// Returns a successful [Result] containing [value].
Result<T, E> success<T, E>(T value) => Right<E, T>(value);

/// Returns a failed [Result] containing [error].
Result<T, E> failure<T, E>(E error) => Left<E, T>(error);
