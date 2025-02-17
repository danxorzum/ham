// ignore_for_file: avoid_unnecessary_containers

import 'dart:developer';

import 'package:example/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:ham_framework/ham_framework.dart';

abstract interface class Auth {
  Stream<int> getCont();

  void setCont(int cont);
}

final class ApiTest extends StreamAPI implements Auth {
  @override
  void onBirth() async {
    log('I am born');
  }

  @override
  void onAsk() async {
    log('I am asked');
  }

  @override
  void onDie() async {
    log('I am dead');
  }

  // ApiTest();
  @override
  Mortal onReproduce() {
    return ApiTest();
  }

  @override
  Stream<int> getCont() => getStream('cont');

  @override
  void setCont(int cont) {}
}

void main() async {
  Inyector.I.add(() => ApiTest(), lazy: false, rebirth: true);
  // Inyector.I.add(
  //   () => ApiTest(),
  // );
  Inyector.I.add(() => ApiTest(), tag: 'ApiTest');
  Inyector.I.add(() => ApiTest(), tag: 'ApiTesfgsdgf');
  // await Inyector.I
  //     .addAsync(() => Future.delayed(Duration(seconds: 5), () => (ApiTest())));

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

  final router = GoRouter(initialLocation: AppRoute.home.fullPath, routes: [
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
            builder: (context, state) => Page(
              routes: routes,
              currentRoute: AppRoute.profile,
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
    return MaterialApp.router(
      title: 'Eco Chillers Core Example',
      routerConfig: router,
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key, required this.routes, required this.currentRoute});

  final List<AppRoute> routes;
  final AppRoute currentRoute;

  @override
  Widget build(BuildContext context) {
    // final card = ButtonCard(
    //   title: 'AquaCool Dynamics',
    //   isSelected: true,
    //   onPressed: () {},
    //   footer: 'Created: ${DateFormat.yMMMd().format(DateTime.now())} ',
    //   key: Key('card'),
    // );

    return HomeLayout(
      currentRoute: currentRoute,
      routes: routes,
      body: Center(child: SizedBox.expand()),
      bodymedium: LayoutViewContainer(child: Text('Medium primary')),
      bodyexpanded: LayoutViewContainer(child: Text('Expanded primary')),
      bodylarge: LayoutViewContainer(child: Text('Large primary')),
      secondaryMediumBody: LayoutViewContainer(child: Text('medium Secondary')),
      secondaryExtralargeBody: LayoutViewContainer(
          child: Column(
        children: [
          Text('label small', style: context.textTheme.labelSmall),
          Text('label medium', style: context.textTheme.labelMedium),
          Text('label large', style: context.textTheme.labelLarge),
          Text('body small', style: context.textTheme.bodySmall),
          Text('body medium', style: context.textTheme.bodyMedium),
          Text('body large', style: context.textTheme.bodyLarge),
          Text('title small', style: context.textTheme.titleSmall),
          Text('title medium', style: context.textTheme.titleMedium),
          Text('title large', style: context.textTheme.titleLarge),
          Text('display small', style: context.textTheme.displaySmall),
          Text('display medium', style: context.textTheme.displayMedium),
          Text('display large', style: context.textTheme.displayLarge),
          Text('headline small', style: context.textTheme.headlineSmall),
          Text('headline medium', style: context.textTheme.headlineMedium),
          Text('headline large', style: context.textTheme.headlineLarge),
        ],
      )),
      secondaryExpandedBody:
          LayoutViewContainer(child: Text(' Expanded Secondary')),
      secondaryLargeBody: LayoutViewContainer(child: Text(' Large Secondary')),
      layoutController: controller,
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton.extended(
            onPressed: () {},
            label: Text('New Request'),
            icon: Icon(Icons.add));
      }),
    );
  }
}
