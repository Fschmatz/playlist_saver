import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: const Color(0xFFFDFBFF),
  scaffoldBackgroundColor: const Color(0xFFFDFBFF),
  colorScheme: const ColorScheme.light(
    background: Color(0xFFFDFBFF),
    primary: Color(0xFF3A77D9),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF3A77D9),
    outline: Color(0xFF74777F),
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
    surfaceTintColor: Color(0xFFFAFCFC),
    color: Color(0xFFFAFCFC),
  ),
  inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFFFDFBFF),
      focusColor: Color(0xFF3A77D9),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF3A77D9),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF74777F),
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF74777F),
        ),
      )),
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
    backgroundColor: Color(0xFFE1E2EC),
    surfaceTintColor: Color(0xFFE1E2EC),
  ),
  listTileTheme: const ListTileThemeData(iconColor: Color(0xFF454546)),
  dividerTheme: const DividerThemeData(color: Color(0xFFB2B2B9)),
  snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF1a1c29), behavior: SnackBarBehavior.floating),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFE1E2EC),
  ),
  navigationBarTheme: NavigationBarThemeData(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      backgroundColor: const Color(0xFFE1E2EC),
      surfaceTintColor: const Color(0xFFE1E2EC),
      indicatorColor: const Color(0xFFB5C0DC),
      iconTheme: MaterialStateProperty.all(const IconThemeData(
        color: Color(0xFF050505),
      )),
      labelTextStyle: MaterialStateProperty.all(const TextStyle(
          color: Color(0xFF050505), fontWeight: FontWeight.w500))),
);

ThemeData dark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF1B1B1D),
  scaffoldBackgroundColor: const Color(0xFF1B1B1D),
  colorScheme: const ColorScheme.dark(
      background: Color(0xFF1B1B1D),
      primary: Color(0xFFA4C2FD),
      onPrimary: Color(0xFF002F65),
      secondary: Color(0xFFA4C2FD),
      outline: Color(0xFF8D9099)),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFA4C2FD),
  ),
  listTileTheme: const ListTileThemeData(iconColor: Color(0xFFE2E2E9)),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Color(0xFF1B1B1D),
    color: Color(0xFF1B1B1D),
  ),
  cardTheme: const CardTheme(
    surfaceTintColor: Color(0xFF28282A),
    color: Color(0xFF28282A),
  ),
  dividerTheme: const DividerThemeData(color: Color(0xFF424248)),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFF282932),
  ),
  snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xffb8cbe1), behavior: SnackBarBehavior.floating),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF282932),
    surfaceTintColor: Color(0xFF282932),
  ),
  popupMenuTheme: const PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    color: Color(0xFF303036),
  ),
  chipTheme: const ChipThemeData(
    elevation: 0,
    backgroundColor: Color(0xFF1B1B1D),
    labelPadding: EdgeInsets.symmetric(horizontal: 16),
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
      focusColor: Color(0xFFA4C2FD),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFA4C2FD),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF8D9099),
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF8D9099),
        ),
      )),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF282932),
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      backgroundColor: const Color(0xFF282932),
      surfaceTintColor: const Color(0xFF282932),
      indicatorColor: const Color(0xFF424A67),
      iconTheme: MaterialStateProperty.all(const IconThemeData(
        color: Color(0xFFE2E2EF),
      )),
      labelTextStyle: MaterialStateProperty.all(const TextStyle(
          color: Color(0xFFE2E2EF), fontWeight: FontWeight.w500))),
);
