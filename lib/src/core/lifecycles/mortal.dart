import 'dart:async';

///{@template mortal}
/// Adds a lifecycle to an object managed by the `Inyector` dependency injection
/// system.
///
/// The `Mortal` interface defines hooks that allow you to respond to key
/// lifecycle events:
///
/// - [onAsk]: Called when the object is retrieved from `Inyector`.
/// - [onBirth]: Called only once when the object is first created by
/// `Inyector`.
/// - [onChildBirth]: Called when a new descendant (child) is created from this
/// object.
/// - [onReproduce]: Returns a new instance (clone/copy) of the object,
/// typically inheriting state or dependencies.
/// - [onDie]: Called when the object is disposed by `Inyector`.
/// - [onDieWithoutChildren]: Called when the object is disposed without having
/// created descendants.
///
/// ## Lifecycle Flow
///
/// 1. `onBirth` is called when the object is first instantiated by `Inyector`.
/// 2. Each time the object is retrieved from `Inyector`, `onAsk` is called.
/// 3. If a new instance (descendant) is created via `onReproduce`, the parent's
/// `onReproduce` is called, then the child’s `onChildBirth` is called.
/// After `onReproduce`, `onDie` is called.
/// 4. When the object is disposed from `Inyector`, and `rebirth` option is
/// false, `onDieWithoutChildren` is called.
///
/// ## Immutability
///
/// Objects implementing `Mortal` should be immutable so they can be safely
/// reproduced and replaced.
///
/// ## Example
///
/// ```dart
/// class MyService implements Mortal {
///   @override
///   void onAsk() => print('Service asked');
///
///   @override
///   FutureOr<void> onBirth() async => print('Service born');
///
///   @override
///   void onChildBirth() => print('Child born');
///
///   @override
///   MyService onReproduce() => MyService();
///
///   @override
///   void onDie() => print('Service disposed');
///
///   @override
///   void onDieWithoutChildren() => print('Service disposed without children');
/// }
/// ```
///
/// The `Inyector` will automatically call these methods at the appropriate
/// times in the object's lifecycle.
///{@endtemplate}
abstract interface class Mortal {
  /// Called when the object is retrieved from the `Inyector`.
  ///
  /// Use this to perform any logic needed each time the object is requested.
  void onAsk();

  /// Called once when the object is first created by `Inyector`.
  ///
  /// Use this to initialize dependencies, load data, or perform setup logic.
  /// This is only called a single time for the object's lifetime, regardless of
  /// descendants.
  FutureOr<void> onBirth();

  /// Called when a new descendant is created  from [onReproduce].
  ///
  /// This is triggered every time a child is created after the parent’s
  /// [onReproduce].
  /// Use this to rebuild or reset dependencies specific to the child.
  ///
  /// Example: On logout, clear user-specific data in the child, while
  /// preserving shared dependencies from the parent.
  void onChildBirth();

  /// Returns a new instance (descendant) of the object, typically inheriting
  /// state or dependencies.
  ///
  /// This acts like a copy constructor. Use it to determine which dependencies
  /// or state to pass to the child.
  ///
  /// [onReproduce] is called before the parent’s [onDie], then the parent is
  /// disposed. Called when a `Inyector.remove` is called. If `rebirth` option
  /// is true, [onReproduce] is called before call [onDie].
  ///
  /// If `rebirth` option is false,[onReproduce] is not called and
  /// [onDieWithoutChildren] instead of [onDie] is called.
  ///
  /// Example: On logout, clear user-specific data in the child, while
  /// preserving shared dependencies from the parent.
  Mortal onReproduce();

  /// Called when the object is disposed by `Inyector`.
  ///
  /// Use this to clean up resources, close streams, or dispose dependencies.
  /// [onDie] is called for each descendant after [onReproduce] is called.
  void onDie();

  ///[onDieWithoutChildren] is called when the object without call
  ///[onReproduce].
  ///
  ///It's called only once when the object is disposed without descendants.
  ///
  ///You can close all resources or dependencies.
  void onDieWithoutChildren();
}
