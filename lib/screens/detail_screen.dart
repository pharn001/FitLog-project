// detail_screen.dart
//
// Displays the full details of a single [Workout] that was passed as a
// route argument. A Stack-based header banner shows the workout name and
// type over a gradient, while a Column below lists every field.
//
// This is a StatelessWidget because it only reads data passed via the
// route arguments and does not manage any mutable state.

import 'package:flutter/material.dart';
import '../models/workout.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  // Helper – returns an icon based on the workout type.
  static IconData _iconForType(String type) {
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

  @override
  Widget build(BuildContext context) {
    // Retrieve the Workout object passed via Navigator arguments.
    final workout =
        ModalRoute.of(context)!.settings.arguments as Workout;

    return Scaffold(
      // AppBar with title
      appBar: AppBar(
        title: const Text(
          'Workout Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ----------------------------------------------------------
            // Header banner using Stack for layered layout
            // ----------------------------------------------------------
            Stack(
              children: [
                // Background gradient container
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                ),
                // Foreground content positioned on top of the gradient
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Workout type icon
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _iconForType(workout.type),
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Workout name
                        Text(
                          workout.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Workout type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            workout.type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------------
            // Detail cards
            // ----------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Quick stats row
                  Row(
                    children: [
                      Expanded(
                        child: _QuickStatCard(
                          icon: Icons.timer,
                          label: 'Duration',
                          value: '${workout.duration} min',
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickStatCard(
                          icon: Icons.local_fire_department,
                          label: 'Calories',
                          value: '${workout.calories} kcal',
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Date card
                  _DetailRow(
                    icon: Icons.calendar_today,
                    label: 'Date',
                    value: workout.date,
                  ),

                  const SizedBox(height: 12),

                  // Notes card
                  _DetailRow(
                    icon: Icons.notes,
                    label: 'Notes',
                    value: workout.notes ?? 'No notes for this workout.',
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _QuickStatCard — compact stat card used in the top row of the detail view.
// ---------------------------------------------------------------------------
class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QuickStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _DetailRow — a labeled row showing a single piece of workout information.
// ---------------------------------------------------------------------------
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
