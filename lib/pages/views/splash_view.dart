import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hrms/core/themes/lib_color_schemes.g.dart';
import 'package:hrms/pages/views/log_in_view.dart';
import 'package:page_transition/page_transition.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/welcomeFirst.png',
      splashIconSize: 120,
      backgroundColor: lightColorScheme.background,
      nextScreen: const LoginView(), // fixed but not in here
      disableNavigation: false,
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
