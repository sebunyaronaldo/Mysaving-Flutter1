import 'package:bloc/bloc.dart';
import 'package:mysavingapp/data/repositories/interfaces/IProfileRepository.dart';
import 'package:mysavingapp/data/repositories/profile_repository.dart';

import '../../../../../../data/models/profile_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({IProfileRepository? profileRepository})
      : _profileRepository = profileRepository ?? ProfileRepository(),
        super(ProfileInitial());
  final IProfileRepository _profileRepository;

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    final results = await _profileRepository.getProfile();
    emit(ProfileLoaded(profiles: results));
  }

  Future<void> updateEmail(String newEmail) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.updateEmail(newEmail);
      emit(ProfileUpdated('Email updated successfully.'));
      await fetchProfile(); // Fetch profile again after the update
    } catch (e, stacktrace) {
      print(stacktrace.toString());
      print(e.toString());
      emit(ProfileError('Failed to update email.'));
    }
  }

  Future<void> setSaldo(int newBalance) async {
    emit(ProfileLoading());
    try {
      await fetchProfile();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(ProfileError('Something went wrong'));
    }
  }

  Future<void> updatePassword(String newPassword) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.updatePassword(newPassword);
      emit(ProfileUpdated('Password updated successfully.'));
      await fetchProfile();
    } catch (e, stacktrace) {
      print(stacktrace.toString());
      print(e.toString());
      emit(ProfileError('Failed to update password.'));
    }
  }

  Future<void> updateName(String newName) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.updateName(newName);
      emit(ProfileUpdated('Name updated successfully.'));
      await fetchProfile();
    } catch (e, stacktrace) {
      print(stacktrace.toString());
      print(e.toString());
      emit(ProfileError('Failed to update name.'));
    }
  }

  Future<void> updateProfilePicture(String imagePath) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.updateProfilePicture(imagePath);
      emit(ProfileUpdated('Profile picture updated successfully.'));
      await fetchProfile(); // Fetch profile again after updating the picture
    } catch (e, stacktrace) {
      print(stacktrace.toString());
      print(e.toString());
      emit(ProfileError('Failed to update profile picture.'));
    }
  }

  Future<void> updateProfileName(String newName) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.updateName(newName);
      emit(ProfileUpdated('Profile name updated successfully.'));
      await fetchProfile(); // Fetch profile again after updating the name
    } catch (e, stacktrace) {
      print(stacktrace.toString());
      print(e.toString());
      emit(ProfileError('Failed to update profile name.'));
    }
  }
}
