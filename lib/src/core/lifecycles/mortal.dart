import 'dart:async';

///{@template mortal}
///Dotate `life` to an object for added a life cycle:
///
/// - [onAsk] is called when the object is founded in the `Inyector`.
/// - [onBirth] is called when the object is created.
/// - [onDie] is called when the object is disposed.
/// - [onReproduce] is called when the object is reproduced.
///{@endtemplate}
abstract interface class Mortal {
  ///[onAsk] called when the object is founded in the `Inyector`.
  void onAsk();

  /// [onBirth] is called when the object is created.
  ///
  /// Use to execute some logic when the object is created like initialize some
  /// dependencies or load some data.
  FutureOr<void> onBirth();

  /// [onReproduce] is called when the object is reproduced.
  ///
  ///Reproductions is the process of creating a new object from an existing
  ///object, [Mortal]s should be Immutable so that they can be reproduced to
  ///replace them.
  ///
  ///It's like a copy constructor.
  Mortal onReproduce();

  ///[onDie] is called when the object is disposed.
  ///
  ///Use to execute some logic when the object is disposed like dispose some
  ///dependencies or dispose streams.
  void onDie();
}
