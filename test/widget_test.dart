// Basic widget test for FitLog.
//
// Verifies that the Home screen renders correctly with summary data.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitlog/main.dart';
import 'package:fitlog/repositories/workout_repository.dart';
import 'package:fitlog/models/workout.dart';

class FakeWorkoutRepository extends Fake implements WorkoutRepository {
  @override
  Future<List<Workout>> getAllWorkouts() async {
    return [
      Workout(
        name: 'Morning Run',
        duration: 30,
        calories: 300,
        date: DateTime.now(),
        type: 'Running',
        notes: 'Felt great, steady pace throughout.',
      ),
    ];
  }

  @override
  Future<List<Workout>> getWorkoutsForDate(DateTime date) async {
    return [];
  }

  @override
  Stream<List<Workout>> watchAllWorkouts() {
    return Stream.value([]);
  }
}

void main() {
  testWidgets('Home screen renders FitLog title', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    final repository = FakeWorkoutRepository();

    // Build the FitLog app and trigger a frame.
    await tester.pumpWidget(FitLogApp(repository: repository));

    // Wait for BLoCs to load async data
    await tester.pumpAndSettle();

    // Verify the app title is displayed.
    expect(find.text('FitLog'), findsOneWidget);

    // Verify summary stat labels are present.
    expect(find.text('Total Workouts'), findsOneWidget);
    expect(find.text('Calories Burned'), findsOneWidget);
  });
}

