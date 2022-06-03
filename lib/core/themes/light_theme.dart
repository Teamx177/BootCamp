import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/core/themes/lib_color_schemes.g.dart';
import 'package:hrms/core/themes/text_theme.dart';

class LightTheme {
  ThemeData theme = ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        surfaceTintColor: lightColorScheme.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightColorScheme.tertiary,
      foregroundColor: lightColorScheme.onTertiary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    scaffoldBackgroundColor: lightColorScheme.background,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      color: Colors.transparent,
      elevation: 0,
      // centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        fixedSize:
            (MaterialStateProperty.all(const Size(double.maxFinite, 50))),
        foregroundColor:
            MaterialStateProperty.all(lightColorScheme.onSecondary),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return lightColorScheme.onSecondary;
          } else if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }
          return lightColorScheme.tertiary;
        }),
        visualDensity: VisualDensity.standard,
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.white,
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    colorScheme: lightColorScheme,
    useMaterial3: true,
    textTheme: textTheme,
  );
}
