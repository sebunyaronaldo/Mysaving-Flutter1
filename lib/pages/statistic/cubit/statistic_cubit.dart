import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mysavingapp/data/repositories/Statistic_Repository.dart';

import '../../../../data/models/Statistic_Model.dart';

part 'statistic_state.dart';

class StatisticCubit extends Cubit<StatisticState> {
  final StatisticRepository statisticRepository;
  StatisticCubit({required this.statisticRepository}) : super(StatisticInitial());

  Future<void> getSummary() async {
    emit(StatisticLoading());

    try {
      final result = await statisticRepository.getStatistic();
      emit(StatisticSuccess(statistic: result));
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(StatisticError(error: 'Something went wrong'));
    }
  }

  Future<void> addToStatistic(int cost) async {
    emit(StatisticLoading());
    try {
      await statisticRepository.addToStatistic(cost);
      await getSummary();
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      emit(StatisticError(error: 'Something went wrong'));
    }
  }
}
