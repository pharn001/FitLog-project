// workout_card.dart
//
// A reusable card widget for displaying a workout in a list.
// Supports tap, long-press, and swipe-to-dismiss interactions.

import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../theme/app_colors.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDismissed;

  const WorkoutCard({
    super.key,
    required this.workout,
    this.onTap,
    this.onLongPress,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = AppColors.colorForType(workout.type);

    Widget card = Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: typeColor.withValues(alpha: isDark ? 0.25 : 0.12),
          child: Icon(
            AppColors.iconForType(workout.type),
            color: typeColor,
          ),
        ),
        title: Text(
          workout.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${workout.formattedDate}  •  ${workout.duration} ນາທີ',
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${workout.calories} kcal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.orange.shade300 : Colors.orange.shade800,
              fontSize: 13,
            ),
          ),
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );

    if (onDismissed != null) {
      card = Dismissible(
        key: ValueKey(workout.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (_) async {
          return await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('ລຶບ Workout?'),
              content: Text('ເຈົ້າຕ້ອງການລຶບ "${workout.name}" ຫຼືບໍ່?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('ຍົກເລີກ'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('ລຶບ'),
                ),
              ],
            ),
          );
        },
        onDismissed: (_) => onDismissed!(),
        child: card,
      );
    }

    return card;
  }
}
