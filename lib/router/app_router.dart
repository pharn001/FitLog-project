// app_router.dart
//
// Configures go_router for FitLog with:
//   • A ShellRoute wrapping the four main tabs (Home, History, Statistics, Settings)
//   • Full-screen routes for Add, Edit, Detail, and Timer screens.

import 'package:go_router/go_router.dart';

import '../screens/shell_screen.dart';
import '../screens/home_screen.dart';
import '../screens/history_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/add_workout_screen.dart';
import '../screens/edit_workout_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/timer_screen.dart';

/// Named route paths.
class AppRoutes {
  AppRoutes._();
  static const String home = '/home';
  static const String history = '/history';
  static const String statistics = '/statistics';
  static const String settings = '/settings';
  static const String add = '/add';
  static const String edit = '/edit'; // /edit/:id
  static const String detail = '/detail'; // /detail/:id
  static const String timer = '/timer';
}

/// Creates and returns the [GoRouter] instance.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      // ── Shell (bottom nav tabs) ──────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.history,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HistoryScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.statistics,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StatisticsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),

      // ── Full-screen routes ───────────────────────────────────────────
      GoRoute(
        path: AppRoutes.add,
        builder: (context, state) {
          final duration = state.extra as int?;
          return AddWorkoutScreen(initialDuration: duration);
        },
      ),
      GoRoute(
        path: '${AppRoutes.edit}/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return EditWorkoutScreen(workoutId: id);
        },
      ),
      GoRoute(
        path: '${AppRoutes.detail}/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DetailScreen(workoutId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.timer,
        builder: (context, state) => const TimerScreen(),
      ),
    ],
  );
}
