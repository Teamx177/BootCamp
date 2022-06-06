import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hireme/pages/views/auth/forgot_password_view.dart';
import 'package:hireme/pages/views/auth/log_in_view.dart';
import 'package:hireme/pages/views/auth/phone_log_in_view.dart';
import 'package:hireme/pages/views/auth/sing_up_view.dart';
import 'package:hireme/pages/views/details_view.dart';
import 'package:hireme/pages/views/loading.dart';
import 'package:hireme/pages/views/main_screen_view.dart';
import 'package:hireme/pages/views/profile/applied_forms.dart';
import 'package:hireme/pages/views/profile/edit_profile_view.dart';
import 'package:hireme/pages/views/profile/favorites_view.dart';
import 'package:hireme/pages/views/profile/incoming_applications_view.dart';
import 'package:hireme/pages/views/profile/profile_view.dart';
import 'package:hireme/pages/views/search_view.dart';
import 'package:hireme/pages/views/splash_view.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoadingPage(),
      redirect: (_) => FirebaseAuth.instance.currentUser != null ? '/home' : '/login',
    ),
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => const MaterialPage<void>(
        child: SplashScreen(),
      ),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => const MaterialPage<void>(
        child: LoginView(),
      ),
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
      path: '/search',
      builder: (context, state) => const SearchView(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) {
        return const DetailsView();
      },
    ),
    GoRoute(
      path: '/incoming-applications',
      builder: (context, state) {
        return const IncomingApplicationsView();
      },
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage<void>(
    child: Scaffold(
      body: Center(
        child: Text(
          state.error.toString(),
        ),
      ),
    ),
  ),
);
