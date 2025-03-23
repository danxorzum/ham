///{@template outcome}
/// Outcome is a class that represents a value that can be either of two types:
/// a `left` value or a `right` value.
/// {@endtemplate}
abstract base class Outcome<L, R> {
  /// Get the error
  L? get left;

  /// Get the value
  R? get right;

  /// Has left value
  bool get hasLeft => left != null;

  /// Has right value
  bool get hasRight => right != null;
}
