import 'package:flutter/material.dart';
import 'package:ham_framework/src/layout/base/base.dart';

extension LayoutContext on BuildContext {
  ///Get layout controller
  LayoutController get layoutController => InheritedController.of(this);
}
