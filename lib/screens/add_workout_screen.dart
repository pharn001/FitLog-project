// add_workout_screen.dart
//
// A form-driven screen that lets the user create a new [Workout].
// It uses a [Form] widget with a [GlobalKey<FormState>] to validate all
// fields before saving. On successful validation the new workout is
// returned to the previous screen via [Navigator.pop].
//
// This is a StatefulWidget because it manages form field controllers and
// the selected workout type, which are mutable state.

import 'package:flutter/material.dart';
import '../models/workout.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  // Global key used to validate and save the form.
  final _formKey = GlobalKey<FormState>();

  // Controllers for each text field.
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

  // The currently selected workout type (dropdown).
  String _selectedType = 'Running';

  // Available workout types.
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
    // Clean up controllers when the widget is removed from the tree.
    _nameController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------
  // Date picker helper – opens a Material date picker and fills the field.
  // ------------------------------------------------------------------
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  // ------------------------------------------------------------------
  // Build
  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Workout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      // SingleChildScrollView prevents overflow when the keyboard appears.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------- Header ----------
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Log a new workout session',
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

              // ---------- Workout Name ----------
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Workout Name',
                  hintText: 'e.g. Morning Run',
                  prefixIcon: const Icon(Icons.fitness_center),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a workout name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---------- Workout Type dropdown ----------
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Workout Type',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _workoutTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // ---------- Duration & Calories (side by side) ----------
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Duration (min)',
                        prefixIcon: const Icon(Icons.timer),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                      decoration: InputDecoration(
                        labelText: 'Calories',
                        prefixIcon: const Icon(Icons.local_fire_department),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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

              // ---------- Date ----------
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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

              // ---------- Notes (optional) ----------
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes (optional)',
                  hintText: 'Any additional info…',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(Icons.notes),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ---------- Save button ----------
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Validate all form fields.
                    if (_formKey.currentState!.validate()) {
                      // Build the new Workout and pop it back.
                      final newWorkout = Workout(
                        name: _nameController.text.trim(),
                        duration: int.parse(_durationController.text.trim()),
                        calories: int.parse(_caloriesController.text.trim()),
                        date: _dateController.text.trim(),
                        type: _selectedType,
                        notes: _notesController.text.trim().isEmpty
                            ? null
                            : _notesController.text.trim(),
                      );
                      Navigator.pop(context, newWorkout);
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Save Workout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
