import 'package:ham/src/core/exceptions/ham_exception.dart';

///{@template inyector_key_not_found_exception}
///Thrown when the key is not found `Inyector`.
///{@endtemplate}
final class InyectorKeyNotFound extends HamException {
  ///{@macro inyector_key_not_found_exception}
  InyectorKeyNotFound({required this.message, this.stackTrace});
  @override
  final String message;

  @override
  final StackTrace? stackTrace;

  @override
  String get suggestion => 'Ensure that the key is registered first';

  @override
  String toString() => 'InyectorKeyNotFound: $message, try: $suggestion';
}

///{@template inyector_duplicate_key_exception}
///Thrown when the key already exists in `Inyector`.
///{@endtemplate}
final class InyectorDuplicateKey extends HamException {
  ///{@macro inyector_duplicate_key_exception}
  InyectorDuplicateKey({required this.message, this.stackTrace});
  @override
  final String message;

  @override
  final StackTrace? stackTrace;

  @override
  String get suggestion =>
      'Use tag to set multiple dependencies with same type';

  @override
  String toString() => 'InyectorDuplicateKey: $message, try: $suggestion';
}
