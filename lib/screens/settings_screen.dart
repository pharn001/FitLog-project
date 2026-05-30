// settings_screen.dart
//
// Provides user settings and configuration options:
//   • A Drawer with navigation links to other screens.
//   • A user profile section featuring a CircleAvatar.
//   • A GridView.count(crossAxisCount: 2) displaying workout goal cards.
//   • A SwitchListTile for toggling notifications on/off.
//
// This is a StatefulWidget because the notification toggle and goal values
// are mutable state managed with setState.

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ------------------------------------------------------------------
  // State
  // ------------------------------------------------------------------

  /// Whether push notifications are enabled.
  bool _notificationsEnabled = true;

  /// Whether dark mode is enabled (secondary toggle).
  bool _darkModeEnabled = false;

  /// Sample workout goal data for the grid.
  final List<_GoalItem> _goals = [
    _GoalItem(icon: Icons.directions_run, title: 'Running', target: '5 km / day'),
    _GoalItem(icon: Icons.fitness_center, title: 'Strength', target: '3 sessions / week'),
    _GoalItem(icon: Icons.local_fire_department, title: 'Calories', target: '500 kcal / day'),
    _GoalItem(icon: Icons.timer, title: 'Duration', target: '45 min / session'),
  ];

  // ------------------------------------------------------------------
  // Build
  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      // ----------------------------------------------------------------
      // Drawer with navigation links
      // ----------------------------------------------------------------
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 32, color: Colors.teal),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'FitLog User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Stay consistent 💪',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Navigation links
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Workout History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/history');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Add Workout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/add');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              selected: true,
              selectedTileColor: Colors.teal.shade50,
              onTap: () {
                Navigator.pop(context); // already here
              },
            ),
          ],
        ),
      ),

      // ----------------------------------------------------------------
      // Body
      // ----------------------------------------------------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- User Profile Section ----
            Center(
              child: Column(
                children: [
                  // CircleAvatar for the user profile
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: Color(0xFF4DB6AC),
                    child: Icon(Icons.person, size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'FitLog User',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'fitlog_user@example.com',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ---- Workout Goals Section (GridView) ----
            Text(
              'Workout Goals',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: _goals.map((goal) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.teal.shade100),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(goal.icon, color: Colors.teal, size: 36),
                      const SizedBox(height: 10),
                      Text(
                        goal.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        goal.target,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // ---- Preferences Section ----
            Text(
              'Preferences',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Notification toggle
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 1,
              child: SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Receive workout reminders'),
                secondary: Icon(
                  _notificationsEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  color: _notificationsEnabled ? Colors.teal : Colors.grey,
                ),
                value: _notificationsEnabled,
                activeThumbColor: Colors.teal,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 8),

            // Dark mode toggle
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 1,
              child: SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Use dark theme'),
                secondary: Icon(
                  _darkModeEnabled ? Icons.dark_mode : Icons.light_mode,
                  color: _darkModeEnabled ? Colors.indigo : Colors.amber,
                ),
                value: _darkModeEnabled,
                activeThumbColor: Colors.teal,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 28),

            // ---- About Section ----
            Center(
              child: Text(
                'FitLog v1.0.0',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _GoalItem — simple data class for workout goal cards.
// ---------------------------------------------------------------------------
class _GoalItem {
  final IconData icon;
  final String title;
  final String target;

  const _GoalItem({
    required this.icon,
    required this.title,
    required this.target,
  });
}
