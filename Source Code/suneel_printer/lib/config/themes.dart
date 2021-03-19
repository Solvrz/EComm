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
      accentColor: accentColor,
      highlightColor: highlightColor,
      scaffoldBackgroundColor: backgroundColor,
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade400,
      ),
      appBarTheme: AppBarTheme(color: backgroundColor),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: backgroundColor,
        modalBackgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            TextStyle(color: primaryColor),
          ),
        ),
      ),
    );
  }
}
