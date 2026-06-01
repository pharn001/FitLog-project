// streak_bloc.dart
//
// Calculates the user's workout streak and daily-goal progress by
// iterating backwards through the workout history.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repositories/workout_repository.dart';
import 'streak_event.dart';
import 'streak_state.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final WorkoutRepository _repository;
  static const _goalKey = 'daily_goal_minutes';

  StreakBloc({required WorkoutRepository repository})
      : _repository = repository,
        super(const StreakState()) {
    on<LoadStreak>(_onLoadStreak);
    on<UpdateDailyGoal>(_onUpdateDailyGoal);
  }

  Future<void> _onLoadStreak(
    LoadStreak event,
    Emitter<StreakState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dailyGoal = prefs.getInt(_goalKey) ?? 30;

      // Get today's workouts
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final todayWorkouts = await _repository.getWorkoutsForDate(today);
      final todayMinutes =
          todayWorkouts.fold<int>(0, (sum, w) => sum + w.duration);
      final todayCompleted = todayMinutes >= dailyGoal;

      // Calculate streak — count consecutive days with workouts going back
      int currentStreak = 0;
      var checkDate = todayCompleted ? today : today.subtract(const Duration(days: 1));

      while (true) {
        final dayWorkouts = await _repository.getWorkoutsForDate(checkDate);
        if (dayWorkouts.isEmpty) break;
        currentStreak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }

      // Calculate longest streak from all workouts
      final allWorkouts = await _repository.getAllWorkouts();
      int longestStreak = currentStreak;

      if (allWorkouts.isNotEmpty) {
        // Get unique workout dates sorted ascending
        final dates = allWorkouts
            .map((w) => DateTime(w.date.year, w.date.month, w.date.day))
            .toSet()
            .toList()
          ..sort();

        int tempStreak = 1;
        for (int i = 1; i < dates.length; i++) {
          if (dates[i].difference(dates[i - 1]).inDays == 1) {
            tempStreak++;
            if (tempStreak > longestStreak) longestStreak = tempStreak;
          } else {
            tempStreak = 1;
          }
        }
      }

      emit(StreakState(
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        todayCompleted: todayCompleted,
        todayMinutes: todayMinutes,
        dailyGoalMinutes: dailyGoal,
      ));
    } catch (e) {
      // Emit default state on error
      emit(const StreakState());
    }
  }

  Future<void> _onUpdateDailyGoal(
    UpdateDailyGoal event,
    Emitter<StreakState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_goalKey, event.minutes);
    // Recalculate streak with new goal
    add(const LoadStreak());
  }
}
