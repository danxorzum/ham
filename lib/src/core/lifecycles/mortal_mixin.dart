import 'dart:async';

import 'package:ham/src/core/lifecycles/mortal.dart';

/// {@template mortal_mixin}
/// A mixin that provides default empty implementations of the [Mortal]
/// interface.
///
/// This mixin simplifies the creation of classes that need to implement the
/// [Mortal] lifecycle interface by providing no-op implementations for all
/// required methods.
///
/// ## Usage
///
/// ```dart
/// class MyService with MortalMixin {
///   // Only override the lifecycle methods you need
///   @override
///   void onBirth() {
///     // Custom initialization logic
///     print('MyService initialized');
///   }
///
///   @override
///   void onDie() {
///     // Custom cleanup logic
///     print('MyService disposed');
///   }
/// }
/// ```
///
/// By using this mixin, you don't need to implement all the lifecycle methods
/// defined in the [Mortal] interface - only override the ones you need for
/// your specific use case.
///
/// See [Mortal] for full documentation of the lifecycle methods and when they
/// are called.
/// {@endtemplate}
mixin MortalMixin implements Mortal {
  /// Default implementation of [Mortal.onAsk].
  ///
  /// This method is called each time the object is retrieved from the Inyector.
  /// Override this method if you need to perform actions when your object is
  /// accessed.
  @override
  void onAsk() {}

  /// Default implementation of [Mortal.onBirth].
  ///
  /// This method is called once when the object is first created by Inyector.
  /// Override this method to initialize resources or perform setup logic.
  @override
  FutureOr<void> onBirth() => null;

  /// Default implementation of [Mortal.onChildBirth].
  ///
  /// This method is called on a new instance after it was created via
  /// [onReproduce].
  /// Override this method to perform initialization specific to the child
  /// instance.
  @override
  void onChildBirth() {}

  /// Default implementation of [Mortal.onDie].
  ///
  /// This method is called when the object is disposed by the Inyector.
  /// Override this method to clean up resources or perform teardown logic.
  @override
  void onDie() {}

  /// Default implementation of [Mortal.onDieWithoutChildren].
  ///
  /// This method is called when the object is disposed without having created
  /// descendants.
  /// Override this to handle cleanup when no reproduction has occurred.
  @override
  void onDieWithoutChildren() {}
}
