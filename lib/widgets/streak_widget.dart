// streak_widget.dart
//
// Displays the current workout streak, longest streak, and today's
// daily-goal progress as an animated progress bar.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/streak/streak_bloc.dart';
import '../blocs/streak/streak_state.dart';
import '../theme/app_colors.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<StreakBloc, StreakState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1E3A3A), const Color(0xFF0D2626)]
                  : AppColors.tealGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Streak row
              Row(
                children: [
                  // Current streak
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '🔥',
                              style: TextStyle(fontSize: state.currentStreak > 0 ? 28 : 22),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${state.currentStreak}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'ມື້',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Streak ປັດຈຸບັນ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Longest streak
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${state.longestStreak}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'ສູງສຸດ',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Daily goal progress
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ເປົ້າໝາຍມື້ນີ້',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${state.todayMinutes} / ${state.dailyGoalMinutes} ນາທີ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOut,
                              width: constraints.maxWidth * state.todayProgress,
                              decoration: BoxDecoration(
                                color: state.todayCompleted
                                    ? const Color(0xFF66BB6A)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (state.todayCompleted) ...[
                    const SizedBox(height: 6),
                    Text(
                      '✅ ສຳເລັດແລ້ວມື້ນີ້!',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF66BB6A).withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
