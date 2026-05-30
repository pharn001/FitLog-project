// home_screen.dart
//
// The Home screen serves as the primary landing page of FitLog.
// It displays summary statistics (total workouts and total calories burned)
// using styled stat cards arranged in a Row / Column layout.
// A BottomNavigationBar provides navigation to the History, Home, and
// Settings screens.
//
// This is a StatelessWidget because the summary data is passed in as static
// seed data and does not change within this widget's lifecycle.

import 'package:flutter/material.dart';
import '../models/workout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------------
    // Seed data – used for summary statistics on the Home screen.
    // In a production app this would come from a database or state manager.
    // ------------------------------------------------------------------
    final List<Workout> workouts = const [
      Workout(
        name: 'Morning Run',
        duration: 30,
        calories: 300,
        date: '2026-05-28',
        type: 'Running',
        notes: 'Felt great, steady pace throughout.',
      ),
      Workout(
        name: 'Weight Training',
        duration: 45,
        calories: 400,
        date: '2026-05-27',
        type: 'Weight Training',
        notes: 'Upper body focus – bench, rows, OHP.',
      ),
      Workout(
        name: 'Evening Swim',
        duration: 60,
        calories: 500,
        date: '2026-05-26',
        type: 'Swimming',
      ),
      Workout(
        name: 'Cycling Session',
        duration: 50,
        calories: 450,
        date: '2026-05-25',
        type: 'Cycling',
        notes: 'Hill intervals.',
      ),
      Workout(
        name: 'Yoga Flow',
        duration: 40,
        calories: 200,
        date: '2026-05-24',
        type: 'Yoga',
      ),
    ];

    // Compute summary metrics.
    final int totalWorkouts = workouts.length;
    final int totalCalories =
        workouts.fold<int>(0, (sum, w) => sum + w.calories);
    final int totalMinutes =
        workouts.fold<int>(0, (sum, w) => sum + w.duration);

    return Scaffold(
      // ------------------------------------------------------------------
      // AppBar
      // ------------------------------------------------------------------
      appBar: AppBar(
        title: const Text(
          'FitLog',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      // ------------------------------------------------------------------
      // Body – summary cards laid out with Column + Row
      // ------------------------------------------------------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting section
            Text(
              'Welcome back! 💪',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Here\'s your workout summary',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 24),

            // ------- Top stat cards row -------
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.fitness_center,
                    label: 'Total Workouts',
                    value: '$totalWorkouts',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department,
                    label: 'Calories Burned',
                    value: '$totalCalories kcal',
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEF6C00), Color(0xFFFFB74D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ------- Bottom stat card (full width) -------
            _StatCard(
              icon: Icons.timer,
              label: 'Total Minutes',
              value: '$totalMinutes min',
              gradient: const LinearGradient(
                colors: [Color(0xFF5C6BC0), Color(0xFF9FA8DA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),

            const SizedBox(height: 32),

            // ------- Recent workouts preview -------
            Text(
              'Recent Workouts',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...workouts.take(3).map(
                  (w) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade50,
                        child: Icon(
                          _iconForType(w.type),
                          color: Colors.teal,
                        ),
                      ),
                      title: Text(
                        w.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(w.date),
                      trailing: Text(
                        '${w.calories} kcal',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/detail', arguments: w);
                      },
                    ),
                  ),
                ),
          ],
        ),
      ),

      // ------------------------------------------------------------------
      // BottomNavigationBar – 3 tabs: History, Home, Settings
      // ------------------------------------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Home is the middle tab
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/history');
              break;
            case 1:
              // Already on home – do nothing.
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // Helper – returns an icon based on the workout type.
  static IconData _iconForType(String type) {
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
      default:
        return Icons.sports;
    }
  }
}

// ---------------------------------------------------------------------------
// _StatCard — a reusable card widget for displaying a single summary stat.
// Uses Container with BoxDecoration for gradient backgrounds and rounded
// corners.
// ---------------------------------------------------------------------------
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Gradient gradient;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
