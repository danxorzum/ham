import 'package:ham/src/core/core.dart';

///Base class for services.
abstract base class Service
    with StreamerDependency, ListenDependencies
    implements Mortal {
  @override
  void onAsk() {}

  @override
  void onDie() {
    disposeStreams();
    disposeListeners();
  }
}
