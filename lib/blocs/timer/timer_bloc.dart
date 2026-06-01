// timer_bloc.dart
//
// Manages a stopwatch-style timer that counts up in seconds.
// Uses a periodic [Stream] to emit [TimerTicked] events every second.

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'timer_event.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  StreamSubscription<int>? _tickSubscription;

  TimerBloc() : super(const TimerState()) {
    on<StartTimer>(_onStart);
    on<PauseTimer>(_onPause);
    on<ResumeTimer>(_onResume);
    on<ResetTimer>(_onReset);
    on<TimerTicked>(_onTicked);
  }

  void _onStart(StartTimer event, Emitter<TimerState> emit) {
    emit(TimerState(
      elapsedSeconds: state.elapsedSeconds,
      status: TimerStatus.running,
    ));
    _startTicking();
  }

  void _onPause(PauseTimer event, Emitter<TimerState> emit) {
    _tickSubscription?.cancel();
    emit(TimerState(
      elapsedSeconds: state.elapsedSeconds,
      status: TimerStatus.paused,
    ));
  }

  void _onResume(ResumeTimer event, Emitter<TimerState> emit) {
    emit(TimerState(
      elapsedSeconds: state.elapsedSeconds,
      status: TimerStatus.running,
    ));
    _startTicking();
  }

  void _onReset(ResetTimer event, Emitter<TimerState> emit) {
    _tickSubscription?.cancel();
    emit(const TimerState());
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(TimerState(
      elapsedSeconds: event.elapsedSeconds,
      status: TimerStatus.running,
    ));
  }

  void _startTicking() {
    _tickSubscription?.cancel();
    final startSeconds = state.elapsedSeconds;
    _tickSubscription = Stream.periodic(
      const Duration(seconds: 1),
      (tick) => startSeconds + tick + 1,
    ).listen((seconds) {
      add(TimerTicked(seconds));
    });
  }

  @override
  Future<void> close() {
    _tickSubscription?.cancel();
    return super.close();
  }
}
