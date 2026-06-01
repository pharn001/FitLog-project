// timer_event.dart
import 'package:equatable/equatable.dart';

sealed class TimerEvent extends Equatable {
  const TimerEvent();
  @override
  List<Object?> get props => [];
}

/// Start the timer (stopwatch mode — counts up).
class StartTimer extends TimerEvent {
  const StartTimer();
}

/// Pause the running timer.
class PauseTimer extends TimerEvent {
  const PauseTimer();
}

/// Resume a paused timer.
class ResumeTimer extends TimerEvent {
  const ResumeTimer();
}

/// Reset the timer to zero.
class ResetTimer extends TimerEvent {
  const ResetTimer();
}

/// Internal tick event dispatched every second.
class TimerTicked extends TimerEvent {
  final int elapsedSeconds;
  const TimerTicked(this.elapsedSeconds);

  @override
  List<Object?> get props => [elapsedSeconds];
}
