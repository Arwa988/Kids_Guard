import 'package:flutter/material.dart';
import 'package:kids_guard/core/constants/app_colors.dart';

class AppTheme {
  static final ThemeData lighttheme = ThemeData(
    // appBarTheme: AppBarTheme(
    //   color: Colors.white,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.horizontal(
    //       left: Radius.circular(20),
    //       right: Radius.circular(20),
    //     ),
    //   ),
    // ),
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.primaryBlue),
        shadowColor: WidgetStatePropertyAll(Colors.black),
        elevation: WidgetStatePropertyAll(2),
        foregroundColor: WidgetStatePropertyAll(AppColors.backgroundLight),
      ),
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: TextTheme(
      titleSmall: TextStyle(fontSize: 10, color: AppColors.textSecondary),
      titleMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.backgroundLight,
        fontFamily: "Lexend",
      ),
      bodySmall: TextStyle(
        fontSize: 15,
        color: AppColors.kTextColor,
        fontWeight: FontWeight.bold,
        fontFamily: "Lexend",
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.kTextColor,
        fontFamily: "Lexend",
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        color: AppColors.kTextColor,
        fontFamily: "Lexend",
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.splashScreenLinearBlue,
        fontFamily: "Lexend",
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.skyBlue,
        fontFamily: "Lexend",
      ),
      // labelLarge:TextStyle(
      //   fontSize: 32,
      //   fontWeight: FontWeight.bold,
      //   color: AppColors.skyBlue,
      //   fontFamily: "Lexend",
      // ),
    ),
  );
}
