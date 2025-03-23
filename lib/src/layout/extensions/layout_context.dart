import 'package:flutter/material.dart';
import 'package:ham/src/layout/base/base.dart';

extension LayoutContext on BuildContext {
  ///Get layout controller
  LayoutController get layoutController => InheritedController.of(this);
}
