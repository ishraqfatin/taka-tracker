import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
      fontFamily: GoogleFonts.montserrat().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 6, 6, 6)),
        titleTextStyle: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        background: Colors.white,
        error: Colors.red,
        onTertiary: Colors.orange,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData darkThemeData() {
    return ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 21, 21, 21),
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
            )),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          background: const Color.fromARGB(255, 21, 21, 21),
          error: Colors.red,
          onTertiary: Colors.orange,
        ),
        useMaterial3: true);
  }
}
