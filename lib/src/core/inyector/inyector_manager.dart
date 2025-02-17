///{@template inyector_manager}
///[InyectorManager] manages the inyerctor dependencies.
///{@endtemplate}
final class InyectorManager {
  final _dependencies = <String, dynamic>{};

  ///Save a dependency in memory.
  void add<T>({required T dependency, required String key}) {
    final oldValue = _dependencies[key];

    if (oldValue != null) {
      throw Exception(
        ///{@template line_longer}
        /// Igonere lines_longer_than_80_chars becouse of the message has to be
        /// long.
        /// {@endtemplate}
        // ignore: lines_longer_than_80_chars
        'Key $key already exists, if you want to set multiple dependencies with same type, use different keys',
      );
    }
    _dependencies[key] = dependency;
  }

  ///delete a dependency from memory and return it.
  T remove<T>({required String key}) {
    final value = _dependencies.remove(key);

    if (value == null) {
      throw Exception(
        'Key $key not found. Register the dependency first before using it.',
      );
    }

    return value as T;
  }

  ///Replace a dependency in memory and return the old one.
  ///
  ///On;y call this method if you want to replace a dependency. should be
  ///managed by reproduce flag.
  T replace<T>({required T dependency, required String key}) {
    final oldDependency = _dependencies[key];
    if (oldDependency == null) {
      throw Exception(
        'Key $key not found. Register the dependency first before using it.',
      );
    }
    _dependencies[key] = dependency;
    return oldDependency as T;
  }

  ///Get a dependency from memory.
  T get<T>({required String key}) {
    final value = _dependencies[key];
    if (value == null) {
      throw Exception(
        'Key $key not found. Register the dependency first before using it.',
      );
    }
    return value as T;
  }

  ///Say if a key exists in memory.
  bool exists(String key) => _dependencies.containsKey(key);

  ///Clear all dependencies from memory.
  void clear() => _dependencies.clear();

  ///Get all dependencies from memory.
  Map<String, dynamic> getDependencies() => _dependencies;
}
