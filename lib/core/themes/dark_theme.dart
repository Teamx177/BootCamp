import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hireme/core/themes/lib_color_schemes.g.dart';
import 'package:hireme/core/themes/text_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DarkTheme {
  ThemeData theme = ThemeData(
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(darkColorScheme.onSecondary),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return darkColorScheme.tertiary;
          } else if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }
          return darkColorScheme.secondary;
        }),
        visualDensity: VisualDensity.standard,
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkColorScheme.tertiary,
      foregroundColor: darkColorScheme.onTertiary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    scaffoldBackgroundColor: darkColorScheme.background,
    colorScheme: darkColorScheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(darkColorScheme.onSecondary),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return darkColorScheme.tertiary;
          } else if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }
          return darkColorScheme.secondary;
        }),
        fixedSize: (MaterialStateProperty.all(const Size(double.maxFinite, 40))),
        visualDensity: VisualDensity.standard,
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    ),
    useMaterial3: true,
    textTheme: textThemes,
  );
}

dynamic darkMode = Hive.box('themeData').get('darkmode');
