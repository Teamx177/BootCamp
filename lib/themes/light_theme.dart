import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/themes/lib_color_schemes.g.dart';

class LightTheme {
  ThemeData theme = ThemeData(
    scaffoldBackgroundColor: lightColorScheme.background,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      color: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          const Size(125, 40),
        ),
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
    inputDecorationTheme: InputDecorationTheme(
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
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    colorScheme: lightColorScheme,
    useMaterial3: true,
  );
}
