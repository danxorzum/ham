///{@template either}
/// Either is a class that represents a value that can be either of two types:
/// a `left` value or a `right` value.
/// {@endtemplate}
abstract base class Either<L, R> {
  /// Get the error
  L? get left;

  /// Get the value
  R? get right;

  /// Has error
  bool get hasLeft => left != null;

  /// Has value
  bool get hasRight => right != null;
}
