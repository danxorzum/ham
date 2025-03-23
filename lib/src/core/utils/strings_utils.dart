/// Creates a name tag based on type and key.
String nameTagFromType(Type type, String key) =>
    '$type${key.isNotEmpty ? '_$key' : ''}';
