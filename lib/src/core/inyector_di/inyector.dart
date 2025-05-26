// Unsused_element is ignored because the class is abstract
// With abstract methods so only can be implemented here
// ignore_for_file: unused_element
import 'dart:developer';

import 'package:ham/src/core/defs/defs.dart';
import 'package:ham/src/core/exceptions/exceptions.dart';
import 'package:ham/src/core/inyector_di/inyector_manager.dart';
import 'package:ham/src/core/lifecycles/lifecycles.dart';
import 'package:ham/src/core/utils/utils.dart';

/// Generic onstructor definition.
typedef JsonConstructorGeneric = Object Function(Json json);

/// Constructor definition.
typedef JsonContructor<T> = T Function(Json json);

/// {@template inyector}
/// `Inyector` is a DI container whit life..
///
/// `Inyector` can handle regular and `Mortal` dependencies.
///
/// `Mortal` dependencies are objects that implement the [Mortal] life cycle:
///  - [Mortal.onBirth] is called when the object is created.
///  - [Mortal.onChildBirth] is called when a new descendant (child) is created
/// from this object.
///  - [Mortal.onAsk] is called when the object is founded in the inyector.
///  - [Mortal.onReproduce] is called when the object copies itself.
///  It called before the [Mortal.onDie] method.
///  - [Mortal.onDie] is called when the object is disposed and removed from the
///  [Inyector].
///  - [Mortal.onDieWithoutChildren] is called when the object is disposed
/// without having created descendants. This method is called only if the
/// dependency is not mortal.
///
/// If dependencies are't mortal, they won't be affected by the [Inyector] life
/// cycle.
///
/// [Inyector] also can handle json decoders.
/// Register a json decoder [Inyector.registerJsonDecoder] or a bunch of them
/// [Inyector.registerJsonsDecoders] then you can decode those Types anywhere.
/// {@endtemplate}
sealed class Inyector {
  static final _Inyector _instance = _Inyector._();

  /// Get the instance of the [Inyector]
  static Inyector get instance => _instance;

  /// Get the instance of the [Inyector] short way
  static Inyector get I => _instance;

  ///Register from Json constructor to decode based on type.
  static void registerJsonDecoder<T>(JsonContructor<T> fromJson) =>
      _instance._registerJsonDecoder(fromJson);

  ///Register decodesr for multiple types.
  static void registerJsonsDecoders(
    Map<Type, JsonConstructorGeneric> fromJsons,
  ) => _instance._registerJsonsDecoders(fromJsons);

  ///Decode a json to a type.
  static T decode<T>(Json json) => _instance._decode(json);

  /// Unregister a json decoder.
  static void unregisterJsonDecoder<T>() =>
      _instance._unregisterJsonDecoder<T>();

  ///{@template add}
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
  /// {@endtemplate}
  static void add<T>(
    T Function() spawn, {
    String? tag,
    bool lazy = false,
    bool rebirth = true,
  }) => _instance._add(spawn, tag: tag, lazy: lazy, rebirth: rebirth);

  ///{@template addAsync}
  /// Future version of [add].
  ///
  /// {@macro add}
  /// {@endtemplate}
  static Future<void> addAsync<T>(
    Future<T> Function() spawn, {
    String? tag,
    bool rebirth = false,
  }) => _instance._addAsync(spawn, tag: tag, rebirth: rebirth);

  ///{@template remove}
  /// Remove dependency from the `inyector`.
  ///
  /// In `Mortal` dependencies, [Mortal.onDie] method is called before removing.
  ///
  /// If dependency was registered as `rebirth`able it regenarete non mortals
  /// dependencies. In `Mortal` dependencies, [Mortal.onReproduce] method is
  /// called before removing.
  ///
  /// Throws HamException if dependency is not found.
  /// {@endtemplate}
  static void remove<T>({String? tag}) => _instance._remove<T>(tag: tag);

  ///{@template get}
  /// Get dependency from the `inyector`.
  ///
  /// If dependency is mortal, [Mortal.onAsk] method is called.
  ///
  /// Throws HamException if dependency is not found.
  /// {@endtemplate}
  static T get<T>({String? key}) => _instance._get<T>(key: key);

  ///{@template clean}
  /// Clean all dependencies. In non motals if `rebirth` option is true, it
  /// calls `spawn` method.
  ///
  /// In `Mortal` dependencies, if `rebirth` is true, [Mortal.onReproduce]
  /// method is called.
  /// [Mortal.onDie] method is called in each mortal dependency.
  /// {@endtemplate}
  static void clean() => _instance._clean();

  ///{@template reset}
  /// Reset the `inyector`. delete all dependencies and they can't `rebirth`,
  /// even if `rebirth` option is true.
  ///
  /// It calls [Mortal.onDie] method for all objects [Mortal]s.
  /// {@endtemplate}
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

  void _registerJsonDecoder<T>(JsonContructor<T> fromJson);

  void _unregisterJsonDecoder<T>();

  void _registerJsonsDecoders(Map<Type, JsonConstructorGeneric> fromJsons);

  T _decode<T>(Json json);
}

final class _Inyector implements Inyector {
  _Inyector._();

  final _dependencies = InyectorManager();
  final _lazyDependencies = InyectorManager();
  final _decoders = InyectorManager();

  _InyectorItem<T> _wakeLazy<T>(String nameTag) {
    late final _InyectoLazyItem<T> lazyItem;
    if (_lazyDependencies.get<_InyectoLazyItem<T>>(key: nameTag).canRebirth &&
        T is! Mortal) {
      lazyItem = _lazyDependencies.get<_InyectoLazyItem<T>>(key: nameTag);
    } else {
      lazyItem = _lazyDependencies.remove<_InyectoLazyItem<T>>(key: nameTag);
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

  T _reproduce<T extends Mortal>(T mortal, String name) {
    final child = mortal.onReproduce()..onChildBirth();
    log('\x1B[35m$name onReproduce\x1B[0m', name: 'Inyector');
    log('\x1B[35m$name onChildBirth\x1B[0m', name: 'Inyector');
    mortal.onDie();
    log('\x1B[35m$name onDie\x1B[0m', name: 'Inyector');
    return child as T;
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
      if (item is Mortal) {
        (item as Mortal).onBirth();
        log('\x1B[35m$nameTag onBirth \x1B[0m', name: 'Inyector');
      }
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
        final child = _reproduce(item.instance as Mortal, nameTag);
        _dependencies.add<_InyectorItem<T>>(
          dependency: _InyectorItem<T>(
            instance: child as T,
            canRebirth: item.canRebirth,
          ),
          key: nameTag,
        );
      } else {
        (item.instance as Mortal).onDieWithoutChildren();
        log('\x1B[35m$nameTag onDieWithoutChildren\x1B[0m', name: 'Inyector');
      }
    }
    log('\x1B[35mDependency removed: $nameTag\x1B[0m', name: 'Inyector');
  }

  void _cleanDependencies() {
    _dependencies.getDependencies().forEach((key, value) {
      if ((value as _InyectorItem<dynamic>).instance is Mortal) {
        (value.instance as Mortal).onDieWithoutChildren();
        log(
          '\x1B[35mAll Mortal dependencies onDieWithoutChildren\x1B[0m',
          name: 'Inyector',
        );
      }
    });
    _dependencies.clear();
  }

  @override
  void _clean() {
    final values = _dependencies.getDependencies();
    final rebirths = <String, _InyectorItem<dynamic>>{};
    values.forEach((key, value) {
      if ((value as _InyectorItem<dynamic>).instance is Mortal) {
        if (value.canRebirth) {
          rebirths[key] = value.copyWith(
            instance: _reproduce(value.instance as Mortal, key),
          );
        } else {
          (value.instance as Mortal).onDieWithoutChildren();
          log('\x1B[35m$key onDieWithoutChildren\x1B[0m', name: 'Inyector');
        }
      }
    });
    _dependencies.clear();
    rebirths.forEach((key, value) {
      _dependencies.add<_InyectorItem<dynamic>>(dependency: value, key: key);
    });
    log('\x1B[35mAll dependencies are cleaned\x1B[0m', name: 'Inyector');
  }

  @override
  void _reset() {
    _lazyDependencies.clear();
    _cleanDependencies();
    _decoders.clear();
  }

  @override
  void _registerJsonDecoder<T>(JsonContructor<T> fromJson) {
    final key = nameTagFromType(T, '');
    if (_decoders.exists(key)) {
      throw InyectorDuplicateKey(
        message: 'You already have a decoder registered for this type: $key',
        stackTrace: StackTrace.current,
      );
    }
    _decoders.add(dependency: fromJson, key: key);
  }

  @override
  void _unregisterJsonDecoder<T>() {
    final key = nameTagFromType(T, '');
    _decoders.remove<JsonContructor<T>>(key: key);
  }

  @override
  void _registerJsonsDecoders(Map<Type, JsonConstructorGeneric> fromJsons) {
    fromJsons.forEach((key, value) {
      final fixedKey = nameTagFromType(key, '');
      if (_decoders.exists(fixedKey)) {
        throw InyectorDuplicateKey(
          message:
              'You already have a decoder registered for this type: $fixedKey',
          stackTrace: StackTrace.current,
        );
      }
      _decoders.add(dependency: value, key: fixedKey);
    });
  }

  @override
  T _decode<T>(Json json) {
    final key = nameTagFromType(T, '');
    if (_decoders.exists(key)) {
      return _decoders.get<JsonContructor<T>>(key: key)(json);
    }
    throw InyectorKeyNotFound(
      message:
          'You dont have a decoder registered for: $key. Register it first.',
      stackTrace: StackTrace.current,
    );
  }
}

final class _InyectorItem<T> {
  _InyectorItem({required this.instance, required this.canRebirth});
  final T instance;
  final bool canRebirth;

  _InyectorItem<T> copyWith({T? instance}) {
    return _InyectorItem<T>(
      instance: instance ?? this.instance,
      canRebirth: this.canRebirth,
    );
  }
}

final class _InyectoLazyItem<T> {
  _InyectoLazyItem({required this.spawner, required this.canRebirth});

  final T Function() spawner;
  final bool canRebirth;
}
