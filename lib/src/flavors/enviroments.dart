/// Enum to identify the environment of the app.
enum Enviroment {
  /// Development environment.
  development,

  /// Staging environment.
  staging,

  /// Production environment.
  production,
}

/// Enum to identify the flag of the app.
/// [stable] is the default value.
/// [experimental] is used to enable experimental features.
/// It can be changed at runtime.
enum Flag {
  /// Stable flag.
  stable,

  /// Experimental flag.
  /// Used to enable experimental features.
  experimental,
}
