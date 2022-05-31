import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/pages/views/auth/forgot_password_view.dart';
import 'package:hrms/pages/views/auth/log_in_view.dart';
import 'package:hrms/pages/views/auth/phone_log_in_view.dart';
import 'package:hrms/pages/views/auth/sing_up_view.dart';
import 'package:hrms/pages/views/loading.dart';
import 'package:hrms/pages/views/main_screen_view.dart';
import 'package:hrms/pages/views/profile/applied_forms.dart';
import 'package:hrms/pages/views/profile/edit_profile_view.dart';
import 'package:hrms/pages/views/profile/favorites_view.dart';
import 'package:hrms/pages/views/profile/profile_view.dart';
import 'package:hrms/pages/views/profile/settings.dart';
import 'package:hrms/pages/views/splash_view.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoadingPage(),
      redirect: (_) =>
          FirebaseAuth.instance.currentUser != null ? '/home' : '/login',
    ),
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => MaterialPage<void>(
        child: const SplashScreen(),
        key: state.pageKey,
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const SingUpView(),
    ),
    GoRoute(
      path: '/home',
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
      path: '/forgotPassword',
      builder: (context, state) => const ForgotView(),
    ),
    GoRoute(
      path: '/phoneLogin',
      builder: (context, state) => const PhoneLoginView(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesView(),
    ),
    GoRoute(
      path: '/applied-jobs',
      builder: (context, state) => const AppliedsView(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsView(),
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage<void>(
    key: state.pageKey,
    child: Scaffold(
      body: Center(
        child: Text(
          state.error.toString(),
        ),
      ),
    ),
  ),
  // redirect: (state) {
  //   // if the user is not logged in, they need to login
  //   final loggedIn = FirebaseAuth.instance.currentUser != null;
  //   final urlLoggingIn = state.subloc == '/login';
  //   final urlRegister = state.subloc == '/register';
  //   final urlForgotPass = state.subloc == '/forgotPassword';

  //   if (urlLoggingIn && loggedIn) return '/home';
  //   if (!urlLoggingIn && !loggedIn && !urlRegister && !urlForgotPass) {
  //     return '/';
  //   }

  //   return null;
  // },
  // // refreshListenable: ,
);
