import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hrms/core/managers/route_manager.dart';
import 'package:hrms/core/themes/dark_theme.dart';
import 'package:hrms/core/themes/light_theme.dart';
import 'package:hrms/firebase_options.dart';
import 'package:page_transition/page_transition.dart';

import 'core/themes/lib_color_schemes.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('themeData');
  runApp(const Hrms());
}

class Hrms extends StatelessWidget {
  const Hrms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('themeData').listenable(),
      builder: (_, currentMode, box) {
        var darkMode =
            Hive.box('themeData').get('darkmode', defaultValue: false);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AnimatedSplashScreen(
            splash: 'assets/images/welcomeFirst.png',
            splashIconSize: 120,
            splashTransition: SplashTransition.slideTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: lightColorScheme.background,
            nextScreen: MaterialApp.router(
              themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
              title: 'HRMS',
              theme: LightTheme().theme,
              darkTheme: DarkTheme().theme,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
            ),
          ),
        );
      },
    );
  }
}
