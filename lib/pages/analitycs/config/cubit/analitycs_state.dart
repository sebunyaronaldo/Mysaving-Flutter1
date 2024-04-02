part of 'analitycs_cubit.dart';

abstract class AnalitycsState extends Equatable {
  const AnalitycsState();
  @override
  List<Object> get props => [];
}

class AnalitycsInitial extends AnalitycsState {}

class AnalitycsLoading extends AnalitycsState {}

class AnalitycsSuccess extends AnalitycsState {
  final List<MainAnalitycs> mainAnalitycs;

  AnalitycsSuccess({required this.mainAnalitycs});
  @override
  List<Object> get props => [mainAnalitycs];
}

class AnalitycsError extends AnalitycsState {
  final String error;

  AnalitycsError({required this.error});

  @override
  List<Object> get props => [error];
}
