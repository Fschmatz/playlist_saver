import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFFFFFFFF),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  colorScheme: ColorScheme.light(
    background: const Color(0xFFFFFFFF),
    primary: Colors.blueAccent.shade400,
    secondary: Colors.blueAccent.shade400,
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFFFFFFFF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(28)),
    ),
  ),
  appBarTheme: const AppBarTheme(
      color: Color(0xFFFFFFFF),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF000000)),
      titleTextStyle: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w400,
          color: Color(0xFF000000))),
  cardTheme: const CardTheme(
    color: Color(0xFFFFFFFF),
  ),
  inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFFFFFFFF),
      focusColor:  Colors.blueAccent.shade400,
      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blueAccent.shade400,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10.0)),
      border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10.0))),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFFFFFFF),
    selectedItemColor: Colors.blueAccent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFFFFFFFF),
  ),
  bottomAppBarColor: const Color(0xFFFFFFFF),
  navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFFFFFFF),
      indicatorColor: Colors.blueAccent,
      iconTheme: MaterialStateProperty.all(const IconThemeData(
        color: Color(0xFF050505),
      )),
      labelTextStyle: MaterialStateProperty.all(const TextStyle(
          color: Color(0xFF050505), fontWeight: FontWeight.w500))),
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF1C1C1D),
  scaffoldBackgroundColor: const Color(0xFF1C1C1D),
  colorScheme: const ColorScheme.dark(
      background: Color(0xFF1C1C1D),
      primary: Color(0xFF8BA7DE),
      secondary: Color(0xFF8BA7DE),
  ),
  appBarTheme: const AppBarTheme(
      color: Color(0xFF1C1C1D),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      titleTextStyle: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w400,
          color: Color(0xFFFFFFFF))),
  cardTheme: const CardTheme(
    color: Color(0xFF2C2C2D),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFF1C1C1D),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(28)),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF1C1C1D),
  ),
  inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFF8BA7DE),
      focusColor: const Color(0xFF8BA7DE),
      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xFF8BA7DE),
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[800]!,
          ),
          borderRadius: BorderRadius.circular(10.0)),
      border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[800]!,
          ),
          borderRadius: BorderRadius.circular(10.0))),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1C1C1D),
  ),
  bottomAppBarColor: const Color(0xFF1C1C1D),
  navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1C1C1D),
      indicatorColor: const Color(0xFF7592CC),
      iconTheme: MaterialStateProperty.all(const IconThemeData(
        color: Color(0xFFEAEAEA),
      )),
      labelTextStyle: MaterialStateProperty.all(const TextStyle(
          color: Color(0xFFEAEAEA), fontWeight: FontWeight.w500))),
);

