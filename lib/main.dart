import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hrms/firebase_options.dart';
import 'package:hrms/static_storage/firebase.dart';
import 'package:hrms/themes/lib_color_schemes.g.dart';
import 'package:hrms/themes/light_theme.dart';
import 'package:hrms/views/forgot_password_view.dart';
import 'package:hrms/views/log_in_view.dart';
import 'package:hrms/views/main_screen_view.dart';
import 'package:hrms/views/sing_up_view.dart';
import 'package:hrms/views/welcome_screen_view.dart';

import 'bottom_screens/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  runApp(const Hrms());
}

class Hrms extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  const Hrms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, box) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: currentMode,
            title: 'HRMS',
            theme: ThemeData.light().copyWith(
              scaffoldBackgroundColor: lightColorScheme.background,
              appBarTheme: LightTheme().theme.appBarTheme,
              elevatedButtonTheme: _customizedElevatedButtonLight(),
              progressIndicatorTheme: _customizedProgressIndicatorLight(),
              inputDecorationTheme: _customizedInputDecoration(),
              bottomNavigationBarTheme: LightTheme().theme.bottomNavigationBarTheme,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              useMaterial3: true,
              colorScheme: lightColorScheme,
            ),
            darkTheme: ThemeData.dark().copyWith(
              dialogTheme: _customDialog(),
              scaffoldBackgroundColor: darkColorScheme.background,
              appBarTheme: _custimizedAppBar(),
              elevatedButtonTheme: _customizedElevatedButtonLight(),
              progressIndicatorTheme: _customizedProgressIndicator(),
              inputDecorationTheme: _customizedInputDecoration(),
              bottomNavigationBarTheme: _customizedBottomNavBar(),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              useMaterial3: true,
              colorScheme: darkColorScheme,
            ),
            // Created routes management is in here
            // initialroute made if users logged in starts with home page
            initialRoute: user != null ? '/main' : '/welcome',
            routes: {
              '/main': (context) => const MainView(),
              '/welcome': (context) => const WelcomeView(),
              '/login': (context) => const LoginView(),
              '/singup': (context) => const SingUpView(),
              '/main/home': (context) => const HomePage(),
              '/forgot': (context) => const ForgotView(),
            },
          );
        });
  }

  DialogTheme _customDialog() {
    return DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  BottomNavigationBarThemeData _customizedBottomNavBar() {
    return const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
    );
  }

  ProgressIndicatorThemeData _customizedProgressIndicator() =>
      const ProgressIndicatorThemeData(
        color: Colors.white,
      );

  InputDecorationTheme _customizedInputDecoration() {
    return InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      errorStyle: const TextStyle(
        color: Colors.red,
        height: 0.7,
        overflow: TextOverflow.ellipsis,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 1,
        ),
      ),
      floatingLabelAlignment: FloatingLabelAlignment.start,
      iconColor: Colors.white,
      isDense: true,
      isCollapsed: true,
      filled: true,
      fillColor: Colors.blueGrey,
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
    );
  }

  ElevatedButtonThemeData _customizedElevatedButton() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        // overlayColor: MaterialStateProperty.all(
        // Colors.green,
        // ),
        fixedSize: MaterialStateProperty.all(
          const Size(125, 40),
        ),
        // side: MaterialStateProperty.all(
        // const BorderSide(
        // color: Color.fromARGB(255, 142, 153, 176),
        // width: 0,
        // ),
        // ),
        visualDensity: VisualDensity.standard,
        // backgroundColor: MaterialStateProperty.all(
        // const Color.fromARGB(255, 94, 129, 172),
        // ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  AppBarTheme _custimizedAppBar() {
    return const AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}

BottomNavigationBarThemeData _customizedBottomNavBarLight() {
  return const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white,
  );
}

ProgressIndicatorThemeData _customizedProgressIndicatorLight() =>
    const ProgressIndicatorThemeData(
      color: Colors.white,
    );

AppBarTheme _custimizedAppBarLight() {
  return const AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    color: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
  );
}

ElevatedButtonThemeData _customizedElevatedButtonLight() {
  return ElevatedButtonThemeData(
    style: ButtonStyle(
      // overlayColor: MaterialStateProperty.all(
      // Colors.green,
      // ),
      fixedSize: MaterialStateProperty.all(
        const Size(125, 40),
      ),
      // side: MaterialStateProperty.all(
      // const BorderSide(
      // color: Color.fromARGB(255, 142, 153, 176),
      // width: 0,
      // ),
      // ),
      visualDensity: VisualDensity.standard,
      // backgroundColor: MaterialStateProperty.all(
      // const Color.fromARGB(255, 94, 129, 172),
      // ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  );
}
