// ignore_for_file: avoid_unnecessary_containers
import 'dart:async';
import 'dart:developer';

import 'package:example/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:ham/ham.dart';

final class BS extends Bootstrap {
  @override
  Future<void> bootstrap() {
    // WidgetsFlutterBinding.ensureInitialized();
    return Future.value();
  }

  @override
  void logger(Object object, StackTrace stackTrace) {
    log('Caraja madre no funciona esta chingadera',
        error: object, stackTrace: stackTrace, name: 'BS');
  }

  @override
  Future<void> loadLogger() {
    return Future.value();
  }
}

void main() async {
  // await runZonedGuarded(() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   runApp(MyApp());
  // }, BS().logger);
  await runHamApp(
    app: MyApp(),
    enviroment: Enviroment.development,
    flag: Flag.stable,
    bootstrap: BS(),
    appVersion: '1.0.0',
  );
}

final routes = [
  HomeRoute(),
  LoginRoute(),
  ProfileRoute(),
];

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final router = GoRouter(initialLocation: AppRoute.home.path, routes: [
    // final router = GoRouter(initialLocation: AppRoute.profile.fullPath, routes: [
    GoRoute(
      path: AppRoute.home.path,
      // pa
      pageBuilder: (context, state) {
        return MaterialPage(
          child: AuthLayout(),
        );
      },
      name: AppRoute.home.name,
      // routes: [
      //   GoRoute(
      //     path: AppRoute.profile.path,
      //     builder: (context, state) =>
      //         // NavlessLayout(
      //         // key: const Key('profile'),
      //         // body:
      //         Page(
      //       routes: routes,
      //       currentRoute: AppRoute.profile,
      //     ),
      //     // ),
      //     // name: AppRoute.profile.name,
      //   ),
      // ]
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return HamApp(
      version: '1.0.0',
      flavor: Enviroment.development,
      flag: Flag.stable,
      router: router,
      title: 'Eco Chillers Core Example',
    );
  }
}

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Auth Layout'),
      ),
    );
    return NavlessLayout(
        key: const Key('home'),
        body: Page(
          routes: routes,
          currentRoute: AppRoute.home,
        ));
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

class Page extends StatelessWidget {
  const Page({super.key, required this.routes, required this.currentRoute});

  final List<AppRoute> routes;
  final AppRoute currentRoute;

  @override
  Widget build(BuildContext context) {
    final layCont = context.layoutController;
    return AuthBody(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentRoute.name),
            MaterialButton(
              onPressed: () {
                Inyector.I.scaffoldMessengerKey.currentState
                    ?.showSnackBar(SnackBar(content: Text('Picale')));
              },
              child: Text('Picale'),
            )
          ],
        )),
        secondaryBody: Center(child: Icon(Icons.telegram, size: 100)));
  }
}
