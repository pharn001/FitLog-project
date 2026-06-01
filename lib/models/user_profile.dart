// user_profile.dart
//
// Isar collection schema for the [UserProfile] data model.
// Stores user body metrics (gender, weight, height, age) along with
// activity level and fitness goal. Provides computed nutritional
// targets (BMR, TDEE, daily macros) using the Mifflin-St Jeor equation.

import 'package:isar/isar.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  /// Auto-incremented primary key managed by Isar.
  Id id = Isar.autoIncrement;

  /// Gender: 'male' or 'female'.
  late String gender;

  /// Body weight in kilograms.
  late double weight;

  /// Height in centimetres.
  late double height;

  /// Age in years.
  late int age;

  /// Physical activity level.
  /// One of: 'sedentary', 'light', 'moderate', 'active', 'veryActive'.
  late String activityLevel;

  /// Fitness goal.
  /// One of: 'lose', 'maintain', 'gain'.
  late String goal;

  /// Timestamp of the last profile update.
  @Index()
  late DateTime updatedAt;

  /// Creates a [UserProfile] instance.
  UserProfile({
    this.id = Isar.autoIncrement,
    required this.gender,
    required this.weight,
    required this.height,
    required this.age,
    required this.activityLevel,
    required this.goal,
    required this.updatedAt,
  });

  // ── Computed Nutritional Targets ──────────────────────────────────────

  /// Basal Metabolic Rate using the Mifflin-St Jeor equation.
  ///
  /// Male  : BMR = 10 × weight(kg) + 6.25 × height(cm) − 5 × age + 5
  /// Female: BMR = 10 × weight(kg) + 6.25 × height(cm) − 5 × age − 161
  double get bmr {
    if (gender == 'male') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    }
  }

  /// Activity multiplier based on [activityLevel].
  double get _activityFactor {
    switch (activityLevel) {
      case 'sedentary':
        return 1.2;
      case 'light':
        return 1.375;
      case 'moderate':
        return 1.55;
      case 'active':
        return 1.725;
      case 'veryActive':
        return 1.9;
      default:
        return 1.2;
    }
  }

  /// Total Daily Energy Expenditure (BMR × activity factor).
  double get tdee => bmr * _activityFactor;

  /// Calorie target adjusted for the user's [goal].
  ///   • lose     → TDEE − 500 kcal
  ///   • gain     → TDEE + 300 kcal
  ///   • maintain → TDEE
  double get adjustedCalories {
    switch (goal) {
      case 'lose':
        return tdee - 500;
      case 'gain':
        return tdee + 300;
      default:
        return tdee;
    }
  }

  /// Daily protein target in grams (30 % of calories, 4 kcal/g).
  double get proteinGrams => (adjustedCalories * 0.30) / 4;

  /// Daily carbohydrate target in grams (40 % of calories, 4 kcal/g).
  double get carbsGrams => (adjustedCalories * 0.40) / 4;

  /// Daily fat target in grams (30 % of calories, 9 kcal/g).
  double get fatGrams => (adjustedCalories * 0.30) / 9;

  /// Body Mass Index.
  double get bmi => weight / ((height / 100) * (height / 100));

  /// Creates a copy with optionally modified fields.
  UserProfile copyWith({
    Id? id,
    String? gender,
    double? weight,
    double? height,
    int? age,
    String? activityLevel,
    String? goal,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'UserProfile(id: $id, gender: $gender, weight: $weight, height: $height, '
      'age: $age, activity: $activityLevel, goal: $goal, '
      'TDEE: ${tdee.round()}, BMI: ${bmi.toStringAsFixed(1)})';
}
