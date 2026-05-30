// main.dart
//
// Entry point for the FitLog workout tracking application.
// Configures the MaterialApp with:
//   • A teal-based ThemeData for consistent styling across screens.
//   • Named routes for all five screens (Home, History, Add, Detail, Settings).
//
// No external packages are used — only Flutter built-in widgets.

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/add_workout_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const FitLogApp());
}

/// Root widget of the FitLog application.
class FitLogApp extends StatelessWidget {
  const FitLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitLog',
      debugShowCheckedModeBanner: false,

      // ------------------------------------------------------------------
      // Theme – teal primary colour with refined typography & shapes.
      // ------------------------------------------------------------------
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
        ),
        useMaterial3: true,
      ),

      // ------------------------------------------------------------------
      // Named routes
      // ------------------------------------------------------------------
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/history': (context) => const HistoryScreen(),
        '/add': (context) => const AddWorkoutScreen(),
        '/detail': (context) => const DetailScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
