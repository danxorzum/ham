import 'package:ham_framework/src/core/dependencies/apis/api.dart';
import 'package:ham_framework/src/core/dependencies/base/base.dart';

/// {@template stream_api}
/// StreamAPI base class.
///
/// Use when you need to use streams in your API. like sockets or symply
///to comunacte data from streams.
///
/// Stream methods avilable:
///
/// - registerStream: register a StreamController for a given key.
/// - getStream: get a Stream for a given key.
/// - emit: emit a value for a given key.
/// - emitError: emit an error for a given key.
///
/// If manage your dependencies wiht `Inyector` Don't worry about closing
/// StreamControllers, they will be closed in `onDie` method.
///
/// If you are not using `Inyector` you need to cal onDie method manually.
/// {@endtemplate}
abstract base class StreamAPI extends API with StreamerDependency {
  @override
  void onDie() {
    disposeStreams();
  }

  @override
  void onAsk();
}
