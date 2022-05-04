import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/bottom_screens/home_page.dart';
import 'package:hrms/firebase_options.dart';
import 'package:hrms/static_storage/firebase.dart';
import 'package:hrms/views/forgot_password_view.dart';
import 'package:hrms/views/log_in_view.dart';
import 'package:hrms/views/main_screen_view.dart';
import 'package:hrms/views/sing_up_view.dart';
import 'package:hrms/views/welcome_screen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRMS',
      theme: ThemeData.dark().copyWith(
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 229, 233, 240),
            ),
          ),
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Ubuntu',
            ),
        dialogTheme: _customDialog(),
        scaffoldBackgroundColor: const Color.fromARGB(255, 46, 52, 64),
        appBarTheme: _custimizedAppBar(),
        elevatedButtonTheme: _customizedElevatedButton(),
        progressIndicatorTheme: _customizedProgressIndicator(),
        inputDecorationTheme: _customizedInputDecoration(),
        bottomNavigationBarTheme: _customizedBottomNavBar(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // useMaterial3: true, //Waiting for release material desing 3 for flutter
      ),
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
  }

  DialogTheme _customDialog() {
    return DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
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

  ProgressIndicatorThemeData _customizedProgressIndicator() => const ProgressIndicatorThemeData(
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
        borderRadius: BorderRadius.circular(20),
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
        overlayColor: MaterialStateProperty.all(
          Colors.green,
        ),
        fixedSize: MaterialStateProperty.all(
          const Size(125, 40),
        ),
        side: MaterialStateProperty.all(
          const BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        visualDensity: VisualDensity.compact,
        backgroundColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 94, 129, 172),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
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
