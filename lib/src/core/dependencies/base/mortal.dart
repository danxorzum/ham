///{@template mortal}
///Dotate `life` to an object for added a life cycle:
///
/// - [onBirth] is called when the object is created.
/// - [onDie] is called when the object is disposed.
/// -[onReproduce] is called when the object is reproduced.
///{@endtemplate}
abstract interface class Mortal {
  ///[onBirth] is called when the object is created.
  void onBirth();

  ///[onReproduce] is called when the object is reproduced.
  ///
  ///Reproductions is the process of creating a new object from an existing
  ///object, [Mortal]s should be Immutable so that they can be reproduced to
  ///replace them.
  ///
  ///Not necessary has to be implemented. but life cycle calls it.
  Mortal onReproduce();

  ///Methot to ask. Ask is uses to execute some logic in some cases.
  ///
  ///When some one get an instance of [Mortal] onAsk is called.
  void onAsk();

  ///[onDie] is called when the object is disposed.
  void onDie();
}
