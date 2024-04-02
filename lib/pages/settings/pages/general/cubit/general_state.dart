part of 'general_cubit.dart';

abstract class GeneralState {
  GeneralState();
}

class GeneralInitial extends GeneralState {
  GeneralInitial();
}

class GeneralLoading extends GeneralState {
  GeneralLoading();
}

class GeneralLoaded extends GeneralState {
  final List<GeneralSettings>? profiles;

  GeneralLoaded({this.profiles});
}

class GeneralUpdated extends GeneralState {
  final String? message;

  GeneralUpdated(this.message);
}

class GeneralError extends GeneralState {
  final String error;

  GeneralError(this.error);
}

class GeneralRefresh extends GeneralState {
  final List<GeneralSettings>? profiles;

  GeneralRefresh({this.profiles});
}
