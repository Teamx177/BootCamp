import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/firebase_options.dart';
import 'package:hrms/screens/welcome_screen.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
          textTheme: ThemeData.dark().textTheme.apply(
                fontFamily: 'Ubuntu',
              ),
          primaryColor: const Color.fromARGB(255, 59, 66, 82),
          scaffoldBackgroundColor: const Color.fromARGB(255, 59, 66, 82),
          appBarTheme: _custimizedAppBar(),
          elevatedButtonTheme: _customizedElevatedButton(),
          progressIndicatorTheme: _customizedProgressIndicator(),
          inputDecorationTheme: _customizedInputDecoration(),
          bottomNavigationBarTheme: _customizedBottomNavBar(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color.fromARGB(255, 59, 66, 82))

          // useMaterial3: true, //Waiting for release material desing 3 for flutter
          ),
      home: const WelcomePage(),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(20),
      ),
      errorStyle: const TextStyle(
          color: Colors.red, height: 0.7, overflow: TextOverflow.ellipsis),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
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
        overlayColor: MaterialStateProperty.all(Colors.green),
        fixedSize: MaterialStateProperty.all(const Size(125, 40)),
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
