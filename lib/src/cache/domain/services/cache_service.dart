import 'dart:async';

import 'package:ham/src/cache/domain/domain.dart';
import 'package:ham/src/core/core.dart';

/// {@template CacheService}
/// CacheService is a service that provides methods to manage cache.
/// {@endtemplate}
abstract interface class CacheService {
  ///Save a value in the cache.
  ///{@template keys}
  ///Use the [key] to identify the value.
  ///The [container] is the name of the cache container affected.
  ///[cacheType] used to specify the type of cache to be used. default is
  ///[CacheType.memoryAndDisk].
  ///{@endtemplate}
  ///
  ///[value] The value to be saved in the cache.
  ///[encoder] A function that takes a value of type [T] and returns a `Json`.
  ///[container] The name of the cache container.
  FutureOr<void> save<T>({
    required T value,
    required DateTime expirationDate,
    required Json Function() encoder,
    required String container,
    required String key,
    CacheType cacheType = CacheType.memoryAndDisk,
  });

  ///Load a value from the cache.
  ///{@macro keys}
  ///
  ///[decoder] A function that takes a `Json` and returns a value of type [T].
  ///
  ///If [decoder] is not provided, it will try to find a decoder in `Injector`.
  ///If [decoder] is not found, it will throw a [DecoderNotFoundException].
  FutureOr<T?> load<T>({
    required String container,
    required String key,
    T Function(Json)? decoder,
    CacheType cacheType = CacheType.memoryAndDisk,
  });

  ///Delete a value from the cache.
  ///
  ///{@macro keys}
  FutureOr<void> delete({
    required String container,
    required String key,
    CacheType cacheType = CacheType.memoryAndDisk,
  });

  ///Clear all values from container.
  ///{@macro keys}
  ///
  ///
  FutureOr<void> clear({
    required String container,
    CacheType cacheType = CacheType.memoryAndDisk,
  });

  ///Clear all values from all containers.
  /// [cacheType] used to specify the type of cache to be used. default is
  FutureOr<void> clearAll({CacheType cacheType = CacheType.memoryAndDisk});

  /// Loads all cached values from disk and verifies their expiration dates.
  ///
  /// This function behaves differently based on the [cacheType]:
  /// - If [cacheType] is [CacheType.disk], it will only load values from disk
  /// and check if they are expired.
  /// - If [cacheType] is [CacheType.memoryAndDisk], it will first load all
  /// values from disk, verify their expiration dates,
  ///   and then upload the non-expired values to memory for faster future
  /// access.
  ///
  /// It ensures that expired values are removed, and non-expired values are
  /// either kept in memory or returned for further use.
  ///
  /// [cacheType]: Specifies which caches to interact with, either just the disk
  /// or both memory and disk.
  FutureOr<void> verifyExpirationYOrMountInMemory(
    CacheType cacheType,
    List<String> containers,
  );
}
