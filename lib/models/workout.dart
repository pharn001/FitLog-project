// workout.dart
//
// This file defines the [Workout] data model used throughout the FitLog app.
// Each Workout instance represents a single exercise session recorded by the
// user, containing metadata such as name, duration, calorie expenditure,
// date, optional notes, and the type of workout performed.

class Workout {
  /// The display name of the workout (e.g. "Morning Run").
  final String name;

  /// Duration of the workout in minutes.
  final int duration;

  /// Estimated calories burned during the workout.
  final int calories;

  /// Date of the workout as a formatted string (e.g. "2026-05-30").
  final String date;

  /// Optional notes or description the user can attach to the workout.
  final String? notes;

  /// Category / type of workout (e.g. 'Running', 'Weight Training', 'Swimming').
  final String type;

  /// Creates a [Workout] instance.
  ///
  /// All fields except [notes] are required.
  const Workout({
    required this.name,
    required this.duration,
    required this.calories,
    required this.date,
    this.notes,
    required this.type,
  });
}
