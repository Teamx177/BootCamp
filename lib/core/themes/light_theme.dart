import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrms/core/themes/lib_color_schemes.g.dart';

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
        backgroundColor:
            MaterialStateProperty.all(const Color.fromARGB(255, 230, 181, 148)),
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
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    colorScheme: lightColorScheme,
    useMaterial3: true,
    textTheme: TextTheme(
      headline1: GoogleFonts.rubik(
        fontSize: 96,
        fontWeight: FontWeight.w300,
      ),
      headline2: GoogleFonts.rubik(
        fontSize: 60,
        fontWeight: FontWeight.w300,
      ),
      headline3: GoogleFonts.rubik(
        fontSize: 48,
        fontWeight: FontWeight.normal,
      ),
      headline4: GoogleFonts.rubik(
        fontSize: 34,
        fontWeight: FontWeight.normal,
      ),
      headline5: GoogleFonts.rubik(
        fontSize: 24,
        fontWeight: FontWeight.normal,
      ),
      headline6: GoogleFonts.rubik(
        fontSize: 20,
        fontWeight: FontWeight.w300,
      ),
      subtitle1: GoogleFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      subtitle2: GoogleFonts.rubik(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodyText1: GoogleFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: GoogleFonts.rubik(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      button: GoogleFonts.rubik(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      caption: GoogleFonts.rubik(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      overline: GoogleFonts.rubik(
        fontSize: 10,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
