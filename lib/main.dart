// main.dart
//
// Entry point for the FitLog workout tracking application.
// Initialises:
//   • Isar local database
//   • WorkoutRepository
//   • MultiBlocProvider with all four BLoCs
//   • MaterialApp.router with go_router and theme support

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'models/workout.dart';
import 'repositories/workout_repository.dart';
import 'blocs/workout/workout_bloc.dart';
import 'blocs/workout/workout_event.dart';
import 'blocs/theme/theme_bloc.dart';
import 'blocs/theme/theme_event.dart';
import 'blocs/theme/theme_state.dart';
import 'blocs/streak/streak_bloc.dart';
import 'blocs/streak/streak_event.dart';
import 'blocs/timer/timer_bloc.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open Isar database
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [WorkoutSchema],
    directory: dir.path,
  );

  // Seed some sample data if the database is empty
  final count = await isar.workouts.count();
  if (count == 0) {
    await _seedData(isar);
  }

  final repository = WorkoutRepository(isar);

  runApp(FitLogApp(repository: repository));
}

/// Seeds the database with sample workouts for first-time users.
Future<void> _seedData(Isar isar) async {
  final now = DateTime.now();
  final seeds = [
    Workout(
      name: 'Morning Run',
      duration: 30,
      calories: 300,
      date: now.subtract(const Duration(days: 0)),
      type: 'Running',
      notes: 'Felt great, steady pace throughout.',
    ),
    Workout(
      name: 'Weight Training',
      duration: 45,
      calories: 400,
      date: now.subtract(const Duration(days: 1)),
      type: 'Weight Training',
      notes: 'Upper body focus – bench, rows, OHP.',
    ),
    Workout(
      name: 'Evening Swim',
      duration: 60,
      calories: 500,
      date: now.subtract(const Duration(days: 2)),
      type: 'Swimming',
    ),
    Workout(
      name: 'Cycling Session',
      duration: 50,
      calories: 450,
      date: now.subtract(const Duration(days: 3)),
      type: 'Cycling',
      notes: 'Hill intervals.',
    ),
    Workout(
      name: 'Yoga Flow',
      duration: 40,
      calories: 200,
      date: now.subtract(const Duration(days: 4)),
      type: 'Yoga',
    ),
    Workout(
      name: 'HIIT Blast',
      duration: 25,
      calories: 350,
      date: now.subtract(const Duration(days: 5)),
      type: 'HIIT',
      notes: 'Tabata-style intervals.',
    ),
    Workout(
      name: 'Long Run',
      duration: 60,
      calories: 600,
      date: now.subtract(const Duration(days: 6)),
      type: 'Running',
      notes: '10K training run.',
    ),
  ];

  await isar.writeTxn(() async {
    for (final workout in seeds) {
      await isar.workouts.put(workout);
    }
  });
}

/// Root widget of the FitLog application.
class FitLogApp extends StatelessWidget {
  final WorkoutRepository repository;

  const FitLogApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final router = createRouter();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WorkoutBloc(repository: repository)
            ..add(const LoadWorkouts()),
        ),
        BlocProvider(
          create: (_) => ThemeBloc()..add(const LoadTheme()),
        ),
        BlocProvider(
          create: (_) => StreakBloc(repository: repository)
            ..add(const LoadStreak()),
        ),
        BlocProvider(
          create: (_) => TimerBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'FitLog',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeState.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
