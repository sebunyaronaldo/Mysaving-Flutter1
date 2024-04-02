part of 'profile_cubit.dart';

abstract class ProfileState {
  ProfileState();
}

class ProfileInitial extends ProfileState {
  ProfileInitial();
}

class ProfileLoading extends ProfileState {
  ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final List<UserProfile>? profiles;

  ProfileLoaded({this.profiles});
}

class ProfileUpdated extends ProfileState {
  final String? message;

  ProfileUpdated(this.message);
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}

class ProfileRefresh extends ProfileState {
  final List<UserProfile>? profiles;

  ProfileRefresh({this.profiles});
}
