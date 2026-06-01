// profile_bloc.dart
//
// Manages user body profile persistence via Isar.
// On [LoadProfile], fetches the most recent UserProfile from the database.
// On [SaveProfile], upserts the profile (always keeps a single record).

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

import '../../models/user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final Isar? _isar;

  ProfileBloc({Isar? isar})
      : _isar = isar,
        super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<SaveProfile>(_onSaveProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (_isar == null) {
      emit(const ProfileEmpty());
      return;
    }
    try {
      // Fetch the most recently updated profile.
      final profile = await _isar.userProfiles
          .where()
          .sortByUpdatedAtDesc()
          .findFirst();

      if (profile == null) {
        emit(const ProfileEmpty());
      } else {
        emit(ProfileLoaded(profile));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onSaveProfile(
    SaveProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (_isar == null) {
      emit(const ProfileError('Database is not initialized.'));
      return;
    }
    try {
      // Check if a profile already exists — upsert it.
      final existing = await _isar.userProfiles
          .where()
          .sortByUpdatedAtDesc()
          .findFirst();

      final profile = UserProfile(
        id: existing?.id ?? Isar.autoIncrement,
        gender: event.gender,
        weight: event.weight,
        height: event.height,
        age: event.age,
        activityLevel: event.activityLevel,
        goal: event.goal,
        updatedAt: DateTime.now(),
      );

      await _isar.writeTxn(() async {
        await _isar.userProfiles.put(profile);
      });

      // Re-read from DB to get the auto-incremented ID.
      final saved = await _isar.userProfiles
          .where()
          .sortByUpdatedAtDesc()
          .findFirst();

      if (saved != null) {
        emit(ProfileLoaded(saved));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
