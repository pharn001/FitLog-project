// streak_state.dart
import 'package:equatable/equatable.dart';

class StreakState extends Equatable {
  /// Number of consecutive days the user has worked out.
  final int currentStreak;

  /// The longest streak ever recorded.
  final int longestStreak;

  /// Whether today's daily goal has been met.
  final bool todayCompleted;

  /// Total workout minutes logged today.
  final int todayMinutes;

  /// Daily goal in minutes.
  final int dailyGoalMinutes;

  const StreakState({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.todayCompleted = false,
    this.todayMinutes = 0,
    this.dailyGoalMinutes = 30,
  });

  /// Progress towards today's goal as a value from 0.0 to 1.0.
  double get todayProgress {
    if (dailyGoalMinutes == 0) return 1.0;
    return (todayMinutes / dailyGoalMinutes).clamp(0.0, 1.0);
  }

  @override
  List<Object?> get props => [
        currentStreak,
        longestStreak,
        todayCompleted,
        todayMinutes,
        dailyGoalMinutes,
      ];
}
