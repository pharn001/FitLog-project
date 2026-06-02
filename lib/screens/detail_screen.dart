// detail_screen.dart
//
// Displays the full details of a single [Workout] loaded by its ID.
// Provides Edit and Delete actions in the AppBar.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/workout/workout_bloc.dart';
import '../blocs/workout/workout_event.dart';
import '../blocs/workout/workout_state.dart';
import '../blocs/streak/streak_bloc.dart';
import '../blocs/streak/streak_event.dart';
import '../models/workout.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';
import '../utils/translation_helper.dart';

class DetailScreen extends StatelessWidget {
  final int workoutId;

  const DetailScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutBloc, WorkoutState>(
      builder: (context, state) {
        if (state is! WorkoutLoaded) {
          return Scaffold(
            appBar: AppBar(title: const Text('ລາຍລະອຽດການອອກກຳລັງກາຍ')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final workout = state.allWorkouts
            .where((w) => w.id == workoutId)
            .firstOrNull;

        if (workout == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('ລາຍລະອຽດການອອກກຳລັງກາຍ')),
            body: const Center(child: Text('ບໍ່ພົບຂໍ້ມູນການອອກກຳລັງກາຍ')),
          );
        }

        return _DetailBody(workout: workout);
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  final Workout workout;
  const _DetailBody({required this.workout});

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ລຶບ Workout?'),
        content: Text('ເຈົ້າຕ້ອງການລຶບ "${workout.name}" ຫຼືບໍ່?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ຍົກເລີກ'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('ລຶບ'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<WorkoutBloc>().add(DeleteWorkout(workout.id));
      context.read<StreakBloc>().add(const LoadStreak());
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${workout.name}" ຖືກລຶບແລ້ວ'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = AppColors.colorForType(workout.type);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ລາຍລະອຽດການອອກກຳລັງກາຍ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'ແກ້ໄຂ',
            onPressed: () =>
                context.push('${AppRoutes.edit}/${workout.id}'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'ລຶບ',
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header banner ────────────────────────────────────
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [typeColor.withValues(alpha: 0.4), typeColor.withValues(alpha: 0.15)]
                          : [typeColor, typeColor.withValues(alpha: 0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            AppColors.iconForType(workout.type),
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          workout.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            translateWorkoutType(workout.type),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Detail cards ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _QuickStatCard(
                          icon: Icons.timer,
                          label: 'ໄລຍະເວລາ',
                          value: '${workout.duration} ນາທີ',
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickStatCard(
                          icon: Icons.local_fire_department,
                          label: 'ແຄລໍຣີ',
                          value: '${workout.calories} kcal',
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _DetailRow(
                    icon: Icons.calendar_today,
                    label: 'ວັນທີ',
                    value: workout.formattedDate,
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.notes,
                    label: 'ໝາຍເຫດ',
                    value: workout.notes ?? 'ບໍ່ມີໝາຍເຫດສຳລັບການອອກກຳລັງກາຍນີ້.',
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QuickStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: isDark ? 0.25 : 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isDark ? AppColors.darkDivider : Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
