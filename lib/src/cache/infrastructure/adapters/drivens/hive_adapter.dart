import 'package:ham/src/cache/domain/domain.dart';
import 'package:ham/src/cache/infrastructure/models/cache_value_hive.dart';
import 'package:hive/hive.dart';

/// {@template hive_adapter}
/// Hive Adapter to manage the cache of the app.
/// {@endtemplate}
final class HiveAdapter implements CacheRepository {
  /// {@macro hive_adapter}
  HiveAdapter({required this.cacheContainer});

  ///Default container for internal things.
  final String cacheContainer;

  void _registerContainerKey(String container) =>
      Hive.box<String>(cacheContainer).put(container, container);

  List<String> _getContainersKeys() {
    final box = Hive.box<String>(cacheContainer);
    final keys = box.toMap();
    return keys.values.toList();
  }

  CacheValue _fromHiveCacheValue(CacheValueHive value) => CacheValue(
    key: value.cacheKey,
    value: value.value,
    expirationDate: value.expirationDate,
  );

  CacheValueHive _toHiveCacheValue(CacheValue value) => CacheValueHive(
    cacheKey: value.key,
    value: value.value,
    expirationDate: value.expirationDate,
  );

  @override
  void clear() {
    for (final container in _getContainersKeys()) {
      clearContainer(container);
    }
    Hive.box<String>(cacheContainer).clear();
  }

  @override
  void clearContainer(String container) =>
      Hive.box<CacheValueHive>(container).clear();

  @override
  Future<CacheValue?> get(String container, String key) async {
    late final Box<CacheValueHive> box;

    if (Hive.isBoxOpen(container)) {
      box = Hive.box<CacheValueHive>(container);
    } else {
      box = await Hive.openBox<CacheValueHive>(container);
    }
    final result = box.get(key);
    if (result == null) return null;
    return _fromHiveCacheValue(result);
  }

  @override
  Map<String, CacheValue> getContainer(String container) {
    final box = Hive.box<CacheValueHive>(container);
    final values = box.toMap();
    final stringKeyMap = values.map(
      (key, value) => MapEntry(key as String, value),
    );
    final cacheValueMap = stringKeyMap.map(
      (key, value) => MapEntry(key, _fromHiveCacheValue(value)),
    );
    return cacheValueMap;
  }

  @override
  void remove(String container, String key) =>
      Hive.box<CacheValueHive>(container).delete(key);

  @override
  Future<void> set(String container, CacheValue value) async {
    late final Box<CacheValueHive> box;
    if (await Hive.boxExists(container)) {
      box = Hive.box<CacheValueHive>(container);
    } else {
      box = await Hive.openBox<CacheValueHive>(container);
      _registerContainerKey(container);
    }
    await box.put(value.key, _toHiveCacheValue(value));
  }

  @override
  Future<void> setContainer(String container, List<CacheValue> values) async {
    if (await Hive.boxExists(container) == false) {
      await Hive.openBox<CacheValueHive>(container);
      _registerContainerKey(container);
    }
    await Hive.box<CacheValueHive>(container).putAll(
      Map.fromEntries(values.map((e) => MapEntry(e.key, _toHiveCacheValue(e)))),
    );
  }
}
