import 'package:ham_framework/src/cache/domain/domain.dart';
import 'package:hive/hive.dart';

/// {@template hive_adapter}
/// Hive Adapter to manage the cache of the app.
/// {@endtemplate}
final class HiveAdapter implements CacheRepository {
  @override
  void clear() => Hive.deleteAllBoxesFromDisk();

  @override
  void clearContainer(String container) =>
      Hive.box<CacheValue>(name: container, encryptionKey: container).clear();

  @override
  CacheValue? get(String container, String key) =>
      Hive.box<CacheValue>(name: container, encryptionKey: container).get(key);

  @override
  Map<String, CacheValue>? getContainer(String container) {
    final box = Hive.box<CacheValue>(name: container, encryptionKey: container);
    final values = box.getAll(box.keys);
    final noNullValues = List<CacheValue>.from(values.where((e) => e != null));
    if (noNullValues.isEmpty) {
      return null;
    }
    return Map.fromEntries(noNullValues.map((e) => MapEntry(e.key, e)));
  }

  @override
  void remove(String container, String key) {
    final wasRemoved = Hive.box<CacheValue>(
      name: container,
      encryptionKey: container,
    ).delete(key);
    if (!wasRemoved) {
      throw DeleteFailedException(message: 'Key $key not found');
    }
  }

  @override
  void set(String container, CacheValue value) => Hive.box<CacheValue>(
    name: container,
    encryptionKey: container,
  ).put(value.key, value);

  @override
  void setContainer(String container, List<CacheValue> values) =>
      Hive.box<CacheValue>(
        name: container,
        encryptionKey: container,
      ).putAll(Map.fromEntries(values.map((e) => MapEntry(e.key, e))));
}
