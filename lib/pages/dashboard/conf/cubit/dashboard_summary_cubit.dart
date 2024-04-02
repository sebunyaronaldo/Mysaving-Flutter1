import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mysavingapp/data/models/dashboard_model.dart';

import '../../../../data/repositories/interfaces/IDashboardRepository.dart';

part 'dashboard_summary_state.dart';

class DashboardSummaryCubit extends Cubit<DashboardSummaryState> {
  final IDashboardRepository dashboardRepository;

  DashboardSummaryCubit({required this.dashboardRepository}) : super(DashboardSummaryInitial());

  Future<void> getSummary() async {
    emit(DashboardSummaryLoading());

    try {
      final results = await dashboardRepository.getDashboardSummary();
      emit(DashboardSummarySuccess(dashboardSummaryList: results));
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardSummaryError(error: 'Something went wrong'));
    }
  }

  Future<void> addSaldo(int saldo) async {
    emit(DashboardSummaryLoading());
    try {
      await getSummary();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardSummaryError(error: 'Something went wrong'));
    }
  }

  Future<void> calculateExpenses() async {
    emit(DashboardSummaryLoading());
    try {
      await getSummary();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardSummaryError(error: 'Something went wrong'));
    }
  }

  Future<void> calculateSavings() async {
    emit(DashboardSummaryLoading());
    try {
      await getSummary();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(DashboardSummaryError(error: 'Something went wrong'));
    }
  }
}
