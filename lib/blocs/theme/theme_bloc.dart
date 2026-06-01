// theme_bloc.dart
//
// Manages the application theme mode (light / dark).
// Persists the user's preference using SharedPreferences.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const _key = 'theme_mode';

  ThemeBloc() : super(const ThemeState()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_key) ?? false;
    emit(ThemeState(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final newMode =
        state.isDark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, newMode == ThemeMode.dark);
    emit(ThemeState(themeMode: newMode));
  }
}
