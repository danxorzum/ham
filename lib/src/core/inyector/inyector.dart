import 'dart:developer';

import 'package:ham_framework/src/core/dependencies/base/mortal.dart';
import 'package:ham_framework/src/core/inyector/inyector_manager.dart';

/// {@template inyector}
/// The inyector is a singleton class that is used to inject dependencies into
/// the application.
///
/// [Inyector] can handle regular and [Mortal] dependencies.
///
/// [Mortal] dependencies are objects that have a life cycle. Inyecor uses.
///
/// [Mortal] dependencies use to be like repositores, services etc.
/// {@endtemplate}
sealed class Inyector {
  // singleton
  static final _Inyector _instance = _Inyector._();

  /// Get the instance of the [Inyector]
  static Inyector get instance => _instance;

  /// Short way to get the instance of the [Inyector]
  static Inyector get I => _instance;

  //Regular Injection Methods
  ///Register a regular object
  void register<T>(T instance, {String? tag});

  ///Unregister a regular object
  void unregister<T>({String? tag});

  ///Register a regular object in a lazy way.
  void lazyRegister<T>(T Function() factoryFunction, {String? tag});

  ///Get a regular object
  T getIt<T>({String? tag});

  //Mortal Injection Methods
  ///Register a mortal object and use theyr life cycle.
  ///
  ///{@template add}
  ///[spawn] is a function that returns a mortal object.
  ///[tag] is a unique key for the mortal object in case you want to have
  /// multiple instances of the same mortal.
  /// [lazy] is a flag that indicates if the mortal object should be created
  /// lazily.
  /// [rebirth] is a flag that indicates if the mortal object can be reproduced
  /// when it dies. Reproduction is a feature that allows to reuse dependencies
  /// witout creating new ones. Per example when app logs out, we want to reuse
  /// the same dependencies without old data, But we don't want to create new
  /// ones.
  /// {@endtemplate}
  void add<T extends Mortal>(
    T Function() spawn, {
    String? tag,
    bool lazy = false,
    bool rebirth = true,
  });

  ///Register a mortal async object
  ///{@macro add}
  Future<void> addAsync<T extends Mortal>(
    Future<T> Function() spawn, {
    String? tag,
    bool rebirth = true,
  });

  ///Remove a mortal object
  ///
  ///`WARNING: You should never call any mortal object after removing it.`
  ///Before removing a mortal object, [remove] calls [Mortal.onDie] method.
  void remove<T extends Mortal>({String? tag});

  ///Get a mortal object
  T get<T extends Mortal>({String? key});

  ///Clean all regular objects
  void clearRegular();

  ///Clean all lazy objects
  ///
  ///After lazy oblects are initialized, they are not lazy anymore so they
  /// won't be affected by this method.
  ///
  ///If object are [Mortal] they won't  be call [Mortal.onDie] method,also
  ///Rebirth option is ignored.
  void clearLazy();

  ///Clean all mortal objects
  ///It calls [Mortal.onDie] method
  ///
  ///If  rebirth option is true, it calls [Mortal.onReproduce] so the inyector
  ///won't be empty.
  void cleanMortal();

  ///Clean all regular and mortal objects
  ///It calls [Mortal.onDie] method and [Mortal.onReproduce] method so the
  /// inyector won't be empty.
  void clean();

  /// Clear all regular and mortal objects. It calls [Mortal.onDie] method
  /// for all objects [Mortal]s.
  ///
  /// rebirth option is ignored all data will be lost.
  void clear();
}

final class _Inyector implements Inyector {
  _Inyector._();

  final _livingThings = InyectorManager();
  final _deadThings = InyectorManager();
  final _lazy = InyectorManager();

  //Name tag creator
  String _createNameTag(Type type, String key) => '${type}_$key';

  _InyectorLivingItem<T> _wakeLazy<T extends Mortal>(String nameTag) {
    final item = _lazy.remove<_InyectorLivingLazyItem<T>>(
      key: nameTag,
    );
    final instance = item.spawner();
    final result = _InyectorLivingItem<T>(
      instance: instance,
      canReproduce: item.canReproduce,
    );
    result.instance.onBirth();
    _livingThings.add<_InyectorLivingItem<T>>(dependency: result, key: nameTag);
    return result;
  }

  void _toLazy<T extends Mortal>({
    required T Function() spawn,
    required String nameTag,
    required bool canReproduce,
  }) {
    _lazy.add<_InyectorLivingLazyItem<T>>(
      dependency: _InyectorLivingLazyItem<T>(
        spawner: spawn,
        canReproduce: canReproduce,
      ),
      key: nameTag,
    );
  }

  @override
  void add<T extends Mortal>(
    T Function() spawn, {
    String? tag,
    bool lazy = false,
    bool rebirth = false,
  }) {
    final nameTag = _createNameTag(T, tag ?? '');
    if (lazy) {
      _toLazy<T>(spawn: spawn, nameTag: nameTag, canReproduce: rebirth);
      log('\x1B[35mLazy dependency added: $nameTag\x1B[0m', name: 'Inyector');
      return;
    }
    final instance = spawn.call();

    final item = _InyectorLivingItem<T>(
      instance: instance,
      canReproduce: rebirth,
    );
    _livingThings.add<_InyectorLivingItem<T>>(dependency: item, key: nameTag);
    item.instance.onBirth();
    log('\x1B[35m Dependency added: $nameTag \x1B[0m', name: 'Inyector');
  }

  @override
  Future<void> addAsync<T extends Mortal>(
    Future<T> Function() spawn, {
    String? tag,
    bool rebirth = true,
  }) async {
    final nameTag = _createNameTag(T, tag ?? '');
    final item = _InyectorLivingItem<T>(
      instance: await spawn(),
      canReproduce: rebirth,
    );
    _livingThings.add<_InyectorLivingItem<T>>(dependency: item, key: nameTag);
    item.instance.onBirth();
    log('\x1B[35mDependency added: $nameTag\x1B[0m', name: 'Inyector');
  }

  @override
  T get<T extends Mortal>({String? key}) {
    final nameTag = _createNameTag(T, key ?? '');
    if (_lazy.exists(nameTag)) {
      final item = _wakeLazy<T>(nameTag).instance..onAsk();
      log('\x1B[35mDependency asked: $nameTag\x1B[0m', name: 'Inyector');
      return item;
    }
    log('\x1B[35mDependency asked: $nameTag\x1B[0m', name: 'Inyector');
    final instance = _livingThings
        .get<_InyectorLivingItem<T>>(key: nameTag)
        .instance
      ..onAsk();
    return instance;
  }

  @override
  T getIt<T>({String? tag}) {
    final nameTag = _createNameTag(T, tag ?? '');
    if (_lazy.exists(nameTag)) {
      final item = _lazy.remove<T Function()>(key: nameTag).call();
      _deadThings.add<T>(dependency: item, key: nameTag);
      return item;
    }
    return _deadThings.get<T>(key: nameTag);
  }

  @override
  void lazyRegister<T>(T Function() factoryFunction, {String? tag}) {
    final nameTag = _createNameTag(T, tag ?? '');
    _lazy.add<T Function()>(dependency: factoryFunction, key: nameTag);
  }

  @override
  void register<T>(T instance, {String? tag}) {
    final nameTag = _createNameTag(T, tag ?? '');
    _deadThings.add<T>(dependency: instance, key: nameTag);
  }

  @override
  void remove<T extends Mortal>({String? tag}) {
    final nameTag = _createNameTag(T, tag ?? '');
    final old = _livingThings.get<_InyectorLivingItem<T>>(key: nameTag);
    if (old.canReproduce) {
      final newDependency = _InyectorLivingItem<T>(
        instance: old.instance.onReproduce() as T,
        canReproduce: old.canReproduce,
      );
      _livingThings.replace(dependency: newDependency, key: nameTag);
      old.instance.onDie();

      log('\x1B[35mDependency reproduced: $nameTag\x1B[0m', name: 'Inyector');
      return;
    }

    _livingThings.remove<_InyectorLivingItem<T>>(key: nameTag).instance.onDie();
    log('\x1B[35mDependency removed: $nameTag\x1B[0m', name: 'Inyector');
  }

  @override
  void unregister<T>({String? tag}) {
    _deadThings.remove<T>(key: _createNameTag(T, tag ?? ''));
  }

  @override
  void clearRegular() => _deadThings.clear();

  @override
  void clearLazy() => _lazy.clear();

  void _genoside(List<Mortal> mortals) {
    for (final value in mortals) {
      value.onDie();
    }
  }

  @override
  void cleanMortal() {
    final values = _livingThings.getDependencies()
        as Map<String, _InyectorLivingItem<Mortal>>;
    _livingThings.clear();
    values.forEach((key, value) {
      if (value.canReproduce) {
        final child = value.instance.onReproduce()..onBirth();
        _livingThings.add(dependency: child, key: key);
      }
      value.instance.onDie();
    });
  }

  @override
  void clean() {
    clearRegular();
    clearLazy();
    cleanMortal();
  }

  @override
  void clear() {
    clearLazy();
    clearRegular();
    final values = _deadThings.getDependencies() as Map<String, Mortal>;
    _livingThings.clear();
    _genoside(values.values.toList());
  }
}

final class _InyectorLivingItem<T extends Mortal> {
  _InyectorLivingItem({required this.instance, required this.canReproduce});
  final T instance;
  final bool canReproduce;
}

final class _InyectorLivingLazyItem<T extends Mortal> {
  _InyectorLivingLazyItem({required this.spawner, required this.canReproduce});

  final T Function() spawner;
  final bool canReproduce;
}
