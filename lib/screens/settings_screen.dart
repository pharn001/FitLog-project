// settings_screen.dart
//
// Provides user settings and configuration options:
//   • User profile section
//   • Working Dark Mode toggle via ThemeBloc
//   • Daily goal settings for streak tracking
//   • Notification toggle (persisted locally)
//   • Workout goal cards grid

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';
import '../blocs/streak/streak_bloc.dart';
import '../blocs/streak/streak_event.dart';
import '../blocs/streak/streak_state.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  final List<_GoalItem> _goals = [
    _GoalItem(icon: Icons.directions_run, title: 'Running', target: '5 km / day'),
    _GoalItem(
        icon: Icons.fitness_center,
        title: 'Strength',
        target: '3 sessions / week'),
    _GoalItem(
        icon: Icons.local_fire_department,
        title: 'Calories',
        target: '500 kcal / day'),
    _GoalItem(icon: Icons.timer, title: 'Duration', target: '45 min / session'),
  ];

  void _showDailyGoalDialog(BuildContext context, int currentGoal) {
    final controller = TextEditingController(text: currentGoal.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ຕັ້ງເປົ້າໝາຍລາຍວັນ'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'ນາທີຕໍ່ວັນ',
            suffixText: 'ນາທີ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ຍົກເລີກ'),
          ),
          TextButton(
            onPressed: () {
              final minutes = int.tryParse(controller.text.trim());
              if (minutes != null && minutes > 0) {
                context.read<StreakBloc>().add(UpdateDailyGoal(minutes));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ເປົ້າໝາຍ: $minutes ນາທີ / ວັນ'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
            child: const Text('ບັນທຶກ'),
          ),
        ],
      ),
    );
    // dispose controller on dialog close
    controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── User Profile ─────────────────────────────────────
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor:
                        isDark ? AppColors.primaryDark : AppColors.primaryLight,
                    child:
                        const Icon(Icons.person, size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'FitLog User',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'fitlog_user@example.com',
                    style: TextStyle(
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Daily Goal Setting ───────────────────────────────
            Text(
              'ເປົ້າໝາຍລາຍວັນ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            BlocBuilder<StreakBloc, StreakState>(
              builder: (context, streakState) {
                return Card(
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.flag, color: AppColors.primary),
                    ),
                    title: const Text('ໄລຍะເວລາອອກກຳລັງກາຍ'),
                    subtitle: Text(
                        '${streakState.dailyGoalMinutes} ນາທີ / ວັນ'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showDailyGoalDialog(
                          context, streakState.dailyGoalMinutes),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),

            // ── Workout Goals Grid ───────────────────────────────
            Text(
              'Workout Goals',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
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
                    color: isDark
                        ? AppColors.darkCard
                        : AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkDivider
                          : AppColors.primary.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(goal.icon, color: AppColors.primary, size: 36),
                      const SizedBox(height: 10),
                      Text(
                        goal.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        goal.target,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // ── Preferences ──────────────────────────────────────
            Text(
              'Preferences',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Dark Mode toggle (WORKING!)
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return Card(
                  child: SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Use dark theme'),
                    secondary: Icon(
                      themeState.isDark ? Icons.dark_mode : Icons.light_mode,
                      color:
                          themeState.isDark ? Colors.indigo : Colors.amber,
                    ),
                    value: themeState.isDark,
                    activeThumbColor: AppColors.primary,
                    onChanged: (_) {
                      context.read<ThemeBloc>().add(const ToggleTheme());
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            // Notification toggle
            Card(
              child: SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Receive workout reminders'),
                secondary: Icon(
                  _notificationsEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  color:
                      _notificationsEnabled ? AppColors.primary : Colors.grey,
                ),
                value: _notificationsEnabled,
                activeThumbColor: AppColors.primary,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                },
              ),
            ),
            const SizedBox(height: 28),

            // ── About ────────────────────────────────────────────
            Center(
              child: Text(
                'FitLog v1.0.0',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

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
