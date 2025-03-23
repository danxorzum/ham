import 'package:ham/src/core/core.dart';
import 'package:ham/src/dependencies/repositories/repository.dart';

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
