// shell_screen.dart
//
// ShellRoute wrapper that provides the persistent BottomNavigationBar
// across the four main tabs (Home, History, Statistics, Settings).
// Also hosts a centered FAB for adding workouts.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';

class ShellScreen extends StatelessWidget {
  final Widget child;

  const ShellScreen({super.key, required this.child});

  static const _tabs = [
    AppRoutes.home,
    AppRoutes.history,
    AppRoutes.statistics,
    AppRoutes.settings,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _tabs.indexWhere((tab) => location.startsWith(tab));
    return index >= 0 ? index : 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) {
            context.go(_tabs[index]);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addWorkoutFab',
        onPressed: () => context.push(AppRoutes.add),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
