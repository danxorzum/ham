import 'package:ham_framework/src/core/core.dart';

///Base class for cache exceptions in `HamFramework`
abstract base class HamCacheException implements HamException {}

///{@template container_not_found_exception}
///Thrown when a container is not found in the cache
///{@endtemplate}
final class KeyNotFoundException extends HamCacheException {
  ///{@macro container_not_found_exception}
  KeyNotFoundException({required this.message, this.stackTrace});

  @override
  final String message;

  @override
  final StackTrace? stackTrace;
}

///{@template delete_failed_exception}
///Thrown when deleting a key failed
///{@endtemplate}
final class DeleteFailedException extends HamCacheException {
  ///{@macro delete_failed_exception}
  DeleteFailedException({required this.message, this.stackTrace});

  @override
  final String message;

  @override
  final StackTrace? stackTrace;
}
