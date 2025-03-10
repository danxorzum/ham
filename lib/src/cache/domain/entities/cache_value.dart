import 'package:ham_framework/src/core/core.dart';

/// {@template cache_value}
/// Represents an entity that stores cache information.
/// The CacheValue class stores:
/// [key] The unique key for the cache item.
/// [value] The value of the object to be stored in the cache, represented as
/// JSON.
/// [expirationDate] The expiration date for the object stored in the cache.
/// {@endtemplate}
class CacheValue {
  ///{@macro cache_value}
  CacheValue({
    required this.key,
    required this.value,
    required this.expirationDate,
  });

  /// Creates a CacheValue object from a Json
  factory CacheValue.fromJson(dynamic json) => CacheValue(
    key: json['key'] as String, // Retrieves the key from the JSON.
    value: json['value'] as Json, // Retrieves the value from the JSON.
    expirationDate: DateTime.parse(
      json['expirationDate'] as String,
    ), // Converts the expiration date from an ISO 8601 string.
  );

  /// The unique key for the cached object.
  final String key;

  /// The value of the object to be stored in the cache, represented as Json.
  final Json value;

  /// The expiration date for the object stored in the cache.
  final DateTime expirationDate;

  /// Checks if the object stored in the cache has expired.
  bool get isExpired => expirationDate.isBefore(DateTime.now());

  /// Converts the CacheValue object into a  Json.
  Map<String, dynamic> toJson() => {
    'key': key,
    'value': value,
    'expirationDate': expirationDate.toIso8601String(),
  };
}
