import 'package:flutter/material.dart';

class AppTheme {
  // Core palette
  static const Color navy = Color(0xFF0A0F1E);
  static const Color navyLight = Color(0xFF111827);
  static const Color navyCard = Color(0xFF1A2235);
  static const Color gold = Color(0xFFD4A843);
  static const Color goldLight = Color(0xFFE8C56A);
  static const Color goldDim = Color(0xFF8B6914);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFF8896B0);
  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);
  static const Color border = Color(0xFF1E2D45);

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: navy,
        primaryColor: gold,
        colorScheme: const ColorScheme.dark(
          primary: gold,
          secondary: goldLight,
          surface: navyCard,
          background: navy,
          error: danger,
        ),
        fontFamily: 'SF Pro Display',
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          iconTheme: IconThemeData(color: white),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              color: white, fontSize: 36, fontWeight: FontWeight.w700),
          headlineLarge: TextStyle(
              color: white, fontSize: 28, fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(
              color: white, fontSize: 22, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(
              color: white, fontSize: 18, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(
              color: white, fontSize: 16, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(color: offWhite, fontSize: 15),
          bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
          labelLarge: TextStyle(
              color: navy, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: gold,
            foregroundColor: navy,
            minimumSize: const Size(double.infinity, 56),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: navyCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: gold, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: danger),
          ),
          hintStyle: const TextStyle(color: textSecondary),
          labelStyle: const TextStyle(color: textSecondary),
        ),
      );
}