import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    Color primaryColor = Colors.redAccent;
    Color backgroundColor = Colors.white;
    Color accentColor = Colors.grey.shade700;
    Color highlightColor = Colors.grey.shade200;

    return ThemeData.light().copyWith(
      backgroundColor: backgroundColor,
      primaryColor: primaryColor,
      highlightColor: highlightColor,
      scaffoldBackgroundColor: backgroundColor,
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade400,
      ),
      appBarTheme: AppBarTheme(color: backgroundColor),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: backgroundColor,
        modalBackgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 10,
        backgroundColor: backgroundColor,
        foregroundColor: primaryColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            TextStyle(color: primaryColor),
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
    );
  }
}
