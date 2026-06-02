// home_screen.dart
//
// The Home screen serves as the primary landing page of FitLog.
// Displays a streak widget, summary statistics, and recent workouts.
// All data is driven by BLoC state rather than hardcoded values.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/workout/workout_bloc.dart';
import '../blocs/workout/workout_state.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/streak_widget.dart';
import '../widgets/workout_card.dart';
import '../widgets/nutrition_summary_card.dart';
import '../blocs/profile/profile_bloc.dart';
import '../blocs/profile/profile_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitLog'),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WorkoutError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                  const SizedBox(height: 12),
                  Text('Error: ${state.message}'),
                ],
              ),
            );
          }

          if (state is WorkoutLoaded) {
            return _HomeBody(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final WorkoutLoaded state;
  const _HomeBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting ───────────────────────────────────────────────
          Text(
            'ຍິນດີຕ້ອນຮັບກັບຄືນ! 💪',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.primaryLight : AppColors.primaryDark,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'ນີ້ແມ່ນສະຫຼຸບການອອກກຳລັງກາຍຂອງທ່ານ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 20),

          // ── Streak Widget ──────────────────────────────────────────
          const StreakWidget(),
          const SizedBox(height: 24),

          // ── Nutrition Card ─────────────────────────────────────────
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return Column(
                  children: [
                    NutritionSummaryCard(
                      profile: state.profile,
                      onEditTap: () => context.push(AppRoutes.profileSetup),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }
              if (state is ProfileEmpty) {
                return Column(
                  children: [
                    _buildSetupProfileBanner(context, isDark),
                    const SizedBox(height: 24),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // ── Stat Cards Row ─────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.fitness_center,
                  label: 'ການອອກກຳລັງກາຍທັງໝົດ',
                  value: '${state.totalWorkouts}',
                  gradient: const LinearGradient(
                    colors: AppColors.tealGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: StatCard(
                  icon: Icons.local_fire_department,
                  label: 'ເຜົາຜານແຄລໍຣີ',
                  value: '${state.totalCalories} kcal',
                  gradient: const LinearGradient(
                    colors: AppColors.orangeGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          StatCard(
            icon: Icons.timer,
            label: 'ເວລາທັງໝົດ',
            value: '${state.totalMinutes} ນາທີ',
            gradient: const LinearGradient(
              colors: AppColors.indigoGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          const SizedBox(height: 28),

          // ── Recent Workouts ────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ການອອກກຳລັງກາຍຫຼ້າສຸດ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.history),
                child: Text(
                  'ເບິ່ງທັງໝົດ',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (state.allWorkouts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.fitness_center,
                        size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(
                      'ຍັງບໍ່ມີ Workout\nກົດປຸ່ມ + ເພື່ອເພີ່ມ',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            )
          else
            ...state.recentWorkouts(3).map(
                  (w) => WorkoutCard(
                    workout: w,
                    onTap: () =>
                        context.push('${AppRoutes.detail}/${w.id}'),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSetupProfileBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ຕັ້ງເປົ້າໝາຍໂພຊະນາການຂອງທ່ານ 🎯',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'ປ້ອນນ້ຳໜັກ ສ່ວນສູງ ແລະ ເປົ້າໝາຍເພື່ອຄຳນວນແຄລໍຣີຕໍ່ວັນຂອງທ່ານ',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.push(AppRoutes.profileSetup),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('ຕັ້ງຄ່າຂໍ້ມູນຮ່າງກາຍ'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.spa,
            color: Colors.white,
            size: 64,
          ),
        ],
      ),
    );
  }
}
