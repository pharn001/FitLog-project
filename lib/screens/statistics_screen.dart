// statistics_screen.dart
//
// Displays workout analytics using fl_chart:
//   • Bar chart — calories over the last 7 days
//   • Line chart — weekly duration trend
//   • Pie chart — workout type distribution
// Also shows summary metric cards.

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/workout/workout_bloc.dart';
import '../blocs/workout/workout_state.dart';
import '../models/workout.dart';
import '../theme/app_colors.dart';
import '../widgets/stat_card.dart';
import '../utils/translation_helper.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedDays = 7; // 7, 30, or 0 (all)

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('ສະຖິຕິ')),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is! WorkoutLoaded || state.allWorkouts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bar_chart, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'ຍັງບໍ່ມີຂໍ້ມູນສະຖິຕິ\nເພີ່ມ Workout ເພື່ອເບິ່ງກຣາຟ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final allWorkouts = state.allWorkouts;
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          // Filter workouts by selected range
          final filtered = _selectedDays == 0
              ? allWorkouts
              : allWorkouts.where((w) {
                  final wDate = DateTime(w.date.year, w.date.month, w.date.day);
                  return wDate.isAfter(
                      today.subtract(Duration(days: _selectedDays)));
                }).toList();

          // Summary stats
          final totalCals =
              filtered.fold<int>(0, (sum, w) => sum + w.calories);
          final totalMins =
              filtered.fold<int>(0, (sum, w) => sum + w.duration);
          final avgCals = filtered.isEmpty
              ? 0
              : (totalCals / filtered.length).round();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Time Range Toggle ────────────────────────────
                Row(
                  children: [
                    _RangeChip(
                      label: '7 ວັນ',
                      selected: _selectedDays == 7,
                      onTap: () => setState(() => _selectedDays = 7),
                    ),
                    const SizedBox(width: 8),
                    _RangeChip(
                      label: '30 ວັນ',
                      selected: _selectedDays == 30,
                      onTap: () => setState(() => _selectedDays = 30),
                    ),
                    const SizedBox(width: 8),
                    _RangeChip(
                      label: 'ທັງໝົດ',
                      selected: _selectedDays == 0,
                      onTap: () => setState(() => _selectedDays = 0),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Summary Cards ────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.fitness_center,
                        label: 'ການອອກກຳລັງກາຍ',
                        value: '${filtered.length}',
                        gradient: const LinearGradient(
                          colors: AppColors.tealGradient,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.local_fire_department,
                        label: 'ແຄລໍຣີສະເລ່ຍ',
                        value: '$avgCals kcal',
                        gradient: const LinearGradient(
                          colors: AppColors.orangeGradient,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                StatCard(
                  icon: Icons.timer,
                  label: 'ເວລາທັງໝົດ',
                  value: '$totalMins ນາທີ',
                  gradient: const LinearGradient(
                    colors: AppColors.indigoGradient,
                  ),
                ),
                const SizedBox(height: 28),

                // ── Bar Chart: Calories ──────────────────────────
                _SectionTitle(title: '🔥 ແຄລໍຣີລາຍວັນ'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: _CaloriesBarChart(
                    workouts: filtered,
                    days: _selectedDays == 0 ? 7 : _selectedDays,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(height: 28),

                // ── Pie Chart: Type Distribution ─────────────────
                _SectionTitle(title: '📊 ປະເພດການອອກກຳລັງກາຍ'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: _TypePieChart(workouts: filtered, isDark: isDark),
                ),
                const SizedBox(height: 28),

                // ── Line Chart: Duration Trend ───────────────────
                _SectionTitle(title: '📈 ແນວໂນ້ມໄລຍະເວລາ'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: _DurationLineChart(
                    workouts: filtered,
                    days: _selectedDays == 0 ? 7 : _selectedDays,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Section Title ────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

// ── Range Chip ───────────────────────────────────────────────────────────
class _RangeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RangeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkCard
                  : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : null,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── Bar Chart: Calories per day ──────────────────────────────────────────
class _CaloriesBarChart extends StatelessWidget {
  final List<Workout> workouts;
  final int days;
  final bool isDark;

  const _CaloriesBarChart({
    required this.workouts,
    required this.days,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final displayDays = days.clamp(1, 7);

    // Aggregate calories per day
    final Map<int, int> dailyCals = {};
    for (int i = 0; i < displayDays; i++) {
      dailyCals[i] = 0;
    }
    for (final w in workouts) {
      final wDate = DateTime(w.date.year, w.date.month, w.date.day);
      final diff = today.difference(wDate).inDays;
      if (diff >= 0 && diff < displayDays) {
        dailyCals[diff] = (dailyCals[diff] ?? 0) + w.calories;
      }
    }

    final maxY = dailyCals.values.fold<int>(0, (a, b) => a > b ? a : b);

    final weekDays = ['ອາ.', 'ຈ.', 'ອ.', 'ພ.', 'ພຫ.', 'ສຸ.', 'ສ.'];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY > 0 ? maxY * 1.2 : 500,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toInt()} kcal',
                const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final dayIndex = value.toInt();
                if (dayIndex < 0 || dayIndex >= displayDays) {
                  return const SizedBox.shrink();
                }
                final date = today.subtract(Duration(days: displayDays - 1 - dayIndex));
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    weekDays[date.weekday % 7],
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(displayDays, (i) {
          final cals = dailyCals[displayDays - 1 - i] ?? 0;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: cals.toDouble(),
                gradient: const LinearGradient(
                  colors: AppColors.orangeGradient,
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 18,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ── Pie Chart: Workout Type Distribution ─────────────────────────────────
class _TypePieChart extends StatelessWidget {
  final List<Workout> workouts;
  final bool isDark;

  const _TypePieChart({required this.workouts, required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Count by type
    final Map<String, int> typeCounts = {};
    for (final w in workouts) {
      typeCounts[w.type] = (typeCounts[w.type] ?? 0) + 1;
    }

    if (typeCounts.isEmpty) {
      return const Center(child: Text('ບໍ່ມີຂໍ້ມູນ'));
    }

    final total = workouts.length;
    final entries = typeCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Row(
      children: [
        // Chart
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: entries.map((e) {
                final pct = (e.value / total * 100).round();
                final color = AppColors.colorForType(e.key);
                return PieChartSectionData(
                  value: e.value.toDouble(),
                  title: '$pct%',
                  color: color,
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // Legend
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.colorForType(e.key),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${translateWorkoutType(e.key)} (${e.value})',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Line Chart: Duration Trend ───────────────────────────────────────────
class _DurationLineChart extends StatelessWidget {
  final List<Workout> workouts;
  final int days;
  final bool isDark;

  const _DurationLineChart({
    required this.workouts,
    required this.days,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final displayDays = days.clamp(1, 7);

    // Aggregate duration per day
    final Map<int, int> dailyDuration = {};
    for (int i = 0; i < displayDays; i++) {
      dailyDuration[i] = 0;
    }
    for (final w in workouts) {
      final wDate = DateTime(w.date.year, w.date.month, w.date.day);
      final diff = today.difference(wDate).inDays;
      if (diff >= 0 && diff < displayDays) {
        dailyDuration[diff] = (dailyDuration[diff] ?? 0) + w.duration;
      }
    }

    final maxY =
        dailyDuration.values.fold<int>(0, (a, b) => a > b ? a : b);

    final spots = List.generate(displayDays, (i) {
      return FlSpot(
        i.toDouble(),
        (dailyDuration[displayDays - 1 - i] ?? 0).toDouble(),
      );
    });

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY > 0 ? maxY * 1.3 : 60,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 8,
            getTooltipItems: (spots) {
              return spots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toInt()} min',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
        titlesData: const FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            gradient: const LinearGradient(
              colors: AppColors.tealGradient,
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 4,
                color: AppColors.primary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
