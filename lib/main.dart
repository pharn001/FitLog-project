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
import 'models/user_profile.dart';
import 'repositories/workout_repository.dart';
import 'blocs/workout/workout_bloc.dart';
import 'blocs/workout/workout_event.dart';
import 'blocs/theme/theme_bloc.dart';
import 'blocs/theme/theme_event.dart';
import 'blocs/theme/theme_state.dart';
import 'blocs/streak/streak_bloc.dart';
import 'blocs/streak/streak_event.dart';
import 'blocs/timer/timer_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/profile/profile_event.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open Isar database
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [WorkoutSchema, UserProfileSchema],
    directory: dir.path,
  );

  // Seed some sample data if the database is empty
  final count = await isar.workouts.count();
  if (count == 0) {
    await _seedData(isar);
  }

  final repository = WorkoutRepository(isar);

  runApp(FitLogApp(repository: repository, isar: isar));
}

/// Seeds the database with sample workouts for first-time users.
Future<void> _seedData(Isar isar) async {
  final now = DateTime.now();
  final seeds = [
    Workout(
      name: 'ແລ່ນຕອນເຊົ້າ',
      duration: 30,
      calories: 300,
      date: now.subtract(const Duration(days: 0)),
      type: 'Running',
      notes: 'ຮູ້ສຶກດີຫຼາຍ, ຮັກສາຄວາມໄວສະໝ່ຳສະເໝີຕະຫຼອດການແລ່ນ.',
    ),
    Workout(
      name: 'ຍົກນ້ຳໜັກ',
      duration: 45,
      calories: 400,
      date: now.subtract(const Duration(days: 1)),
      type: 'Weight Training',
      notes: 'ເນັ້ນສ່ວນເທິງຂອງຮ່າງກາຍ - bench, rows, OHP.',
    ),
    Workout(
      name: 'ລອຍນ້ຳຕອນແລງ',
      duration: 60,
      calories: 500,
      date: now.subtract(const Duration(days: 2)),
      type: 'Swimming',
    ),
    Workout(
      name: 'ປັ່ນລົດຖີບ',
      duration: 50,
      calories: 450,
      date: now.subtract(const Duration(days: 3)),
      type: 'Cycling',
      notes: 'ຝຶກແລ່ນຂຶ້ນເນີນສູງ.',
    ),
    Workout(
      name: 'ໂຍຄະ',
      duration: 40,
      calories: 200,
      date: now.subtract(const Duration(days: 4)),
      type: 'Yoga',
    ),
    Workout(
      name: 'ຄາດິໂອ (HIIT)',
      duration: 25,
      calories: 350,
      date: now.subtract(const Duration(days: 5)),
      type: 'HIIT',
      notes: 'ຝຶກແບບທາບາຕາ.',
    ),
    Workout(
      name: 'ແລ່ນໄລຍະໄກ',
      duration: 60,
      calories: 600,
      date: now.subtract(const Duration(days: 6)),
      type: 'Running',
      notes: 'ແລ່ນຊ້ອມ 10 ກິໂລແມັດ.',
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
  final Isar? isar;

  const FitLogApp({
    super.key,
    required this.repository,
    this.isar,
  });

  @override
  Widget build(BuildContext context) {
    final router = createRouter();

    final providers = [
      BlocProvider<WorkoutBloc>(
        create: (_) => WorkoutBloc(repository: repository)
          ..add(const LoadWorkouts()),
      ),
      BlocProvider<ThemeBloc>(
        create: (_) => ThemeBloc()..add(const LoadTheme()),
      ),
      BlocProvider<StreakBloc>(
        create: (_) => StreakBloc(repository: repository)
          ..add(const LoadStreak()),
      ),
      BlocProvider<TimerBloc>(
        create: (_) => TimerBloc(),
      ),
      BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(isar: isar)..add(const LoadProfile()),
      ),
    ];

    return MultiBlocProvider(
      providers: providers,
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
