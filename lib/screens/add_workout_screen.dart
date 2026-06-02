// add_workout_screen.dart
//
// A form-driven screen that lets the user create a new [Workout].
// Saves via WorkoutBloc and optionally accepts an initial duration
// from the Timer screen.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/workout/workout_bloc.dart';
import '../blocs/workout/workout_event.dart';
import '../blocs/streak/streak_bloc.dart';
import '../blocs/streak/streak_event.dart';
import '../models/workout.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';
import '../utils/translation_helper.dart';

class AddWorkoutScreen extends StatefulWidget {
  final int? initialDuration;

  const AddWorkoutScreen({super.key, this.initialDuration});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedType = 'Running';
  DateTime? _selectedDate;

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
  void initState() {
    super.initState();
    if (widget.initialDuration != null) {
      _durationController.text = widget.initialDuration.toString();
    }
    // Default to today
    _selectedDate = DateTime.now();
    _dateController.text = _formatDate(_selectedDate!);
  }

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

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newWorkout = Workout(
        name: _nameController.text.trim(),
        duration: int.parse(_durationController.text.trim()),
        calories: int.parse(_caloriesController.text.trim()),
        date: _selectedDate ?? DateTime.now(),
        type: _selectedType,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      context.read<WorkoutBloc>().add(AddWorkout(newWorkout));
      context.read<StreakBloc>().add(const LoadStreak());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${newWorkout.name}" ບັນທຶກແລ້ວ!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ເພີ່ມການອອກກຳລັງກາຍ'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Timer shortcut
          IconButton(
            icon: const Icon(Icons.timer),
            tooltip: 'ເຄື່ອງຈັບເວລາອອກກຳລັງກາຍ',
            onPressed: () => context.push(AppRoutes.timer),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.tealGradient,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add_circle_outline,
                        color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'ບັນທຶກການອອກກຳລັງກາຍໃໝ່',
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

              // ── Workout Name ────────────────────────────────────
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'ຊື່ການອອກກຳລັງກາຍ',
                  hintText: 'ຕົວຢ່າງ: ແລ່ນຕອນເຊົ້າ',
                  prefixIcon: Icon(Icons.fitness_center),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'ກະລຸນາປ້ອນຊື່ການອອກກຳລັງກາຍ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Workout Type ────────────────────────────────────
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'ປະເພດການອອກກຳລັງກາຍ',
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
                              Text(translateWorkoutType(type)),
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

              // ── Duration & Calories ─────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'ໄລຍະເວລາ (ນາທີ)',
                        prefixIcon: Icon(Icons.timer),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'ກະລຸນາປ້ອນຂໍ້ມູນ';
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return 'ກະລຸນາປ້ອນຕົວເລກ';
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
                        labelText: 'ແຄລໍຣີ (kcal)',
                        prefixIcon: Icon(Icons.local_fire_department),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'ກະລຸນາປ້ອນຂໍ້ມູນ';
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return 'ກະລຸນາປ້ອນຕົວເລກ';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Date ────────────────────────────────────────────
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'ວັນທີ',
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _pickDate,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'ກະລຸນາເລືອກວັນທີ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Notes ───────────────────────────────────────────
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'ໝາຍເຫດ (ເລືອກໄດ້)',
                  hintText: 'ຂໍ້ມູນເພີ່ມເຕີມ...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(Icons.notes),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Save button ─────────────────────────────────────
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('ບັນທຶກການອອກກຳລັງກາຍ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
