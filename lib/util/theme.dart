import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  useMaterial3: true,
  textTheme: const TextTheme(
    titleMedium: TextStyle(fontWeight: FontWeight.w400),
  ),
  brightness: Brightness.light,
  primaryColor: const Color(0xFFFDFBFF),
  scaffoldBackgroundColor: const Color(0xFFFDFBFF),
  colorScheme: const ColorScheme.light(
    background: Color(0xFFFDFBFF),
    primary: Color(0xFF3A77D9),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF3A77D9),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF3A77D9),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFFFDFBFF),
  ),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Color(0xFFFDFBFF),
    color: Color(0xFFFDFBFF),
  ),
  cardTheme: const CardTheme(
    color: Color(0xFFFFFFFF),
  ),
  inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFFFDFBFF),
      focusColor: const Color(0xFF3A77D9),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xFF3A77D9),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF74777F),
          ),
          borderRadius: BorderRadius.circular(8.0)),
      border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF74777F),
          ),
          borderRadius: BorderRadius.circular(8.0))),
  popupMenuTheme: const PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    color: Color(0xFFF3F0F5),
  ),
  chipTheme: const ChipThemeData(
    elevation: 0,
    backgroundColor: Color(0xFFFDFBFF),
    labelPadding: EdgeInsets.symmetric(horizontal: 16),
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFFFDFBFF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFFB5C0DC),
      contentTextStyle: TextStyle(
        color: Color(0xFF050505),
      ),
      actionTextColor: Color(0xFF3A77D9),
      behavior: SnackBarBehavior.floating),
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
  useMaterial3: true,
  textTheme: const TextTheme(
    titleMedium: TextStyle(fontWeight: FontWeight.w400),
  ),
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF1B1B1D),
  scaffoldBackgroundColor: const Color(0xFF1B1B1D),
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF1B1B1D),
    primary: Color(0xFF97B8F6),
    onPrimary: Color(0xFF002F65),
    secondary: Color(0xFF97B8F6),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF97B8F6),
  ),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Color(0xFF1B1B1D),
    color: Color(0xFF1B1B1D),
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF272630),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFF272630),
  ),
  snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF414046),
      contentTextStyle: TextStyle(
        color: Color(0xFFE2E2E9),
      ),
      actionTextColor: Color(0xFF97B8F6),
      behavior: SnackBarBehavior.floating),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF272630),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
    ),
  ),
  popupMenuTheme: const PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      color: Color(0xFF303036)),
  chipTheme: const ChipThemeData(
    elevation: 0,
    backgroundColor: Color(0xFF1B1B1D),
    labelPadding: EdgeInsets.symmetric(horizontal: 16),
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFF97B8F6),
      focusColor: const Color(0xFF97B8F6),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xFF97B8F6),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF8D9099),
          ),
          borderRadius: BorderRadius.circular(8.0)),
      border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF8D9099),
          ),
          borderRadius: BorderRadius.circular(8.0))),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF272630),
  ),
  bottomAppBarColor: const Color(0xFF272630),
  navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF272630),
      indicatorColor: const Color(0xFF445A8C),
      iconTheme: MaterialStateProperty.all(const IconThemeData(
        color: Color(0xFFE2E2E9),
      )),
      labelTextStyle: MaterialStateProperty.all(const TextStyle(
          color: Color(0xFFE2E2E9), fontWeight: FontWeight.w500))),
);
