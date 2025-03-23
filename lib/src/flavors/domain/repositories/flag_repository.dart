import 'package:ham/src/flavors/domain/enums/enums.dart';

///{@template FlagRepository}
/// Repository to manage the flag of the app.
/// {@endtemplate}
abstract interface class FlagRepository {
  ///Get the flag of the app.
  Flag getFlag();

  ///Change the flag of the app.
  void changeFlag(Flag flag);
}
