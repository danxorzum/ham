import 'package:ham_framework/src/core/dependencies/base/mortal.dart';

///{@template ham_api}
/// API base class.
///
/// Implement [Mortal] life cycle.
/// {@endtemplate}

abstract base class API implements Mortal {
  @override
  void onAsk() {}

  @override
  void onBirth() {}

  @override
  void onDie() {}
}
