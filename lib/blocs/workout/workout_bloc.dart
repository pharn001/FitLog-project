// workout_bloc.dart
//
// Business logic component for managing [Workout] data.
// Receives [WorkoutEvent]s and emits [WorkoutState]s after performing
// repository operations.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/workout_repository.dart';
import 'workout_event.dart';
import 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutRepository _repository;

  WorkoutBloc({required WorkoutRepository repository})
      : _repository = repository,
        super(const WorkoutInitial()) {
    on<LoadWorkouts>(_onLoadWorkouts);
    on<AddWorkout>(_onAddWorkout);
    on<UpdateWorkout>(_onUpdateWorkout);
    on<DeleteWorkout>(_onDeleteWorkout);
    on<SearchWorkouts>(_onSearchWorkouts);
    on<FilterByType>(_onFilterByType);
  }

  // ── Handlers ─────────────────────────────────────────────────────────

  Future<void> _onLoadWorkouts(
    LoadWorkouts event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(const WorkoutLoading());
    try {
      final workouts = await _repository.getAllWorkouts();
      emit(WorkoutLoaded(allWorkouts: workouts, workouts: workouts));
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onAddWorkout(
    AddWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      await _repository.addWorkout(event.workout);
      add(const LoadWorkouts());
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onUpdateWorkout(
    UpdateWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      await _repository.updateWorkout(event.workout);
      add(const LoadWorkouts());
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onDeleteWorkout(
    DeleteWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      await _repository.deleteWorkout(event.id);
      add(const LoadWorkouts());
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> _onSearchWorkouts(
    SearchWorkouts event,
    Emitter<WorkoutState> emit,
  ) async {
    final currentState = state;
    if (currentState is WorkoutLoaded) {
      final query = event.query.trim();
      if (query.isEmpty && currentState.activeFilter == null) {
        emit(WorkoutLoaded(
          allWorkouts: currentState.allWorkouts,
          workouts: currentState.allWorkouts,
          searchQuery: '',
        ));
      } else {
        try {
          var results = currentState.allWorkouts;

          // Apply search
          if (query.isNotEmpty) {
            results = results
                .where((w) => w.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
          }

          // Apply type filter
          if (currentState.activeFilter != null) {
            results = results
                .where((w) => w.type == currentState.activeFilter)
                .toList();
          }

          emit(WorkoutLoaded(
            allWorkouts: currentState.allWorkouts,
            workouts: results,
            activeFilter: currentState.activeFilter,
            searchQuery: query,
          ));
        } catch (e) {
          emit(WorkoutError(e.toString()));
        }
      }
    }
  }

  Future<void> _onFilterByType(
    FilterByType event,
    Emitter<WorkoutState> emit,
  ) async {
    final currentState = state;
    if (currentState is WorkoutLoaded) {
      var results = currentState.allWorkouts;

      // Apply search query
      if (currentState.searchQuery.isNotEmpty) {
        results = results
            .where((w) =>
                w.name.toLowerCase().contains(currentState.searchQuery.toLowerCase()))
            .toList();
      }

      // Apply type filter
      if (event.type != null) {
        results = results.where((w) => w.type == event.type).toList();
      }

      emit(WorkoutLoaded(
        allWorkouts: currentState.allWorkouts,
        workouts: results,
        activeFilter: event.type,
        searchQuery: currentState.searchQuery,
      ));
    }
  }
}
