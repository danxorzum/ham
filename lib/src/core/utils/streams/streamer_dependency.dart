import 'dart:async';

import 'package:ham/src/core/utils/strings_utils.dart';

///{@template StreamerDependency}
/// A mixin that provides StreamControllerers and handles from key.
/// {@endtemplate}
mixin StreamerDependency {
  final Map<String, StreamController<dynamic>> _streamControllers = {};

  ///Get a Stream for a given key.
  Stream<S> getStream<S>(String tag) {
    final key = nameTagFromType(S, tag);
    assert(
      _streamControllers.containsKey(key),
      'Stream not found for key: $key',
    );
    return _streamControllers[key]!.stream as Stream<S>;
  }

  ///Emit a value for a given key.
  void emit<S>(String tag, S value) {
    final key = nameTagFromType(S, tag);
    assert(
      _streamControllers.containsKey(key),
      'Stream not found for key: $key',
    );
    _streamControllers[key]!.add(value);
  }

  ///Emit error for a given key.
  void emitError<S>(String tag, Object error, [StackTrace? stackTrace]) {
    final key = nameTagFromType(S, tag);
    assert(
      _streamControllers.containsKey(key),
      'Stream not found for key: $key',
    );
    _streamControllers[key]!.addError(error, stackTrace);
  }

  ///Register a StreamController for a given key.
  void registerStream<S>(
    String tag, {
    void Function()? onListen,
    FutureOr<void> Function()? onCancel,
    void Function()? onPause,
    void Function()? onResume,
    bool asBroadcastStream = false,
    bool sync = false,
  }) {
    final key = nameTagFromType(S, tag);
    assert(
      !asBroadcastStream || (onPause == null && onResume == null),
      'onPause and onResume must be null when asBroadcastStream is true',
    );

    assert(
      !_streamControllers.containsKey(key),
      'Stream already registered for key: $key',
    );
    if (asBroadcastStream) {
      _streamControllers[key] = StreamController<S>.broadcast(
        onListen: onListen,
        onCancel: onCancel,
        sync: sync,
      );
    } else {
      _streamControllers[key] = StreamController<S>(
        onListen: onListen,
        onCancel: onCancel,
        onPause: onPause,
        onResume: onResume,
        sync: sync,
      );
    }
  }

  ///Dispose all the resources.
  void disposeStreams() {
    for (final streamController in _streamControllers.values) {
      streamController.close();
    }
    _streamControllers.clear();
  }
}
