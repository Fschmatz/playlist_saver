import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  //useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: const Color(0xFFFFFFFF),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  colorScheme: const ColorScheme.light(
    background: Color(0xFFFFFFFF),
    primary: Color(0xFF3A77D9),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF3A77D9),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF3A77D9),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
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
          fontSize: 22, fontWeight: FontWeight.w400, color: Color(0xFF000000))),
  cardTheme: const CardTheme(
    color: Color(0xFFFAFAFA),
  ),
  inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFFFFFFFF),
      focusColor: const Color(0xFF3A77D9),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xFF3A77D9),
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
  popupMenuTheme: const PopupMenuThemeData(
    color: Color(0xFFF8F8F9),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  ),
  chipTheme: ChipThemeData(
    elevation: 0,
    backgroundColor: const Color(0xFFFFFFFF),
    shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade800.withOpacity(0.3))),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFFFFFFFF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFE1E2EC),
  ),
  bottomAppBarColor: const Color(0xFFE1E2EC),
  navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFE1E2EC),
      indicatorColor: const Color(0xFFB5C0DC),
      iconTheme: MaterialStateProperty.all(const IconThemeData(
        color: Color(0xFF050505),
      )),
      labelTextStyle: MaterialStateProperty.all(const TextStyle(
          color: Color(0xFF050505), fontWeight: FontWeight.w500))),
);

ThemeData dark = ThemeData(
  //useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF202228),
  scaffoldBackgroundColor: const Color(0xFF202228),
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF202228),
    primary: Color(0xFF8BA7DE),
    onPrimary: Color(0xFF002F65),
    secondary: Color(0xFF8BA7DE),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF8BA7DE),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  appBarTheme: const AppBarTheme(
      color: Color(0xFF202228),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      titleTextStyle: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w400, color: Color(0xFFFFFFFF))),
  cardTheme: const CardTheme(
    color: Color(0xFF272930),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFF272930),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(28)),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF272930),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
    ),
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: Color(0xFF282A31),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  ),
  chipTheme: ChipThemeData(
    elevation: 0,
    backgroundColor: const Color(0xFF202228),
    shape: StadiumBorder(
        side: BorderSide(color: Colors.grey.shade800.withOpacity(0.3))),
  ),
  inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFF8BA7DE),
      focusColor: const Color(0xFF8BA7DE),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xFF8BA7DE),
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade800,
          ),
          borderRadius: BorderRadius.circular(10.0)),
      border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade800,
          ),
          borderRadius: BorderRadius.circular(10.0))),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF272930),
  ),
  bottomAppBarColor: const Color(0xFF272930),
  navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF272930),
      indicatorColor: const Color(0xFF475677),
      iconTheme: MaterialStateProperty.all(const IconThemeData(
        color: Color(0xFFE2E2E8),
      )),
      labelTextStyle: MaterialStateProperty.all(const TextStyle(
          color: Color(0xFFE2E2E8), fontWeight: FontWeight.w500))),
);
