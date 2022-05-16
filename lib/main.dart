import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hrms/firebase_options.dart';
import 'package:hrms/managers/route_manager.dart';
import 'package:hrms/storage/firebase.dart';
import 'package:hrms/themes/dark_theme.dart';
import 'package:hrms/themes/light_theme.dart';

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
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  const Hrms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('themeData').listenable(),
      builder: (_, currentMode, box) {
        var darkMode = Hive.box('themeData').get('darkmode', defaultValue: false);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          title: 'HRMS',
          theme: LightTheme().theme,
          darkTheme: DarkTheme().theme,
          // Created routes management is in here
          // initialroute made if users logged in starts with home page
          initialRoute: user != null ? '/main' : '/welcome',
          routes: Routes().routes,
        );
      },
    );
  }
}
