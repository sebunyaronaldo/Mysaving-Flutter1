part of 'statistic_cubit.dart';

abstract class StatisticState extends Equatable {
  const StatisticState();
  @override
  List<Object> get props => [];
}

class StatisticInitial extends StatisticState {}

class StatisticLoading extends StatisticState {}

class StatisticSuccess extends StatisticState {
  final List<StatisticsModel> statistic;

  StatisticSuccess({required this.statistic});
  @override
  List<Object> get props => [statistic];
}

class StatisticError extends StatisticState {
  final String error;

  StatisticError({required this.error});

  @override
  List<Object> get props => [error];
}
