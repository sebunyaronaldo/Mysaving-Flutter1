part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSummarySuccess extends DashboardState {
  final List<DashboardSummary> dashboardSummaryList;

  DashboardSummarySuccess({required this.dashboardSummaryList});

  @override
  List<Object> get props => [dashboardSummaryList];
}

class DashboardError extends DashboardState {
  final String error;

  DashboardError({required this.error});

  @override
  List<Object> get props => [error];
}

class DashboardAnalitycsSuccess extends DashboardState {
  final List<DashboardAnalytics> dashboardAnalitycs;

  DashboardAnalitycsSuccess({required this.dashboardAnalitycs});

  @override
  List<Object> get props => [dashboardAnalitycs];
}

class DashboardMaxExpensesSuccess extends DashboardState {
  final int maxExpensesPerDay;

  DashboardMaxExpensesSuccess({required this.maxExpensesPerDay});

  @override
  List<Object> get props => [maxExpensesPerDay];
}

class DashboardSuccess extends DashboardState {
  final List<DashboardSummary> dashboardSummaryList;
  final List<DashboardAnalytics> dashboardAnalyticsList;

  DashboardSuccess({
    required this.dashboardSummaryList,
    required this.dashboardAnalyticsList,
  });

  @override
  List<Object> get props => [dashboardSummaryList, dashboardAnalyticsList];
}
