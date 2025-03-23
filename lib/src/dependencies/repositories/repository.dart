import 'package:ham/src/core/core.dart';

/// {@template eco_repository}
/// Repository for eco_chillers API.
///
/// Implement [Mortal] life cycle.
/// {@endtemplate}
abstract base class Repository implements Mortal {
  @override
  void onAsk() {}

  @override
  void onBirth() {}

  @override
  void onDie() {}
}
