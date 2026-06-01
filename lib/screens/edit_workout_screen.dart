// edit_workout_screen.dart
//
// A form screen for editing an existing [Workout].
// Pre-fills all fields from the workout loaded by ID.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/workout/workout_bloc.dart';
import '../blocs/workout/workout_event.dart';
import '../blocs/workout/workout_state.dart';
import '../blocs/streak/streak_bloc.dart';
import '../blocs/streak/streak_event.dart';
import '../models/workout.dart';
import '../theme/app_colors.dart';

class EditWorkoutScreen extends StatefulWidget {
  final int workoutId;

  const EditWorkoutScreen({super.key, required this.workoutId});

  @override
  State<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedType = 'Running';
  DateTime? _selectedDate;
  bool _initialized = false;

  static const List<String> _workoutTypes = [
    'Running',
    'Weight Training',
    'Swimming',
    'Cycling',
    'Yoga',
    'HIIT',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _initFromWorkout(Workout workout) {
    if (_initialized) return;
    _initialized = true;
    _nameController.text = workout.name;
    _durationController.text = workout.duration.toString();
    _caloriesController.text = workout.calories.toString();
    _selectedDate = workout.date;
    _dateController.text = _formatDate(workout.date);
    _notesController.text = workout.notes ?? '';
    _selectedType = workout.type;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _save(Workout original) {
    if (_formKey.currentState!.validate()) {
      final updated = original.copyWith(
        name: _nameController.text.trim(),
        duration: int.parse(_durationController.text.trim()),
        calories: int.parse(_caloriesController.text.trim()),
        date: _selectedDate ?? DateTime.now(),
        type: _selectedType,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      context.read<WorkoutBloc>().add(UpdateWorkout(updated));
      context.read<StreakBloc>().add(const LoadStreak());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${updated.name}" ອັບເດດແລ້ວ!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutBloc, WorkoutState>(
      builder: (context, state) {
        if (state is! WorkoutLoaded) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Workout')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final workout = state.allWorkouts
            .where((w) => w.id == widget.workoutId)
            .firstOrNull;

        if (workout == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Workout')),
            body: const Center(child: Text('Workout not found')),
          );
        }

        _initFromWorkout(workout);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Workout'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ──────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.indigoGradient,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.edit, color: Colors.white, size: 32),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Edit workout details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Workout Name ────────────────────────────────
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Workout Name',
                      prefixIcon: Icon(Icons.fitness_center),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a workout name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Workout Type ────────────────────────────────
                  DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Workout Type',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: _workoutTypes
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Row(
                                children: [
                                  Icon(AppColors.iconForType(type),
                                      size: 20,
                                      color: AppColors.colorForType(type)),
                                  const SizedBox(width: 10),
                                  Text(type),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedType = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Duration & Calories ─────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _durationController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Duration (min)',
                            prefixIcon: Icon(Icons.timer),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            if (int.tryParse(value.trim()) == null) {
                              return 'Enter a number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _caloriesController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Calories',
                            prefixIcon: Icon(Icons.local_fire_department),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            if (int.tryParse(value.trim()) == null) {
                              return 'Enter a number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Date ────────────────────────────────────────
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: _pickDate,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Notes ───────────────────────────────────────
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 48),
                        child: Icon(Icons.notes),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Save button ─────────────────────────────────
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => _save(workout),
                      icon: const Icon(Icons.check),
                      label: const Text('Update Workout'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
