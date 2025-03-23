import 'package:ham/src/core/value_objects/outcome.dart';
import 'package:meta/meta.dart';

///{@template error_or}
/// ErrorOr is a class that can be used to represent a value that can be either
/// an error or a value.
///
/// You can't have both an error and a value. If you need to represent both,
/// use `EitherValue` instead.
/// {@endtemplate}
@immutable
final class ErrorOr<E extends Exception, T> extends Outcome<E, T> {
  ///{@macro error_or}
  ErrorOr({required this.error, required this.value})
    : assert(
        (error != null && value == null) || (error == null && value != null),
        'ErrorOr must have an error or a value, but not both',
      );

  /// The error value.
  final E? error;

  /// The value.
  final T? value;

  @override
  E get left => error!;

  @override
  T get right => value!;

  /// Returns true if the ErrorOr has an error, false otherwise.
  bool get hasError => hasLeft;

  /// Returns true if the ErrorOr has a value, false otherwise.
  bool get hasValue => hasRight;

  @override
  String toString() => 'ErrorOr(error: $error, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ErrorOr<E, T> &&
        other.error == error &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(error, value);
}
