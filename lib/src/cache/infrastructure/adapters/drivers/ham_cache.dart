import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ham/src/cache/application/application.dart';
import 'package:ham/src/cache/domain/domain.dart';
import 'package:ham/src/cache/infrastructure/adapters/drivens/hive_adapter.dart';
import 'package:ham/src/cache/infrastructure/models/cache_value_hive.dart';
import 'package:ham/src/cache/infrastructure/ports/ports.dart';
import 'package:ham/src/core/core.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:hive_flutter/hive_flutter.dart';

/// {@template ham_cache}
/// HamCache is a light and powerful cache service.
///
/// [constructor] is the only constructor of [HamCache].
///
///`runHamApp` configures [HamCache] and injects it into [Inyector].
/// {@endtemplate}
final class HamCache implements CacheRetriver {
  /// {@macro ham_cache}
  HamCache._(this._cacheType, this._cacheManager);

  final CacheManager _cacheManager;
  final CacheType _cacheType;

  /// {@macro ham_cache}
  /// Constructor and initializer
  static Future<HamCache> constructor({
    CacheType cacheType = CacheType.memoryAndDisk,
  }) async {
    if (kIsWeb) {
      Hive.init(null);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
    }
    Hive.registerAdapter(CacheValueHiveAdapter());
    final box = await Hive.openBox<String>('ham_cache');
    final cache = CacheManager(
      hotCache: HotCache(),
      coolCache: HiveAdapter(cacheContainer: 'ham_cache'),
    );
    final hamCache = HamCache._(cacheType, cache);
    if (hamCache._cacheType == CacheType.memoryAndDisk ||
        hamCache._cacheType == CacheType.disk) {
      {
        hamCache._cacheManager.verifyExpirationYOrMountInMemory(
          hamCache._cacheType,
          box.toMap().values.toList(),
        );
      }
    }
    return hamCache;
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
  }

  @override
  FutureOr<T?> getFromcache<T extends Object>({
    required String container,
    required String key,
    T Function(Json json)? decoder,
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
  }
}
