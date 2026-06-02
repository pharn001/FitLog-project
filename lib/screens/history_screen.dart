// history_screen.dart
//
// Displays a searchable, filterable list of all recorded workouts.
// All data is driven by WorkoutBloc state.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/workout/workout_bloc.dart';
import '../blocs/workout/workout_event.dart';
import '../blocs/workout/workout_state.dart';
import '../blocs/streak/streak_bloc.dart';
import '../blocs/streak/streak_event.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/workout_card.dart';
import '../utils/translation_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Available workout types for filter chips.
  static const _workoutTypes = [
    'Running',
    'Weight Training',
    'Swimming',
    'Cycling',
    'Yoga',
    'HIIT',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ປະຫວັດການອອກກຳລັງກາຍ', style: TextStyle(fontFamily: 'HinsiewLAO'),),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WorkoutError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is WorkoutLoaded) {
            return Column(
              children: [
                // ── Search ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'ຄົ້ນຫາການອອກກຳລັງກາຍ...',
                      prefixIcon: Icon(Icons.search,
                          color: isDark
                              ? AppColors.primaryLight
                              : AppColors.primary),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkSurface
                          : AppColors.primary.withValues(alpha: 0.06),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                context
                                    .read<WorkoutBloc>()
                                    .add(const SearchWorkouts(''));
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      context.read<WorkoutBloc>().add(SearchWorkouts(value));
                      setState(() {}); // Refresh clear button
                    },
                  ),
                ),

                // ── Filter chips ────────────────────────────────────
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: const Text('ທັງໝົດ'),
                          selected: state.activeFilter == null,
                          onSelected: (_) => context
                              .read<WorkoutBloc>()
                              .add(const FilterByType(null)),
                          selectedColor: AppColors.primary.withValues(alpha: 0.2),
                          checkmarkColor: AppColors.primary,
                        ),
                      ),
                      ..._workoutTypes.map(
                        (type) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(translateWorkoutType(type)),
                            selected: state.activeFilter == type,
                            onSelected: (_) => context
                                .read<WorkoutBloc>()
                                .add(FilterByType(
                                    state.activeFilter == type ? null : type)),
                            selectedColor:
                                AppColors.colorForType(type).withValues(alpha: 0.2),
                            avatar: Icon(AppColors.iconForType(type), size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // ── Workout list ────────────────────────────────────
                Expanded(
                  child: state.workouts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search_off,
                                  size: 64, color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              Text(
                                'ບໍ່ພົບ Workout',
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          itemCount: state.workouts.length,
                          itemBuilder: (context, index) {
                            final workout = state.workouts[index];
                            return WorkoutCard(
                              workout: workout,
                              onTap: () => context.push(
                                  '${AppRoutes.detail}/${workout.id}'),
                              onLongPress: () => context.push(
                                  '${AppRoutes.edit}/${workout.id}'),
                              onDismissed: () {
                                context
                                    .read<WorkoutBloc>()
                                    .add(DeleteWorkout(workout.id));
                                context
                                    .read<StreakBloc>()
                                    .add(const LoadStreak());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('"${workout.name}" ຖືກລຶບແລ້ວ'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
