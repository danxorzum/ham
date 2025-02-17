import 'package:flutter/material.dart';
import 'package:ham_framework/ham_framework.dart';

sealed class AppRoute extends NavigationRoute {
  AppRoute(
      {required super.name,
      required super.path,
      required super.fullPath,
      required super.labelName,
      required super.icon});

  static AppRoute get home => HomeRoute();
  static AppRoute get login => LoginRoute();
  static AppRoute get profile => ProfileRoute();
}

class HomeRoute extends AppRoute {
  HomeRoute()
      : super(
            name: 'home',
            path: '/',
            fullPath: '/',
            labelName: 'Home',
            icon: Icon(Icons.home));
}

class ProfileRoute extends AppRoute {
  ProfileRoute()
      : super(
            name: 'profile',
            path: 'profile',
            fullPath: '/profile',
            labelName: 'Profile',
            icon: Icon(Icons.person));
}

class LoginRoute extends AppRoute {
  LoginRoute()
      : super(
            name: 'login',
            path: '/login',
            fullPath: '/login',
            labelName: 'Login',
            icon: Icon(Icons.login));
}
