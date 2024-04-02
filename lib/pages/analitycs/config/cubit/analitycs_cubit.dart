import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/Analytics_Model.dart';
import '../../../../data/repositories/Analytics_Repository.dart';

part 'analitycs_state.dart';

class AnalitycsCubit extends Cubit<AnalitycsState> {
  final AnalyticsRepository analitycsRepository;
  AnalitycsCubit({required this.analitycsRepository}) : super(AnalitycsInitial());

  Future<void> getSummary() async {
    emit(AnalitycsLoading());

    try {
      final result = await analitycsRepository.getMainAnalitycs();
      emit(AnalitycsSuccess(mainAnalitycs: result));
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(AnalitycsError(error: 'Something went wrong'));
    }
  }

  Future<void> addExpenseToMain(int cost, int categoryId, String name) async {
    emit(AnalitycsLoading());
    try {
      await analitycsRepository.addToMainAnalitycs(cost, categoryId, name);
      await getSummary();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(AnalitycsError(error: 'Something went wrong'));
    }
  }

  Future<void> addCustomNameCategory(String name) async {
    emit(AnalitycsLoading());
    try {
      await analitycsRepository.updateCategoryName(name);
      await getSummary();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(AnalitycsError(error: 'Something went wrong'));
    }
  }
}
