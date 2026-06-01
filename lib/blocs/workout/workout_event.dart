// workout_event.dart
//
// Events dispatched to [WorkoutBloc].

import 'package:equatable/equatable.dart';
import '../../models/workout.dart';

/// Base class for all workout-related events.
sealed class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object?> get props => [];
}

/// Load all workouts from the repository.
class LoadWorkouts extends WorkoutEvent {
  const LoadWorkouts();
}

/// Add a new workout.
class AddWorkout extends WorkoutEvent {
  final Workout workout;
  const AddWorkout(this.workout);

  @override
  List<Object?> get props => [workout];
}

/// Update an existing workout.
class UpdateWorkout extends WorkoutEvent {
  final Workout workout;
  const UpdateWorkout(this.workout);

  @override
  List<Object?> get props => [workout];
}

/// Delete a workout by its id.
class DeleteWorkout extends WorkoutEvent {
  final int id;
  const DeleteWorkout(this.id);

  @override
  List<Object?> get props => [id];
}

/// Search workouts by name.
class SearchWorkouts extends WorkoutEvent {
  final String query;
  const SearchWorkouts(this.query);

  @override
  List<Object?> get props => [query];
}

/// Filter workouts by type. Pass `null` to clear the filter.
class FilterByType extends WorkoutEvent {
  final String? type;
  const FilterByType(this.type);

  @override
  List<Object?> get props => [type];
}
