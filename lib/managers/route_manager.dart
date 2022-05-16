import 'package:flutter/material.dart';
import 'package:hrms/bottom_screens/home_view.dart';
import 'package:hrms/views/forgot_password_view.dart';
import 'package:hrms/views/log_in_view.dart';
import 'package:hrms/views/main_screen_view.dart';
import 'package:hrms/views/sing_up_view.dart';
import 'package:hrms/views/welcome_screen_view.dart';

class Routes {
  Map<String, Widget Function(BuildContext)> routes = {
    '/main': (context) => const MainView(),
    '/welcome': (context) => const WelcomeView(),
    '/login': (context) => const LoginView(),
    '/singup': (context) => const SingUpView(),
    '/main/home': (context) => const HomePage(),
    '/forgot': (context) => const ForgotView(),
  };
}
