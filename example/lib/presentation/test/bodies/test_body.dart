import 'package:flutter/material.dart';
import 'package:ham/ham.dart';

final class TestBody extends Body {
  @override
  AdaptiveBuilder get bodyBuilder => (context, size) => Center(
        child: Text('Test Body'),
      );
}
