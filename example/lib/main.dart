// ignore_for_file: avoid_unnecessary_containers
import 'package:example/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:ham_framework/ham_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

final LayoutController controller =
    LayoutController(bodyRatio: 0.3, secondaryBodyRatio: 0.3);

final routes = [
  HomeRoute(),
  LoginRoute(),
  ProfileRoute(),
  HomeRoute(),
  LoginRoute(),
  LoginRoute(),
  HomeRoute(),
  LoginRoute(),
  LoginRoute(),
];

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final router = GoRouter(initialLocation: AppRoute.profile.fullPath, routes: [
    GoRoute(
        path: AppRoute.home.path,
        // pa
        builder: (context, state) => Page(
              routes: routes,
              currentRoute: AppRoute.home,
            ),
        name: AppRoute.home.name,
        routes: [
          GoRoute(
            path: AppRoute.profile.path,
            builder: (context, state) => NavlessLayout(
              body: Page(
                routes: routes,
                currentRoute: AppRoute.profile,
              ),
            ),
            name: AppRoute.profile.name,
          ),
        ]),
    GoRoute(
      path: AppRoute.login.path,
      builder: (context, state) => Page(
        routes: routes,
        currentRoute: AppRoute.login,
      ),
      name: AppRoute.login.name,
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

class Page extends StatelessWidget {
  const Page({super.key, required this.routes, required this.currentRoute});

  final List<AppRoute> routes;
  final AppRoute currentRoute;

  @override
  Widget build(BuildContext context) {
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
