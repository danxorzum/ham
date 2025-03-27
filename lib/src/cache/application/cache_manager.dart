import 'dart:async';
import 'package:ham/src/cache/domain/domain.dart';
import 'package:ham/src/core/core.dart';

/// {@template cache_manager}
/// CacheManager is a service that provides methods to manage cache.
/// {@endtemplate}
final class CacheManager implements CacheService {
  /// {@macro cache_manager}
  CacheManager({
    required CacheRepository hotCache,
    required CacheRepository coolCache,
  }) : _hotCache = hotCache,
       _coolCache = coolCache;

  final CacheRepository _hotCache;
  final CacheRepository _coolCache;

  void _cacheHandle({
    required CacheType cacheType,
    required Callback hot,
    required Callback cold,
  }) {
    if (cacheType == CacheType.memoryAndDisk || cacheType == CacheType.memory) {
      hot();
    }
    if (cacheType == CacheType.memoryAndDisk || cacheType == CacheType.disk) {
      cold();
    }
  }

  @override
  FutureOr<void> clear({
    required String container,
    CacheType cacheType = CacheType.memoryAndDisk,
  }) async {
    _cacheHandle(
      cacheType: cacheType,
      hot: () async => await _hotCache.clearContainer(container),
      cold: () async => await _coolCache.clearContainer(container),
    );
  }

  @override
  FutureOr<void> clearAll({
    CacheType cacheType = CacheType.memoryAndDisk,
  }) async {
    _cacheHandle(
      cacheType: cacheType,
      hot: () async => await _hotCache.clear(),
      cold: () async => await _coolCache.clear(),
    );
  }

  @override
  FutureOr<void> delete({
    required String container,
    required String key,
    CacheType cacheType = CacheType.memoryAndDisk,
  }) async {
    _cacheHandle(
      cacheType: cacheType,
      hot: () async => await _hotCache.remove(container, key),
      cold: () async => await _coolCache.remove(container, key),
    );
  }

  @override
  FutureOr<T?> load<T>({
    required String container,
    required String key,
    T Function(Map<String, dynamic> json)? decoder,
    CacheType cacheType = CacheType.memoryAndDisk,
  }) async {
    if (cacheType == CacheType.memoryAndDisk || cacheType == CacheType.memory) {
      final rawValue = await _hotCache.get(container, key);
      if (rawValue != null) {
        if (rawValue.isExpired) {
          await _hotCache.remove(container, key);
        } else {
          if (decoder == null) {
            try {
              return Inyector.decode<T>(rawValue.value);
            } on InyectorKeyNotFound catch (e) {
              throw DecoderNotFoundException(message: e.message);
            }
          } else {
            return decoder.call(rawValue.value);
          }
        }
      }
    }

    if (cacheType == CacheType.memoryAndDisk || cacheType == CacheType.disk) {
      final rawValue = await _coolCache.get(container, key);
      if (rawValue != null) {
        if (rawValue.isExpired) {
          await _coolCache.remove(container, key);
          return null;
        }
        late final T? value;
        if (decoder == null) {
          try {
            value = Inyector.decode<T>(rawValue.value);
          } on InyectorKeyNotFound catch (e) {
            throw DecoderNotFoundException(message: e.message);
          }
        } else {
          value = decoder.call(rawValue.value);
        }

        if (cacheType == CacheType.memoryAndDisk && value != null) {
          await _hotCache.set(container, rawValue);
        }

        return value;
      }
    }

    return null;
  }

  @override
  FutureOr<void> save<T>({
    required T value,
    required DateTime expirationDate,
    required Json Function() encoder,
    required String container,
    required String key,
    CacheType cacheType = CacheType.memoryAndDisk,
  }) {
    final cacheVal = CacheValue(
      expirationDate: expirationDate,
      value: encoder(),
      key: key,
    );
    _cacheHandle(
      cacheType: cacheType,
      hot: () async => await _hotCache.set(container, cacheVal),
      cold: () async => await _coolCache.set(container, cacheVal),
    );
  }

  @override
  FutureOr<void> verifyExpirationYOrMountInMemory(
    CacheType cacheType,
    List<String> containers,
  ) async {
    assert(
      cacheType != CacheType.memory,
      "You can't load from disk to memory if you don't enable disk",
    );

    for (final containerKey in containers) {
      final container = await _hotCache.getContainer(containerKey);
      if (container != null) {
        for (final entry in container.entries) {
          final key = entry.key;
          final value = entry.value;

          if (value.isExpired) {
            await _hotCache.remove(containerKey, key);
          } else if (cacheType == CacheType.memoryAndDisk) {
            await _coolCache.set(containerKey, value);
          }
        }
      }
    }
  }
}
