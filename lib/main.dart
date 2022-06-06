import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hireme/core/managers/route_manager.dart';
import 'package:hireme/core/services/auth/auth_service.dart';
import 'package:hireme/core/themes/dark_theme.dart';
import 'package:hireme/core/themes/light_theme.dart';
import 'package:hireme/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('themeData');
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
  runApp(const HireMe());
}

class HireMe extends StatelessWidget {
  const HireMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('themeData').listenable(),
      builder: (_, currentMode, box) {
        var darkMode = Hive.box('themeData').get('darkmode', defaultValue: false);
        return MultiProvider(
          providers: [Provider<AuthService>(create: (_) => AuthService.firebase())],
          child: OKToast(
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
              title: 'HIREme',
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
