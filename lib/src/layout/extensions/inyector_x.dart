import 'package:flutter/material.dart';
import 'package:ham_framework/src/core/core.dart';
import 'package:ham_framework/src/layout/base/base.dart';

///App Layout extenions for inyector
extension InyectorX on Inyector {
  ///Get scaffold messenger key
  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      getIt<GlobalKey<ScaffoldMessengerState>>();

  ///Get scaffold key
  GlobalKey<ScaffoldState> get scaffoldKey => getIt<GlobalKey<ScaffoldState>>();

  ///Get layout controller
  LayoutController get layoutController => get<LayoutController>();
}
