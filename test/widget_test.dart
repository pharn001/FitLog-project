// Basic widget test for FitLog.
//
// Verifies that the Home screen renders correctly with summary data.

import 'package:flutter_test/flutter_test.dart';

import 'package:fitlog/main.dart';

void main() {
  testWidgets('Home screen renders FitLog title', (WidgetTester tester) async {
    // Build the FitLog app and trigger a frame.
    await tester.pumpWidget(const FitLogApp());

    // Verify the app title is displayed.
    expect(find.text('FitLog'), findsOneWidget);

    // Verify summary stat labels are present.
    expect(find.text('Total Workouts'), findsOneWidget);
    expect(find.text('Calories Burned'), findsOneWidget);
  });
}
