import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/pages/views/edit_profile_view.dart';
import 'package:hrms/pages/views/forgot_password_view.dart';
import 'package:hrms/pages/views/home_view.dart';
import 'package:hrms/pages/views/log_in_view.dart';
import 'package:hrms/pages/views/main_screen_view.dart';
import 'package:hrms/pages/views/profile_view.dart';
import 'package:hrms/pages/views/sing_up_view.dart';
import 'package:hrms/pages/views/splash_view.dart';

class Routes {
  Map<String, Widget Function(BuildContext)> routes = {
    '/main': (context) => const MainView(),
    '/welcome': (context) => const SplashView(),
    '/login': (context) => const LoginView(),
    '/singup': (context) => const SingUpView(),
    '/main/home': (context) => const HomePage(),
    '/forgot': (context) => const ForgotView(),
    '/edit-profile': (context) => const EditProfileView(),
  };
}

final router = GoRouter(
  urlPathStrategy: UrlPathStrategy.path,
  initialLocation:
      FirebaseAuth.instance.currentUser != null ? '/main' : '/login',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/singup',
      builder: (context, state) => const SingUpView(),
    ),
    GoRoute(
      path: '/home',
      routes: [
        // GoRoute(
        //   path: 'search', // its empty and empty for now
        //   builder: (context, state) => const HomePage(),
        // ),
        // GoRoute(
        //   path:
        //       'notifications', // it can be messages too and empty for now
        //   builder: (context, state) => const HomePage(),
        // ),
      ],
      builder: (context, state) => const MainView(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileView(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileView(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainView(),
    ),
    GoRoute(
      path: '/forgot',
      builder: (context, state) => const ForgotView(),
    ),
  ],
);
