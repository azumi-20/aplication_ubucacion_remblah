import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF2E7D32);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
    ),
    scaffoldBackgroundColor: Colors.grey.shade100,
    fontFamily: 'PublicSans',
  );
}
