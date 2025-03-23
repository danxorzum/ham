import 'dart:async';

import 'package:ham/src/core/utils/strings_utils.dart';

/// A mixin that provide a class to subscribe to multiple streams.
/// It also provides methods to register and handle the resources.
mixin class ListenDependencies {
  final Map<String, StreamSubscription<dynamic>> _subscriptions = {};

  ///Get a StreamSubscription for a given key.
  StreamSubscription<S> getStreamSubscription<S>(String tag) {
    final key = nameTagFromType(S, tag);
    assert(_subscriptions.containsKey(key), 'Stream not found for key: $key');
    return _subscriptions[key]! as StreamSubscription<S>;
  }

  ///Register a StreamSubscription for a given key.
  void suscribe<S>({
    required String tag,
    required Stream<S> stream,
    void Function(S)? callback,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final key = nameTagFromType(S, tag);
    assert(
      !_subscriptions.containsKey(key),
      'Stream already registered for key: $key',
    );
    _subscriptions[key] = stream.listen(
      callback,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  ///Dispose all the resources.
  void disposeListeners() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}
