import 'package:flutter/material.dart';
import 'package:ham/ham.dart';

final class TestLayout extends Layout {
  const TestLayout({super.key, required super.body});

  @override
  AdaptivePreferredSizeBuilder get topNav => (context, size) => TestAppbar();
}
















final class TestAppbar extends StatelessWidget implements PreferredSizeWidget {
  const TestAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}
