// workout_state.dart
//
// States emitted by [WorkoutBloc].

import 'package:equatable/equatable.dart';
import '../../models/workout.dart';

/// Base class for all workout-related states.
sealed class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data has been loaded.
class WorkoutInitial extends WorkoutState {
  const WorkoutInitial();
}

/// Data is being fetched from the repository.
class WorkoutLoading extends WorkoutState {
  const WorkoutLoading();
}

/// Workouts have been successfully loaded.
class WorkoutLoaded extends WorkoutState {
  /// The full unfiltered workout list.
  final List<Workout> allWorkouts;

  /// The currently displayed (possibly filtered/searched) workout list.
  final List<Workout> workouts;

  /// Active type filter, or `null` if none.
  final String? activeFilter;

  /// Active search query.
  final String searchQuery;

  const WorkoutLoaded({
    required this.allWorkouts,
    required this.workouts,
    this.activeFilter,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [allWorkouts, workouts, activeFilter, searchQuery];

  /// Convenience: total workouts count.
  int get totalWorkouts => allWorkouts.length;

  /// Convenience: sum of all calories.
  int get totalCalories =>
      allWorkouts.fold<int>(0, (sum, w) => sum + w.calories);

  /// Convenience: sum of all duration minutes.
  int get totalMinutes =>
      allWorkouts.fold<int>(0, (sum, w) => sum + w.duration);

  /// Convenience: most recent workouts (up to [n]).
  List<Workout> recentWorkouts([int n = 3]) =>
      allWorkouts.take(n).toList();
}

/// An error occurred while loading or mutating workouts.
class WorkoutError extends WorkoutState {
  final String message;
  const WorkoutError(this.message);

  @override
  List<Object?> get props => [message];
}
