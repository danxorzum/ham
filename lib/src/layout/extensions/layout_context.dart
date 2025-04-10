import 'package:flutter/material.dart';
import 'package:ham/src/layout/components/inherited/inherited_controller.dart';
import 'package:ham/src/layout/layout_controller.dart';

extension LayoutContext on BuildContext {
  ///Get layout controller
  LayoutController get layoutController => InheritedController.of(this);
}
