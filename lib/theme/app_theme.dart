// app_theme.dart
//
// Defines the light and dark [ThemeData] for FitLog.
// Both themes use Material 3 with a teal seed colour and share consistent
// border-radius, elevation, and typography settings.

import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Provides the light and dark themes for the application.
class AppTheme {
  AppTheme._();

  // ── Shared constants ───────────────────────────────────────────────────
  static const double _cardRadius = 16.0;
  static const double _inputRadius = 12.0;
  static const double _cardElevation = 2.0;

  // ──────────────────────────────────────────────────────────────────────
  // Light Theme
  // ──────────────────────────────────────────────────────────────────────
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'HinsiewLAO',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
      ),

      // FAB
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
        elevation: _cardElevation,
        shadowColor: Colors.black12,
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 1),

      // Text
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────
  // Dark Theme
  // ──────────────────────────────────────────────────────────────────────
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryLight,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'HinsiewLAO',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
      ),

      // FAB
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.black,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
        elevation: _cardElevation,
        shadowColor: Colors.black26,
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: AppColors.darkDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: AppColors.darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.black,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(color: AppColors.darkDivider, thickness: 1),

      // Text
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
