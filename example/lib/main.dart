// ignore_for_file: avoid_unnecessary_containers
import 'dart:async';

import 'package:example/presentation/layouts/test_layout.dart';
import 'package:example/presentation/test/bodies/test_body.dart';
import 'package:flutter/material.dart';
import 'package:ham/ham.dart';

final class BS extends Bootstrap {
  @override
  Future<void> bootstrap(Enviroment enviroment) async {
    return Future.value();
  }

  @override
  void logger(Object object, StackTrace stackTrace) {}

  @override
  Future<void> loadLogger(Enviroment enviroment) async {
    return Future.value();
  }
}

void main() async {
  await runHamApp(
    app: () => MyApp(),
    enviroment: Enviroment.development,
    flag: Flag.stable,
    bootstraper: () => BS(),
    appVersion: '1.0.0',
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final router = GoRouter(initialLocation: '/', routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return MaterialPage(
          child: TestLayout(
            body: TestBody(),
          ),
        );
      },
      name: 'home',
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return HamApp(
      router: router,
      title: 'Eco Chillers Core Example',
    );
  }
}

class PushView extends StatelessWidget {
  const PushView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Push View'),
    );
  }
}
