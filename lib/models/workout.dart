// workout.dart
//
// Isar collection schema for the [Workout] data model.
// Each Workout instance represents a single exercise session recorded by the
// user, containing metadata such as name, duration, calorie expenditure,
// date, optional notes, and the type of workout performed.

import 'package:isar/isar.dart';

part 'workout.g.dart';

@collection
class Workout {
  /// Auto-incremented primary key managed by Isar.
  Id id = Isar.autoIncrement;

  /// The display name of the workout (e.g. "Morning Run").
  late String name;

  /// Duration of the workout in minutes.
  late int duration;

  /// Estimated calories burned during the workout.
  late int calories;

  /// Date and time of the workout.
  @Index()
  late DateTime date;

  /// Optional notes or description the user can attach to the workout.
  String? notes;

  /// Category / type of workout (e.g. 'Running', 'Weight Training', 'Swimming').
  @Index()
  late String type;

  /// Creates a [Workout] instance.
  Workout({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.duration,
    required this.calories,
    required this.date,
    this.notes,
    required this.type,
  });

  /// Creates a copy of this workout with optionally modified fields.
  Workout copyWith({
    Id? id,
    String? name,
    int? duration,
    int? calories,
    DateTime? date,
    String? notes,
    String? type,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      calories: calories ?? this.calories,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      type: type ?? this.type,
    );
  }

  /// Formatted date string (e.g. "2026-05-30").
  String get formattedDate =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  String toString() =>
      'Workout(id: $id, name: $name, type: $type, date: $formattedDate)';
}
