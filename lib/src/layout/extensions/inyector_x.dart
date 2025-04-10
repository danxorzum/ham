import 'package:flutter/material.dart';
import 'package:ham/src/core/core.dart';
import 'package:ham/src/layout/layout_controller.dart';

///App Layout extenions for inyector
extension InyectorX on Inyector {
  ///Get scaffold messenger key
  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      Inyector.get<GlobalKey<ScaffoldMessengerState>>();

  ///Get scaffold key
  GlobalKey<ScaffoldState> get scaffoldKey =>
      Inyector.get<GlobalKey<ScaffoldState>>();

  ///Get layout controller
  LayoutController get layoutController => Inyector.get<LayoutController>();
}
