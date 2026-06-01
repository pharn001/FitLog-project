// workout_repository.dart
//
// Data-access layer that wraps Isar operations for the [Workout] collection.
// Provides CRUD helpers plus query methods for charts, search and streaks.

import 'package:isar/isar.dart';
import '../models/workout.dart';

class WorkoutRepository {
  final Isar _isar;

  WorkoutRepository(this._isar);

  // ── READ ────────────────────────────────────────────────────────────────

  /// Returns all workouts sorted by date descending (most recent first).
  Future<List<Workout>> getAllWorkouts() async {
    return _isar.workouts.where().sortByDateDesc().findAll();
  }

  /// Returns a single workout by its [id], or `null` if not found.
  Future<Workout?> getWorkoutById(int id) async {
    return _isar.workouts.get(id);
  }

  /// Returns workouts whose [name] contains [query] (case-insensitive).
  Future<List<Workout>> searchWorkouts(String query) async {
    return _isar.workouts
        .filter()
        .nameContains(query, caseSensitive: false)
        .sortByDateDesc()
        .findAll();
  }

  /// Returns workouts filtered by [type].
  Future<List<Workout>> getWorkoutsByType(String type) async {
    return _isar.workouts
        .filter()
        .typeEqualTo(type)
        .sortByDateDesc()
        .findAll();
  }

  /// Returns workouts within the given date range (inclusive).
  Future<List<Workout>> getWorkoutsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return _isar.workouts
        .filter()
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();
  }

  /// Returns workouts for a single calendar date.
  Future<List<Workout>> getWorkoutsForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return _isar.workouts
        .filter()
        .dateGreaterThan(start, include: true)
        .dateLessThan(end)
        .findAll();
  }

  /// Watches all workouts and emits a new list whenever the collection changes.
  Stream<List<Workout>> watchAllWorkouts() {
    return _isar.workouts
        .where()
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  // ── CREATE ──────────────────────────────────────────────────────────────

  /// Inserts a new workout and returns its auto-generated id.
  Future<int> addWorkout(Workout workout) async {
    return _isar.writeTxn(() => _isar.workouts.put(workout));
  }

  // ── UPDATE ──────────────────────────────────────────────────────────────

  /// Updates an existing workout (matched by [Workout.id]).
  Future<int> updateWorkout(Workout workout) async {
    return _isar.writeTxn(() => _isar.workouts.put(workout));
  }

  // ── DELETE ──────────────────────────────────────────────────────────────

  /// Deletes the workout with the given [id]. Returns `true` if it existed.
  Future<bool> deleteWorkout(int id) async {
    return _isar.writeTxn(() => _isar.workouts.delete(id));
  }

  /// Deletes all workouts. Returns the number of deleted documents.
  Future<void> deleteAllWorkouts() async {
    await _isar.writeTxn(() => _isar.workouts.clear());
  }

  // ── AGGREGATE ───────────────────────────────────────────────────────────

  /// Returns the total number of workouts.
  Future<int> getWorkoutCount() async {
    return _isar.workouts.count();
  }

  /// Returns all distinct workout types stored in the database.
  Future<List<String>> getAllTypes() async {
    final workouts = await _isar.workouts.where().findAll();
    return workouts.map((w) => w.type).toSet().toList()..sort();
  }
}
