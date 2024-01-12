// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

class ECommAdminTheme {
  static ThemeData of(BuildContext context) {
    const Color primary = Color(0xFFFF5252);
    const Color onPrimary = Color(0xFF000000);
    const Color background = Color(0xFFFFFFFF);
    const Color secondary = Color(0xFF616161);
    const Color onSecondary = Color(0xFFFFFFFF);
    const Color highlight = Color(0xFFEEEEEE);

    return ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light().copyWith(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        background: background,
      ),
      highlightColor: highlight,
      scaffoldBackgroundColor: background,
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade400,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
      appBarTheme: const AppBarTheme(color: background),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: background,
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
            const TextStyle(color: primary),
          ),
        ),
      ),
    );
  }
}
