// theme_event.dart
import 'package:equatable/equatable.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override
  List<Object?> get props => [];
}

/// Toggle between light and dark mode.
class ToggleTheme extends ThemeEvent {
  const ToggleTheme();
}

/// Load the persisted theme preference on app startup.
class LoadTheme extends ThemeEvent {
  const LoadTheme();
}
