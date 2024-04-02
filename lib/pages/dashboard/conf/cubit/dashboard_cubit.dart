import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/models/dashboard_model.dart';
import '../../../../data/repositories/interfaces/IDashboardRepository.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final IDashboardRepository dashboardRepository;

  DashboardCubit({required this.dashboardRepository}) : super(DashboardInitial());

  Future<void> getSummary() async {
    emit(DashboardLoading());

    try {
      final results = await dashboardRepository.getDashboardSummary();
      emit(DashboardSummarySuccess(dashboardSummaryList: results));
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardError(error: 'Something went wrong'));
    }
  }

  Future<void> addSaldo(int saldo) async {
    emit(DashboardLoading());
    try {
      await getSummaryAndAnalytics();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardError(error: 'Something went wrong'));
    }
  }

  Future<void> calculateExpenses() async {
    emit(DashboardLoading());
    try {
      await getSummaryAndAnalytics();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardError(error: 'Something went wrong'));
    }
  }

  Future<void> setSaldo(int newBalance) async {
    emit(DashboardLoading());
    try {
      await getSummaryAndAnalytics();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardError(error: 'Something went wrong'));
    }
  }

  Future<void> calculateSavings() async {
    emit(DashboardLoading());
    try {
      await getSummaryAndAnalytics();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardError(error: 'Something went wrong'));
    }
  }

  Future<void> getAnalytics() async {
    emit(DashboardLoading());

    try {
      final results = await dashboardRepository.getDashboardAnalitycs();
      emit(DashboardAnalitycsSuccess(dashboardAnalitycs: results));
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardError(error: 'Something went wrong'));
    }
  }

  Future<void> getSummaryAndAnalytics() async {
    emit(DashboardLoading());

    try {
      final summaryResults = await dashboardRepository.getDashboardSummary();
      final analyticsResults = await dashboardRepository.getDashboardAnalitycs();

      emit(DashboardSuccess(
        dashboardSummaryList: summaryResults,
        dashboardAnalyticsList: analyticsResults,
      ));
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardError(error: 'Something went wrong'));
    }
  }

  Future<void> calculateSavingsAndExpenses() async {
    emit(DashboardLoading());
    try {
      await dashboardRepository.calculateExpenses();
      await dashboardRepository.calculateSavings();
      await getSummaryAndAnalytics();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardError(error: 'Something went wrong'));
    }
  }

  Future<void> addMaxExpensesPerDay(int maxExpensesPerDay) async {
    emit(DashboardLoading());
    try {
      await dashboardRepository.setMaxExpensesPerDay(maxExpensesPerDay);
      await getSummaryAndAnalytics();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardError(error: 'Something went wrong'));
    }
  }

  Future<void> addToSavings(int amount) async {
    emit(DashboardLoading());
    try {
      await dashboardRepository.addToSavings(amount);
      await getSummary();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardError(error: 'Something went wrong'));
    }
  }
}
