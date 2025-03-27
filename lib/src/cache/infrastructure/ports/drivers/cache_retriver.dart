import 'dart:async';

import 'package:ham/src/cache/domain/domain.dart';
import 'package:ham/src/core/core.dart';

/// {@template cache_retriver}
/// Interface for cache retriver.
/// {@endtemplate}
abstract interface class CacheRetriver {
  /// Get a value from cache.
  ///
  /// `HamCache` uses `Inyector` to  try to get the decoder if already exists.
  /// If you already registered the decoder, leave `decoder` null.
  ///
  /// Throws [DecoderNotFoundException] if the decoder is not found.
  ///
  /// {@template cache_type}
  /// [cacheType] is the type of cache to use. if null, use the general config.
  /// {@endtemplate}
  FutureOr<T?> getFromcache<T extends Object>({
    required String container,
    required String key,
    T Function(Json json)? decoder,
    CacheType? cacheType,
  });

  /// Set a value in cache.
  ///
  ///{@macro cache_type}
  FutureOr<void> setToCache<T>({
    required T value,
    required Json Function() encoder,
    required String container,
    required String key,
    required DateTime expirationDate,
    CacheType? cacheType,
  });

  /// Remove a value from cache.
  ///
  /// {@macro cache_type}
  FutureOr<void> remove({
    required String container,
    required String key,
    CacheType? cacheType,
  });

  /// Clear container from cache.
  ///
  /// {@macro cache_type}
  FutureOr<void> clearContainer({
    required String container,
    CacheType? cacheType,
  });

  ///Clear all cache.
  ///
  /// {@macro cache_type}
  FutureOr<void> clear({CacheType? cacheType});
}
