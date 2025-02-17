import 'package:ham_framework/src/core/dependencies/base/base.dart';

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
