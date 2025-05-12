import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.orange,
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.transparent,
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.grey[600]),
    titleMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
  ),
  iconTheme: IconThemeData(color: Colors.black),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    primary: Colors.orange,
    secondary: Colors.deepOrange,
    onSurface: Colors.black,
    error: Colors.red,
  ),
  disabledColor: Colors.grey[600]
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.deepOrange,
  scaffoldBackgroundColor: Color(0xff212529),
  // cardColor: Colors.grey[850],
  cardColor: Colors.transparent,
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.grey[400]),
    titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
  ),
  iconTheme: IconThemeData(color: Colors.white),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xff343a40),
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.dark(
    primary: Colors.deepOrange,
    secondary: Colors.orange,
    onSurface: Colors.transparent,
    error: Colors.red,
  ),
    disabledColor: Colors.grey[600]
);