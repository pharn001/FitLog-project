// profile_event.dart
//
// Events for the ProfileBloc.

import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

/// Load the saved user profile from Isar.
class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

/// Save or update the user's body profile.
class SaveProfile extends ProfileEvent {
  final String gender;
  final double weight;
  final double height;
  final int age;
  final String activityLevel;
  final String goal;

  const SaveProfile({
    required this.gender,
    required this.weight,
    required this.height,
    required this.age,
    required this.activityLevel,
    required this.goal,
  });

  @override
  List<Object?> get props => [gender, weight, height, age, activityLevel, goal];
}
