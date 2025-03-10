import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ham_framework/src/cache/application/application.dart';
import 'package:ham_framework/src/cache/domain/domain.dart';
import 'package:ham_framework/src/cache/infrastructure/adapters/drivens/hive_adapter.dart';
import 'package:ham_framework/src/cache/infrastructure/ports/ports.dart';
import 'package:ham_framework/src/core/core.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// {@template ham_cache}
/// HamCache is a light and powerful cache service.
///
///You have to add to `Inyector` before `HamApp` initialization.
///or call onBirth() on your own.
/// You can manage cache in memory and on disk.
/// {@endtemplate}
final class HamCache implements Mortal, CacheRetriver {
  /// {@macro ham_cache}
  HamCache({CacheType cacheType = CacheType.memoryAndDisk})
    : _cacheType = cacheType;

  late CacheManager _cacheManager;
  final CacheType _cacheType;
  @override
  void onAsk() {}

  @override
  Future<void> onBirth() async {
    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      Hive.defaultDirectory = directory.path;
    } else {
      await Isar.initialize();
      Hive.defaultDirectory = 'ham_cache';
    }
    Hive.registerAdapter('CacheValue', CacheValue.fromJson);
    _cacheManager = CacheManager(
      hotCache: HotCache(),
      coolCache: HiveAdapter(),
    );
    if (_cacheType == CacheType.memoryAndDisk || _cacheType == CacheType.disk) {
      {
        _cacheManager.verifyExpirationYOrMountInMemory(
          _cacheType,
          _getContainersKeys(),
        );
      }
    }
  }

  @override
  void onDie() {}

  void _registerContainerKey(String container) =>
      Hive.box<String>(name: 'ham_cache').put(container, container);

  List<String> _getContainersKeys() {
    final box = Hive.box<String>(name: 'ham_cache');
    final keys = box.getAll(box.keys);
    return List<String>.from(keys.where((e) => e != null));
  }

  @override
  Mortal onReproduce() {
    _cacheManager.clearAll();
    return this;
  }

  @override
  FutureOr<void> clear({CacheType? cacheType}) =>
      _cacheManager.clearAll(cacheType: cacheType ?? _cacheType);

  @override
  FutureOr<void> clearContainer({
    required String container,
    CacheType? cacheType,
  }) {
    _cacheManager.clear(
      container: container,
      cacheType: cacheType ?? _cacheType,
    );
    Hive.box<String>(name: 'ham_cache').delete(container);
  }

  @override
  FutureOr<T?> getFromcache<T>({
    required T Function(Json json) decoder,
    required String container,
    required String key,
    CacheType? cacheType,
  }) => _cacheManager.load<T>(
    decoder: decoder,
    container: container,
    key: key,
    cacheType: cacheType ?? _cacheType,
  );

  @override
  FutureOr<void> remove({
    required String container,
    required String key,
    CacheType? cacheType,
  }) => _cacheManager.delete(
    container: container,
    key: key,
    cacheType: cacheType ?? _cacheType,
  );

  @override
  FutureOr<void> setToCache<T>({
    required T value,
    required Json Function() encoder,
    required String container,
    required String key,
    required DateTime expirationDate,
    CacheType? cacheType,
  }) {
    _cacheManager.save(
      value: value,
      encoder: encoder,
      container: container,
      expirationDate: expirationDate,
      key: key,
      cacheType: cacheType ?? _cacheType,
    );
    _registerContainerKey(container);
  }
}
