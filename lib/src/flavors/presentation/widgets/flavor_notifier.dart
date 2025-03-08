import 'package:flutter/widgets.dart';
import 'package:ham_framework/src/flavors/domain/enums/enums.dart';

///{@template InheritedNotifier}
/// Notifier class to manage the flavor and flag of the app.
/// It is a singleton class.
///It extends [ChangeNotifier] to notify the listeners when the flag is changed,
///you can redraw the app when the flag is changed.
///
///Also store the current app version.
///{@endtemplate}
final class FlavorNotifier extends ChangeNotifier {
  ///{@macro InheritedNotifier}
  FlavorNotifier({
    required this.version,
    required Enviroment flavor,
    required Flag flag,
  })  : _flavor = flavor,
        _flag = flag;

  final Enviroment _flavor;
  Flag _flag;

  /// The current app version.
  final String version;

  /// Get the current environment.
  Enviroment get flavor => _flavor;

  /// Get the current flag.
  Flag get flag => _flag;

  /// Change the flag of the app.
  /// It notifies the listeners to redraw the app.
  void changeFlag(Flag flag) {
    _flag = flag;
    notifyListeners();
  }
}
