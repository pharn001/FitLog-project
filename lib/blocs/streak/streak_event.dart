// streak_event.dart
import 'package:equatable/equatable.dart';

sealed class StreakEvent extends Equatable {
  const StreakEvent();
  @override
  List<Object?> get props => [];
}

/// Calculate current streak data from workout history.
class LoadStreak extends StreakEvent {
  const LoadStreak();
}

/// Update the daily goal target (in minutes).
class UpdateDailyGoal extends StreakEvent {
  final int minutes;
  const UpdateDailyGoal(this.minutes);

  @override
  List<Object?> get props => [minutes];
}
