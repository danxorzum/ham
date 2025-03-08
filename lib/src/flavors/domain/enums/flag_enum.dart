/// Enum to identify the flag of the app.
/// [stable] is the default value.
/// [experimental] is used to enable experimental features.
/// It can be changed at runtime.
enum Flag {
  /// Stable flag.
  stable,

  /// Experimental flag.
  /// Used to enable experimental features. Users can change this flag at
  /// runtime. Never change this flag automatically. Only users cah cange.
  experimental,

  /// remote flag.
  /// Used to enable features from a remote source like a server.
  ///
  /// remoteFeature work as stable plus new features from a remote source.
  /// Use it in Continuous Development and continuous integration to enable or
  /// disable features from a remote source.
  ///
  /// [remoteFeature] can't active experimental features.
  remoteFeature,
}
