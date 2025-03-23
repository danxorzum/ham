import 'package:ham/src/core/core.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'cache_value_hive.g.dart';

/// {@template CacheValueHive}
/// Represents an entity that stores cache information.
/// Used to store `CacheValue` in hive.
/// {@endtemplate}
@HiveType(typeId: 0)
final class CacheValueHive extends HiveObject {
  /// {@macro CacheValueHive}
  CacheValueHive({
    required this.cacheKey,
    required this.value,
    required this.expirationDate,
  });

  /// The key of the object stored in the cache.
  @HiveField(0)
  final String cacheKey;

  @HiveField(1)
  /// The value of the object to be stored in the cache, represented as Json.
  final Json value;

  @HiveField(2)
  /// The expiration date for the object stored in the cache.
  final DateTime expirationDate;
}
