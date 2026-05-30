// history_screen.dart
//
// Displays a searchable list of all recorded workouts. Users can:
//   • Search / filter workouts by name using a TextField.
//   • Tap a workout card to navigate to the Detail screen.
//   • Add a new workout via the FloatingActionButton.
//
// This is a StatefulWidget because the workout list and the search query
// are mutable state that trigger UI rebuilds via setState.

import 'package:flutter/material.dart';
import '../models/workout.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // ------------------------------------------------------------------
  // State: master workout list and the current search query.
  // ------------------------------------------------------------------

  /// The full, unfiltered list of workouts.
  final List<Workout> _workouts = [
    const Workout(
      name: 'Morning Run',
      duration: 30,
      calories: 300,
      date: '2026-05-28',
      type: 'Running',
      notes: 'Felt great, steady pace throughout.',
    ),
    const Workout(
      name: 'Weight Training',
      duration: 45,
      calories: 400,
      date: '2026-05-27',
      type: 'Weight Training',
      notes: 'Upper body focus – bench, rows, OHP.',
    ),
    const Workout(
      name: 'Evening Swim',
      duration: 60,
      calories: 500,
      date: '2026-05-26',
      type: 'Swimming',
    ),
    const Workout(
      name: 'Cycling Session',
      duration: 50,
      calories: 450,
      date: '2026-05-25',
      type: 'Cycling',
      notes: 'Hill intervals.',
    ),
    const Workout(
      name: 'Yoga Flow',
      duration: 40,
      calories: 200,
      date: '2026-05-24',
      type: 'Yoga',
    ),
  ];

  /// Current search/filter query entered by the user.
  String _searchQuery = '';

  /// Returns the list of workouts filtered by the current search query.
  List<Workout> get _filteredWorkouts {
    if (_searchQuery.isEmpty) return _workouts;
    return _workouts
        .where(
          (w) => w.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  // ------------------------------------------------------------------
  // Helper – returns an appropriate icon for a workout type.
  // ------------------------------------------------------------------
  IconData _iconForType(String type) {
    switch (type) {
      case 'Running':
        return Icons.directions_run;
      case 'Weight Training':
        return Icons.fitness_center;
      case 'Swimming':
        return Icons.pool;
      case 'Cycling':
        return Icons.directions_bike;
      case 'Yoga':
        return Icons.self_improvement;
      default:
        return Icons.sports;
    }
  }

  // ------------------------------------------------------------------
  // Build
  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final filtered = _filteredWorkouts;

    return Scaffold(
      // AppBar with title
      appBar: AppBar(
        title: const Text(
          'Workout History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: Column(
        children: [
          // ---- Search / filter TextField ----
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search workouts…',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.teal.shade50,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                // Update state so the list re-renders with filtered results.
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // ---- Workout list ----
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'No workouts found',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final workout = filtered[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          // Leading icon based on workout type
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade50,
                            child: Icon(
                              _iconForType(workout.type),
                              color: Colors.teal,
                            ),
                          ),
                          // Workout name + date
                          title: Text(
                            workout.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${workout.date}  •  ${workout.duration} min',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                          // Calories trailing
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${workout.calories} kcal',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          // Navigate to detail screen on tap
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: workout,
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ---- FAB → navigate to Add Workout screen ----
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Await the result from the Add Workout screen.
          final newWorkout = await Navigator.pushNamed(context, '/add');
          if (newWorkout is Workout) {
            // Add the new workout and refresh the list.
            setState(() {
              _workouts.insert(0, newWorkout);
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Workout'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }
}
