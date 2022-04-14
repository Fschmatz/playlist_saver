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
    color: Color(0xFFF0F1F4),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFEAEBEF),
    selectedItemColor: Colors.blueAccent,
  ),
  bottomAppBarColor: const Color(0xFFEAEBEF),
  navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFE8E9EF),
      indicatorColor: Colors.blueAccent,
      iconTheme: MaterialStateProperty.all(const IconThemeData(
        color: Color(0xFF050505),
      )),
      labelTextStyle: MaterialStateProperty.all(const TextStyle(
          color: Color(0xFF050505), fontWeight: FontWeight.w500))),
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF202124),
  scaffoldBackgroundColor: const Color(0xFF202124),
  colorScheme: const ColorScheme.dark(
      background: Color(0xFF202124),
      primary: Color(0xFF8BA7DE),
      secondary: Color(0xFF8BA7DE),
  ),
  appBarTheme: const AppBarTheme(
      color: Color(0xFF202124),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      titleTextStyle: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w400,
          color: Color(0xFFFFFFFF))),
  cardTheme: const CardTheme(
    color: Color(0xFF2A2C31),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFF202124),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(28)),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF28292F),
  ),
  bottomAppBarColor: const Color(0xFF28292F),
  navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF28292F),
      indicatorColor: const Color(0xFF7592CC),
      iconTheme: MaterialStateProperty.all(const IconThemeData(
        color: Color(0xFFEAEAEA),
      )),
      labelTextStyle: MaterialStateProperty.all(const TextStyle(
          color: Color(0xFFEAEAEA), fontWeight: FontWeight.w500))),
);

