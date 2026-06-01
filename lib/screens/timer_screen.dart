// timer_screen.dart
//
// Workout Timer/Stopwatch screen.
// Displays a large circular progress indicator with start/pause/resume/reset
// controls. After stopping, offers to save the elapsed time as a new workout.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/timer/timer_bloc.dart';
import '../blocs/timer/timer_event.dart';
import '../blocs/timer/timer_state.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Timer'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [AppColors.darkBackground, const Color(0xFF0A1A1A)]
                    : [AppColors.lightBackground, Colors.white],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Circular Timer Display ───────────────────────
                SizedBox(
                  width: 260,
                  height: 260,
                  child: CustomPaint(
                    painter: _TimerPainter(
                      elapsedSeconds: state.elapsedSeconds,
                      isRunning: state.isRunning,
                      isDark: isDark,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.formatted,
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                              color: isDark ? Colors.white : Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.isRunning
                                ? '⏱ ກຳລັງຈັບເວລາ...'
                                : state.isPaused
                                    ? '⏸ ຢຸດຊົ່ວຄາວ'
                                    : '▶ ພ້ອມເລີ່ມ',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // ── Controls ─────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Reset button
                    if (!state.isInitial)
                      _ControlButton(
                        icon: Icons.stop,
                        label: 'Reset',
                        color: Colors.red.shade400,
                        onPressed: () =>
                            context.read<TimerBloc>().add(const ResetTimer()),
                      ),

                    if (!state.isInitial) const SizedBox(width: 24),

                    // Start / Pause / Resume
                    _ControlButton(
                      icon: state.isRunning
                          ? Icons.pause
                          : Icons.play_arrow,
                      label: state.isRunning
                          ? 'Pause'
                          : state.isPaused
                              ? 'Resume'
                              : 'Start',
                      color: state.isRunning
                          ? Colors.orange.shade600
                          : AppColors.primary,
                      size: 72,
                      iconSize: 36,
                      onPressed: () {
                        final bloc = context.read<TimerBloc>();
                        if (state.isRunning) {
                          bloc.add(const PauseTimer());
                        } else if (state.isPaused) {
                          bloc.add(const ResumeTimer());
                        } else {
                          bloc.add(const StartTimer());
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ── Save button (visible when paused with time > 0) ─
                if (state.isPaused && state.elapsedSeconds > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final minutes = state.elapsedMinutes;
                          context.read<TimerBloc>().add(const ResetTimer());
                          context.pushReplacement(
                            AppRoutes.add,
                            extra: minutes,
                          );
                        },
                        icon: const Icon(Icons.save),
                        label: Text(
                            'ບັນທຶກ Workout (${state.elapsedMinutes} ນາທີ)'),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Control Button ─────────────────────────────────────────────────────
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.size = 56,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          elevation: 4,
          shape: const CircleBorder(),
          color: color,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(icon, color: Colors.white, size: iconSize),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade400
                : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

// ── Circular Timer Painter ─────────────────────────────────────────────
class _TimerPainter extends CustomPainter {
  final int elapsedSeconds;
  final bool isRunning;
  final bool isDark;

  _TimerPainter({
    required this.elapsedSeconds,
    required this.isRunning,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // Background circle
    final bgPaint = Paint()
      ..color = isDark
          ? Colors.grey.shade800.withValues(alpha: 0.3)
          : Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc (loops every 60 seconds)
    if (elapsedSeconds > 0) {
      final sweepAngle = (elapsedSeconds % 60) / 60 * 2 * math.pi;
      final progressPaint = Paint()
        ..shader = SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: -math.pi / 2 + 2 * math.pi,
          colors: AppColors.tealGradient,
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }

    // Pulsing dot at the tip (when running)
    if (isRunning && elapsedSeconds > 0) {
      final angle =
          -math.pi / 2 + (elapsedSeconds % 60) / 60 * 2 * math.pi;
      final dotCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final dotPaint = Paint()
        ..color = AppColors.primaryLight
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotCenter, 6, dotPaint);

      // Glow
      final glowPaint = Paint()
        ..color = AppColors.primaryLight.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotCenter, 10, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TimerPainter oldDelegate) {
    return oldDelegate.elapsedSeconds != elapsedSeconds ||
        oldDelegate.isRunning != isRunning;
  }
}
