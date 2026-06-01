// app_colors.dart
//
// Centralised colour constants used across the FitLog application.
// Provides both light and dark palette variants so every widget can
// adapt without hard-coding colours.

import 'package:flutter/material.dart';

/// Colour palette for FitLog.
class AppColors {
  AppColors._();

  // ── Brand ───────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF009688);
  static const Color primaryLight = Color(0xFF4DB6AC);
  static const Color primaryDark = Color(0xFF00695C);

  // ── Accent / Secondary ─────────────────────────────────────────────────
  static const Color accent = Color(0xFFFF7043);
  static const Color accentLight = Color(0xFFFFAB91);

  // ── Stat card gradients ────────────────────────────────────────────────
  static const List<Color> tealGradient = [Color(0xFF00897B), Color(0xFF4DB6AC)];
  static const List<Color> orangeGradient = [Color(0xFFEF6C00), Color(0xFFFFB74D)];
  static const List<Color> indigoGradient = [Color(0xFF5C6BC0), Color(0xFF9FA8DA)];
  static const List<Color> pinkGradient = [Color(0xFFEC407A), Color(0xFFF48FB1)];
  static const List<Color> purpleGradient = [Color(0xFF7E57C2), Color(0xFFB39DDB)];

  // ── Dark theme surfaces ────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF252525);
  static const Color darkDivider = Color(0xFF2C2C2C);

  // ── Light theme surfaces ───────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Colors.white;
  static const Color lightCard = Colors.white;

  // ── Chart colours ──────────────────────────────────────────────────────
  static const List<Color> chartPalette = [
    Color(0xFF26A69A),
    Color(0xFFEF6C00),
    Color(0xFF5C6BC0),
    Color(0xFFEC407A),
    Color(0xFF66BB6A),
    Color(0xFFFFCA28),
    Color(0xFF7E57C2),
  ];

  // ── Workout type colours ───────────────────────────────────────────────
  static Color colorForType(String type) {
    switch (type) {
      case 'Running':
        return const Color(0xFF26A69A);
      case 'Weight Training':
        return const Color(0xFFEF6C00);
      case 'Swimming':
        return const Color(0xFF5C6BC0);
      case 'Cycling':
        return const Color(0xFF66BB6A);
      case 'Yoga':
        return const Color(0xFF7E57C2);
      case 'HIIT':
        return const Color(0xFFEC407A);
      default:
        return const Color(0xFF78909C);
    }
  }

  /// Returns an appropriate icon for a workout type.
  static IconData iconForType(String type) {
    switch (type) {
      case 'Running':
        return Icons.directions_run;
      case 'Weight Training':
        return Icons.fitness_center;
      case 'Swimming':
        return Icons.pool;
      case 'Cycling':
        return Icons.directions_bike;
      case 'Yoga':
        return Icons.self_improvement;
      case 'HIIT':
        return Icons.flash_on;
      default:
        return Icons.sports;
    }
  }
}
