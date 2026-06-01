// profile_state.dart
//
// States for the ProfileBloc.
// When a profile is loaded, all computed nutritional values (BMR, TDEE,
// macro targets) are available via the [UserProfile] model's getters.

import 'package:equatable/equatable.dart';

import '../../models/user_profile.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

/// Initial state — profile has not been loaded yet.
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// No profile data exists — prompt the user to create one.
class ProfileEmpty extends ProfileState {
  const ProfileEmpty();
}

/// Profile has been loaded successfully.
/// Access computed nutrition targets via [profile.tdee], [profile.proteinGrams], etc.
class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile.id, profile.updatedAt];
}

/// An error occurred while loading or saving the profile.
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
