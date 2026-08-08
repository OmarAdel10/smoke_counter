import 'package:flutter/material.dart';

class AppTheme {
  static const Color ember = Color(0xFFE8623D);
  static const Color charcoal = Color(0xFF33363A);
  static const Color warmOffWhite = Color(0xFFF7F3EE);
  static const Color smokeGrey = Color(0xFF9B9D9F);
  static const Color sage = Color(0xFF6B9080);
  static const Color alertRed = Color(0xFFC1483B);

  static const Color darkBackground = Color(0xFF1C1E20);
  static const Color darkSurface = Color(0xFF26292C);
  static const Color darkPrimaryText = Color(0xFFF0EDE8);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ember,
      brightness: Brightness.light,
      primary: ember,
      secondary: charcoal,
      surface: warmOffWhite,
      onSurface: charcoal,
      onPrimary: Colors.white,
      surfaceContainerHighest: smokeGrey.withValues(alpha: 0.2),
    ),
    scaffoldBackgroundColor: warmOffWhite,
    appBarTheme: AppBarTheme(
      backgroundColor: warmOffWhite,
      foregroundColor: charcoal,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: charcoal,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ember,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: smokeGrey.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: smokeGrey.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ember, width: 2),
      ),
      labelStyle: TextStyle(color: smokeGrey),
      hintStyle: TextStyle(color: smokeGrey.withValues(alpha: 0.6)),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(color: charcoal, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(color: charcoal, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: charcoal, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: charcoal, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: charcoal, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: charcoal),
      bodyMedium: TextStyle(color: charcoal),
      labelLarge: TextStyle(color: charcoal, fontWeight: FontWeight.w600),
    ),
    iconTheme: IconThemeData(color: charcoal),
    dividerColor: smokeGrey.withValues(alpha: 0.2),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ember,
      brightness: Brightness.dark,
      primary: ember,
      secondary: charcoal,
      surface: darkSurface,
      onSurface: darkPrimaryText,
      onPrimary: Colors.white,
      surfaceContainerHighest: smokeGrey.withValues(alpha: 0.15),
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkPrimaryText,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: darkPrimaryText,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ember,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: smokeGrey.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: smokeGrey.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ember, width: 2),
      ),
      labelStyle: TextStyle(color: smokeGrey),
      hintStyle: TextStyle(color: smokeGrey.withValues(alpha: 0.6)),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: darkPrimaryText,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: darkPrimaryText,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: darkPrimaryText,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: darkPrimaryText,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: darkPrimaryText,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(color: darkPrimaryText),
      bodyMedium: TextStyle(color: darkPrimaryText),
      labelLarge: TextStyle(
        color: darkPrimaryText,
        fontWeight: FontWeight.w600,
      ),
    ),
    iconTheme: IconThemeData(color: darkPrimaryText),
    dividerColor: smokeGrey.withValues(alpha: 0.15),
  );
}
