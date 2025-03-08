// ignore_for_file: avoid_unnecessary_containers
import 'package:example/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:ham_framework/ham_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
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
        routes: [
          GoRoute(
            path: AppRoute.profile.path,
            builder: (context, state) =>
                // NavlessLayout(
                // key: const Key('profile'),
                // body:
                Page(
              routes: routes,
              currentRoute: AppRoute.profile,
            ),
            // ),
            // name: AppRoute.profile.name,
          ),
        ]),
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
