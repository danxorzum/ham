import 'package:ham/src/cache/domain/domain.dart';

/// {@template hot_cache}
/// HotCache is memory cache,
///
/// You can save, get, remove and clear cache.
/// HotCache has `container`s so you can organize your cache.
/// {@endtemplate}
@Deprecated('Hotcache is deprecated, becase hive use both memory and disk')
final class HotCache implements CacheRepository {
  final Map<String, Map<String, CacheValue>> _cache = {};

  @override
  void clear() => _cache.clear();

  @override
  void clearContainer(String container) => _cache[container]?.clear();

  @override
  CacheValue? get(String container, String key) => _cache[container]?[key];

  @override
  Map<String, CacheValue>? getContainer(String container) => _cache[container];

  @override
  void remove(String container, String key) {
    final subcache = _cache[container];
    if (subcache == null) {
      throw KeyNotFoundException(message: 'Container $container not found');
    }
    final value = subcache.remove(key);
    if (value == null) {
      throw DeleteFailedException(message: 'Key $key not found');
    }
  }

  @override
  void set(String container, CacheValue value) {
    if (_cache[container] == null) {
      _cache[container] = {};
    }
    _cache[container]![value.key] = value;
  }

  @override
  void setContainer(String container, List<CacheValue> values) {
    _cache[container] = Map.fromEntries(values.map((e) => MapEntry(e.key, e)));
  }
}
