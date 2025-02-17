import 'package:ham_framework/src/core/dependencies/base/base.dart';
import 'package:ham_framework/src/core/dependencies/repositories/repository.dart';

/// {@template stream_repository}
/// Repository base class for repositories that use streams.
/// {@endtemplate}
abstract base class StreamRepository extends Repository
    with ListenDependencies, StreamerDependency {
  @override
  void onDie() {
    disposeStreams();
    disposeListeners();
    super.onDie();
  }
}
