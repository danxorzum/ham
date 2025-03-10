import 'dart:async';

import 'package:ham_framework/src/cache/domain/entities/cache_value.dart';
import 'package:ham_framework/src/cache/domain/exceptions/exceptions.dart';

/// {@template cache_repository}
/// Repository to manage the cache of the app.
/// {@endtemplate}
abstract interface class CacheRepository {
  /// Get a value from the cache.
  FutureOr<CacheValue?> get(String container, String key);

  ///Get entire cache container
  FutureOr<Map<String, CacheValue>>? getContainer(String container);

  /// Set a value in the cache
  FutureOr<void> set(String container, CacheValue value);

  ///Set entire cache container
  FutureOr<void> setContainer(String container, List<CacheValue> values);

  /// Remove a value from the cache
  ///
  /// If something fail throw [DeleteFailedException]
  FutureOr<void> remove(String container, String key);

  /// Clear all the cache
  FutureOr<void> clear();

  ///Clear all the cache container
  FutureOr<void> clearContainer(String container);
}
