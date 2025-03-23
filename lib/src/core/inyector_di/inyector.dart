// Unsused_element is ignored because the class is abstract
// With abstract methods so only can be implemented here
// ignore_for_file: unused_element
import 'dart:developer';

import 'package:ham/src/core/inyector_di/inyector_manager.dart';
import 'package:ham/src/core/lifecycles/lifecycles.dart';
import 'package:ham/src/core/utils/utils.dart';

/// {@template inyector}
/// `Inyector` is a DI container whit life..
///
/// `Inyector` can handle regular and `Mortal` dependencies.
///
/// `Mortal` dependencies are objects that implement the [Mortal] life cycle:
///  - [Mortal.onBirth] is called when the object is created.
///  - [Mortal.onAsk] is called when the object is founded in the inyector.
///  - [Mortal.onReproduce] is called when the object copies itself.
///  It called before the [Mortal.onDie] method.
///  - [Mortal.onDie] is called when the object is disposed and removed from the
///  [Inyector].
///
/// If dependencies are't mortal, they won't be affected by the [Inyector] life
/// cycle.
/// {@endtemplate}
sealed class Inyector {
  static final _Inyector _instance = _Inyector._();

  /// Get the instance of the [Inyector]
  static Inyector get instance => _instance;

  /// Get the instance of the [Inyector] short way
  static Inyector get I => _instance;

  /// Register a dependency in the DI container.
  ///
  /// [lazy] is a flag that indicates if the value   should be created
  /// lazily.
  ///
  ///{@template add}
  /// [spawn] returns the instance of the dependency.
  ///
  /// [tag] is a unique key for store data in case that you need  to have
  /// multiple instances of the same type.
  ///
  /// [rebirth] is a flag that indicates:
  ///  - If dependency is mortal, enables the dependency to call
  /// [Mortal.onReproduce] before delete it. If is true, mortal objects will
  /// reuse the [Mortal.onReproduce] method.
  ///
  ///  - If dependency is't mortal and [rebirth] is true, use the [spawn] to
  /// create a new instance of the dependency. Non mortal dependencies saves
  /// their [spawn] function. If is false, [spawn] function is't saved.
  /// {@endtemplate}
  static void add<T>(
    T Function() spawn, {
    String? tag,
    bool lazy = false,
    bool rebirth = true,
  }) => _instance._add(spawn, tag: tag, lazy: lazy, rebirth: rebirth);

  /// Future version of [add].
  ///
  /// {@macro add}
  static Future<void> addAsync<T>(
    Future<T> Function() spawn, {
    String? tag,
    bool rebirth = false,
  }) => _instance._addAsync(spawn, tag: tag, rebirth: rebirth);

  /// Remove dependency from the `inyector`.
  ///
  /// In `Mortal` dependencies, [Mortal.onDie] method is called before removing.
  ///
  /// If dependency was registered as `rebirth`able it regenarete non mortals
  /// dependencies. In `Mortal` dependencies, [Mortal.onReproduce] method is
  /// called before removing.
  ///
  /// Throws HamException if dependency is not found.
  static void remove<T>({String? tag}) => _instance._remove<T>(tag: tag);

  /// Get dependency from the `inyector`.
  ///
  /// If dependency is mortal, [Mortal.onAsk] method is called.
  ///
  /// Throws HamException if dependency is not found.
  static T get<T>({String? key}) => _instance._get<T>(key: key);

  /// Clean all dependencies. In non motals if `rebirth` option is true, it calls
  /// `spawn` method.
  ///
  /// In `Mortal` dependencies, if `rebirth` is true, [Mortal.onReproduce]
  /// method is called.
  /// [Mortal.onDie] method is called in each mortal dependency.
  static void clean() => _instance._clean();

  /// Reset the `inyector`. delete all dependencies and they can't `rebirth`,
  /// even if `rebirth` option is true.
  ///
  /// It calls [Mortal.onDie] method for all objects [Mortal]s.
  static void reset() => _instance._reset();

  void _add<T>(
    T Function() spawn, {
    String? tag,
    bool lazy = false,
    bool rebirth = true,
  });

  Future<void> _addAsync<T>(
    Future<T> Function() spawn, {
    String? tag,
    bool rebirth = false,
  });

  void _remove<T>({String? tag});

  T _get<T>({String? key});

  void _clean();

  void _reset();
}

final class _Inyector implements Inyector {
  _Inyector._();

  final _dependencies = InyectorManager();
  final _lazyDependencies = InyectorManager();

  _InyectorItem<T> _wakeLazy<T>(String nameTag) {
    late final _InyectoLazyItem<T> lazyItem;
    if (!_lazyDependencies.get<_InyectoLazyItem<T>>(key: nameTag).canRebirth) {
      lazyItem = _lazyDependencies.remove<_InyectoLazyItem<T>>(key: nameTag);
    } else {
      lazyItem = _lazyDependencies.get<_InyectoLazyItem<T>>(key: nameTag);
    }
    final result = _InyectorItem<T>(
      instance: lazyItem.spawner(),
      canRebirth: lazyItem.canRebirth,
    );
    _dependencies.add<_InyectorItem<T>>(dependency: result, key: nameTag);
    log('\x1B[Lazy Dependency woken: $nameTag\x1B[0m', name: 'Inyector');
    return result;
  }

  void _toLazy<T>({
    required T Function() spawn,
    required String nameTag,
    required bool canRebirth,
  }) {
    _lazyDependencies.add<_InyectoLazyItem<T>>(
      dependency: _InyectoLazyItem<T>(spawner: spawn, canRebirth: canRebirth),
      key: nameTag,
    );
  }

  @override
  void _add<T>(
    T Function() spawn, {
    String? tag,
    bool lazy = false,
    bool rebirth = false,
  }) {
    final nameTag = nameTagFromType(T, tag ?? '');

    if (lazy) {
      _toLazy<T>(spawn: spawn, nameTag: nameTag, canRebirth: rebirth);
      log('\x1B[35mLazy dependency added: $nameTag\x1B[0m', name: 'Inyector');
      return;
    }

    final item = spawn.call();
    _dependencies.add<_InyectorItem<T>>(
      dependency: _InyectorItem<T>(instance: item, canRebirth: rebirth),
      key: nameTag,
    );
    if (item is Mortal) {
      log('\x1B[35mMortal Dependency added: $nameTag\x1B[0m', name: 'Inyector');
      (item as Mortal).onBirth();
      log('\x1B[35m$nameTag onBirth\x1B[0m', name: 'Inyector');
    } else {
      log('\x1B[35mDependency added: $nameTag\x1B[0m', name: 'Inyector');
    }
  }

  @override
  Future<void> _addAsync<T>(
    Future<T> Function() futureConstructor, {
    String? tag,
    bool rebirth = true,
  }) async {
    final nameTag = nameTagFromType(T, tag ?? '');
    final instance = await futureConstructor();
    _dependencies.add<_InyectorItem<T>>(
      dependency: _InyectorItem<T>(instance: instance, canRebirth: rebirth),
      key: nameTag,
    );
    if (instance is Mortal) {
      log(
        '\x1B[35mAsync Mortal Dependency added: $nameTag\x1B[0m',
        name: 'Inyector',
      );
      (instance as Mortal).onBirth();
      log('\x1B[35m$nameTag onBirth\x1B[0m', name: 'Inyector');
    } else {
      log('\x1B[35mAsyncDependency added: $nameTag\x1B[0m', name: 'Inyector');
    }
  }

  @override
  T _get<T>({String? key}) {
    final nameTag = nameTagFromType(T, key ?? '');
    late final T item;
    if (!_dependencies.exists(nameTag)) {
      item = _wakeLazy<T>(nameTag).instance;
    } else {
      item = _dependencies.get<_InyectorItem<T>>(key: nameTag).instance;
    }
    if (item is Mortal) {
      (item as Mortal).onAsk();
      log('\x1B[35m$nameTag onAsk\x1B[0m', name: 'Inyector');
    }
    return item;
  }

  @override
  void _remove<T>({String? tag}) {
    final nameTag = nameTagFromType(T, tag ?? '');
    final item = _dependencies.remove<_InyectorItem<T>>(key: nameTag);
    if (item.instance is Mortal) {
      if (item.canRebirth) {
        final child = (item.instance as Mortal).onReproduce();
        log('\x1B[35m$nameTag onReproduce\x1B[0m', name: 'Inyector');
        _dependencies.add<_InyectorItem<T>>(
          dependency: _InyectorItem<T>(
            instance: child as T,
            canRebirth: item.canRebirth,
          ),
          key: nameTag,
        );
      }
      (item.instance as Mortal).onDie();
      log('\x1B[35m$nameTag onDie\x1B[0m', name: 'Inyector');
    }
    log('\x1B[35mDependency removed: $nameTag\x1B[0m', name: 'Inyector');
  }

  void _cleanDependencies() {
    _dependencies.getDependencies().forEach((key, value) {
      if ((value as _InyectorItem<dynamic>).instance is Mortal) {
        (value.instance as Mortal).onDie();
        log('\x1B[35mAll Mortal dependencies onDie\x1B[0m', name: 'Inyector');
      }
    });
    _dependencies.clear();
  }

  @override
  void _clean() {
    final values = _dependencies.getDependencies();
    final rebirths = <String, _InyectorItem<Mortal>>{};
    values.forEach((key, value) {
      if ((value as _InyectorItem).instance is Mortal) {
        if (value.canRebirth) {
          rebirths[key] = _InyectorItem(
            instance: (value.instance as Mortal).onReproduce(),
            canRebirth: value.canRebirth,
          );
          log('\x1B[35m$key onReproduce\x1B[0m', name: 'Inyector');
        }
        (value.instance as Mortal).onDie();
        log('\x1B[35m$key onDie\x1B[0m', name: 'Inyector');
      }
    });
    _dependencies.clear();
    rebirths.forEach((key, value) {
      _dependencies.add<_InyectorItem<Mortal>>(dependency: value, key: key);
    });
    log('\x1B[35mAll dependencies are cleaned\x1B[0m', name: 'Inyector');
  }

  @override
  void _reset() {
    _lazyDependencies.clear();
    _cleanDependencies();
  }
}

final class _InyectorItem<T> {
  _InyectorItem({required this.instance, required this.canRebirth});
  final T instance;
  final bool canRebirth;
}

final class _InyectoLazyItem<T> {
  _InyectoLazyItem({required this.spawner, required this.canRebirth});

  final T Function() spawner;
  final bool canRebirth;
}
// import 'dart:developer';

// import 'package:ham/src/core/domain/inyector/inyector_manager.dart';
// import 'package:ham/src/core/domain/lifecycles/lifecycles.dart';

// /// {@template inyector}
// /// The inyector is a singleton class that is used to inject dependencies into
// /// the application.
// ///
// /// [Inyector] can handle regular and [Mortal] dependencies.
// ///
// /// [Mortal] dependencies are objects that have a life cycle. Inyecor uses.
// ///
// /// [Mortal] dependencies use to be like repositores, services etc.
// /// {@endtemplate}
// sealed class Inyector {
//   // singleton
//   static final _Inyector _instance = _Inyector._();

//   /// Get the instance of the [Inyector]
//   static Inyector get instance => _instance;

//   /// Short way to get the instance of the [Inyector]
//   static Inyector get I => _instance;

//   //Regular Injection Methods
//   ///Register a regular object
//   void register<T>(T instance, {String? tag});

//   ///Unregister a regular object
//   void unregister<T>({String? tag});

//   ///Register a regular object in a lazy way.
//   void lazyRegister<T>(T Function() factoryFunction, {String? tag});

//   ///Get a regular object
//   T getIt<T>({String? tag});

//   //Mortal Injection Methods
//   ///Register a mortal object and use theyr life cycle.
//   ///
//   ///{@template add}
//   ///[spawn] is a function that returns a mortal object.
//   ///[tag] is a unique key for the mortal object in case you want to have
//   /// multiple instances of the same mortal.
//   /// [lazy] is a flag that indicates if the mortal object should be created
//   /// lazily.
//   /// [rebirth] is a flag that indicates if the mortal object can be reproduced
//   /// when it dies. Reproduction is a feature that allows to reuse dependencies
//   /// witout creating new ones. Per example when app logs out, we want to reuse
//   /// the same dependencies without old data, But we don't want to create new
//   /// ones.
//   /// {@endtemplate}
//   void add<T extends Mortal>(
//     T Function() spawn, {
//     String? tag,
//     bool lazy = false,
//     bool rebirth = true,
//   });

//   ///Register a mortal async object
//   ///{@macro add}
//   Future<void> addAsync<T extends Mortal>(
//     Future<T> Function() spawn, {
//     String? tag,
//     bool rebirth = true,
//   });

//   ///Remove a mortal object
//   ///
//   ///`WARNING: You should never call any mortal object after removing it.`
//   ///Before removing a mortal object, [remove] calls [Mortal.onDie] method.
//   void remove<T extends Mortal>({String? tag});

//   ///Get a mortal object
//   T get<T extends Mortal>({String? key});

//   ///Clean all regular objects
//   void clearRegular();

//   ///Clean all lazy objects
//   ///
//   ///After lazy oblects are initialized, they are not lazy anymore so they
//   /// won't be affected by this method.
//   ///
//   ///If object are [Mortal] they won't  be call [Mortal.onDie] method,also
//   ///Rebirth option is ignored.
//   void clearLazy();

//   ///Clean all mortal objects
//   ///It calls [Mortal.onDie] method
//   ///
//   ///If  rebirth option is true, it calls [Mortal.onReproduce] so the inyector
//   ///won't be empty.
//   void cleanMortal();

//   ///Clean all regular and mortal objects
//   ///It calls [Mortal.onDie] method and [Mortal.onReproduce] method so the
//   /// inyector won't be empty.
//   void clean();

//   /// Clear all regular and mortal objects. It calls [Mortal.onDie] method
//   /// for all objects [Mortal]s.
//   ///
//   /// rebirth option is ignored all data will be lost.
//   void clear();
// }

// final class _Inyector implements Inyector {
//   _Inyector._();

//   final _livingThings = InyectorManager();
//   final _deadThings = InyectorManager();
//   final _lazy = InyectorManager();

//   //Name tag creator
//   String _createNameTag(Type type, String key) => '${type}_$key';

//   _InyectorLivingItem<T> _wakeLazy<T extends Mortal>(String nameTag) {
//     final item = _lazy.remove<_InyectorLivingLazyItem<T>>(key: nameTag);
//     final instance = item.spawner();
//     final result = _InyectorLivingItem<T>(
//       instance: instance,
//       canReproduce: item.canReproduce,
//     );
//     result.instance.onBirth();
//     _livingThings.add<_InyectorLivingItem<T>>(dependency: result, key: nameTag);
//     return result;
//   }

//   void _toLazy<T extends Mortal>({
//     required T Function() spawn,
//     required String nameTag,
//     required bool canReproduce,
//   }) {
//     _lazy.add<_InyectorLivingLazyItem<T>>(
//       dependency: _InyectorLivingLazyItem<T>(
//         spawner: spawn,
//         canReproduce: canReproduce,
//       ),
//       key: nameTag,
//     );
//   }

//   @override
//   void add<T extends Mortal>(
//     T Function() spawn, {
//     String? tag,
//     bool lazy = false,
//     bool rebirth = false,
//   }) {
//     final nameTag = _createNameTag(T, tag ?? '');
//     if (lazy) {
//       _toLazy<T>(spawn: spawn, nameTag: nameTag, canReproduce: rebirth);
//       log('\x1B[35mLazy dependency added: $nameTag\x1B[0m', name: 'Inyector');
//       return;
//     }
//     final instance = spawn.call();

//     final item = _InyectorLivingItem<T>(
//       instance: instance,
//       canReproduce: rebirth,
//     );
//     _livingThings.add<_InyectorLivingItem<T>>(dependency: item, key: nameTag);
//     item.instance.onBirth();
//     log('\x1B[35m Dependency added: $nameTag \x1B[0m', name: 'Inyector');
//   }

//   @override
//   Future<void> addAsync<T extends Mortal>(
//     Future<T> Function() spawn, {
//     String? tag,
//     bool rebirth = true,
//   }) async {
//     final nameTag = _createNameTag(T, tag ?? '');
//     final instance = await spawn();
//     final item = _InyectorLivingItem<T>(
//       instance: instance,
//       canReproduce: rebirth,
//     );
//     _livingThings.add<_InyectorLivingItem<T>>(dependency: item, key: nameTag);
//     item.instance.onBirth();
//     log('\x1B[35mDependency added: $nameTag\x1B[0m', name: 'Inyector');
//   }

//   @override
//   T get<T extends Mortal>({String? key}) {
//     final nameTag = _createNameTag(T, key ?? '');
//     if (_lazy.exists(nameTag)) {
//       final item = _wakeLazy<T>(nameTag).instance..onAsk();
//       log('\x1B[35mDependency asked: $nameTag\x1B[0m', name: 'Inyector');
//       return item;
//     }
//     log('\x1B[35mDependency asked: $nameTag\x1B[0m', name: 'Inyector');
//     final instance =
//         _livingThings.get<_InyectorLivingItem<T>>(key: nameTag).instance
//           ..onAsk();
//     return instance;
//   }

//   @override
//   T getIt<T>({String? tag}) {
//     final nameTag = _createNameTag(T, tag ?? '');
//     if (_lazy.exists(nameTag)) {
//       final item = _lazy.remove<T Function()>(key: nameTag).call();
//       _deadThings.add<T>(dependency: item, key: nameTag);
//       return item;
//     }
//     return _deadThings.get<T>(key: nameTag);
//   }

//   @override
//   void lazyRegister<T>(T Function() factoryFunction, {String? tag}) {
//     final nameTag = _createNameTag(T, tag ?? '');
//     _lazy.add<T Function()>(dependency: factoryFunction, key: nameTag);
//   }

//   @override
//   void register<T>(T instance, {String? tag}) {
//     final nameTag = _createNameTag(T, tag ?? '');
//     _deadThings.add<T>(dependency: instance, key: nameTag);
//   }

//   @override
//   void remove<T extends Mortal>({String? tag}) {
//     final nameTag = _createNameTag(T, tag ?? '');
//     final old = _livingThings.get<_InyectorLivingItem<T>>(key: nameTag);
//     if (old.canReproduce) {
//       final newDependency = _InyectorLivingItem<T>(
//         instance: old.instance.onReproduce() as T,
//         canReproduce: old.canReproduce,
//       );
//       _livingThings.replace(dependency: newDependency, key: nameTag);
//       old.instance.onDie();

//       log('\x1B[35mDependency reproduced: $nameTag\x1B[0m', name: 'Inyector');
//       return;
//     }

//     _livingThings.remove<_InyectorLivingItem<T>>(key: nameTag).instance.onDie();
//     log('\x1B[35mDependency removed: $nameTag\x1B[0m', name: 'Inyector');
//   }

//   @override
//   void unregister<T>({String? tag}) {
//     _deadThings.remove<T>(key: _createNameTag(T, tag ?? ''));
//   }

//   @override
//   void clearRegular() => _deadThings.clear();

//   @override
//   void clearLazy() => _lazy.clear();

//   void _genoside(List<Mortal> mortals) {
//     for (final value in mortals) {
//       value.onDie();
//     }
//   }

//   @override
//   void cleanMortal() {
//     final values =
//         _livingThings.getDependencies()
//             as Map<String, _InyectorLivingItem<Mortal>>;
//     _livingThings.clear();
//     values.forEach((key, value) {
//       if (value.canReproduce) {
//         final child = value.instance.onReproduce()..onBirth();
//         _livingThings.add(dependency: child, key: key);
//       }
//       value.instance.onDie();
//     });
//   }

//   @override
//   void clean() {
//     clearRegular();
//     clearLazy();
//     cleanMortal();
//   }

//   @override
//   void clear() {
//     clearLazy();
//     clearRegular();
//     final values = _deadThings.getDependencies() as Map<String, Mortal>;
//     _livingThings.clear();
//     _genoside(values.values.toList());
//   }
// }

// final class _InyectorLivingItem<T extends Mortal> {
//   _InyectorLivingItem({required this.instance, required this.canReproduce});
//   final T instance;
//   final bool canReproduce;
// }

// final class _InyectorLivingLazyItem<T extends Mortal> {
//   _InyectorLivingLazyItem({required this.spawner, required this.canReproduce});

//   final T Function() spawner;
//   final bool canReproduce;
// }
