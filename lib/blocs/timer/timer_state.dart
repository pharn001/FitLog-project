// timer_state.dart
import 'package:equatable/equatable.dart';

enum TimerStatus { initial, running, paused }

class TimerState extends Equatable {
  final int elapsedSeconds;
  final TimerStatus status;

  const TimerState({
    this.elapsedSeconds = 0,
    this.status = TimerStatus.initial,
  });

  /// Elapsed time formatted as MM:SS.
  String get formatted {
    final minutes = (elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Elapsed time in whole minutes (rounded up).
  int get elapsedMinutes => (elapsedSeconds / 60).ceil();

  bool get isRunning => status == TimerStatus.running;
  bool get isPaused => status == TimerStatus.paused;
  bool get isInitial => status == TimerStatus.initial;

  @override
  List<Object?> get props => [elapsedSeconds, status];
}
