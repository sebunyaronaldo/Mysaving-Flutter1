import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/common/helpers/mysaving_header.dart';
import 'package:mysavingapp/common/utils/mysaving_colors.dart';
import 'package:mysavingapp/data/models/Statistic_Model.dart';
import 'package:mysavingapp/data/repositories/Statistic_Repository.dart';
import 'package:mysavingapp/pages/statistic/cubit/statistic_cubit.dart';
import 'package:mysavingapp/pages/statistic/helpers/statisitc_column.dart';
import 'package:mysavingapp/pages/statistic/helpers/statistic_expenses.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../common/styles/mysaving_styles.dart';
import '../../../data/models/dashboard_model.dart';
import '../../data/models/expenses_model.dart';
import '../../data/repositories/expenses_repository.dart';
import '../expenses/config/cubit/expense_cubit.dart';
import 'helpers/statistic_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});
  static Page<void> page() => const MaterialPage<void>(child: StatisticPage());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const StatisticPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MySavingColors.defaultBackgroundPage,
      body: SafeArea(
          child: SingleChildScrollView(
              child: MultiBlocProvider(providers: [
        BlocProvider<StatisticCubit>(
          create: (context) => StatisticCubit(statisticRepository: StatisticRepository())..getSummary(),
        ),
        BlocProvider<ExpenseCubit>(
          create: (context) => ExpenseCubit(expensesRepository: ExpensesRepository())..getSummary(),
        ),
      ], child: statisticBloc()))),
    );
  }

  void showAnalitycs(BuildContext context) {
    Future.delayed(Duration.zero, () {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: AppLocalizations.of(context)!.infoStatisitcModalTitle,
        text: AppLocalizations.of(context)!.infoStatisticModalContent,
        backgroundColor: Colors.black,
        titleColor: Colors.white,
        textColor: Colors.white,
      );
    });
  }

  Widget statisticBloc() {
    return BlocConsumer<StatisticCubit, StatisticState>(
      listener: (context, state) {},
      builder: (context, state) {
        var msstyles = MySavingStyles(context);
        if (state is StatisticLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is StatisticError) {
          return Center(
            child: Text('Coś poszło nie tak'),
          );
        }
        if (state is StatisticSuccess) {
          List<StatisticsModel> statistics = state.statistic;
          if (statistics[0].beforeYesterday == 0 && statistics[0].today == 0 && statistics[0].yesterday == 0) {
            showAnalitycs(context);
          }
          print("Length of statistics list: ${statistics.length}");
          final todayExpenses = statistics[0].today;
          final yesterdayExpenses = statistics[0].yesterday;
          final beforeYesterdayExpenses = statistics[0].beforeYesterday;

          return Column(
            children: [
              MySavingHeader(
                informationHeader: AppLocalizations.of(context)!.headerStatistics,
              ),
              StatisticCostsColumn(
                todayCosts: "${statistics[0].today} PLN",
                yesterdayCosts: "${statistics[0].yesterday} PLN",
                beforeYesterDayCosts: "${statistics[0].beforeYesterday} PLN",
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: SizedBox(
                  height: 200, // Ustaw odpowiednią wysokość dla wykresu
                  child: AnalyticsBarChart([
                    DashboardAnalitycsDay(
                        name: AppLocalizations.of(context)!.statisticToday,
                        expenses: todayExpenses!,
                        id: 1,
                        saldo: 0,
                        saving: 0,
                        date: '${DateTime.november}'), // przedwczorajsze wydatki
                    DashboardAnalitycsDay(
                        name: AppLocalizations.of(context)!.statisticYesterday,
                        expenses: yesterdayExpenses!,
                        id: 1,
                        saldo: 0,
                        saving: 0,
                        date: '${DateTime.november}'), // wczorajsze wydatki
                    DashboardAnalitycsDay(
                        name: AppLocalizations.of(context)!.statisticBeforeYesterday,
                        expenses: beforeYesterdayExpenses!,
                        id: 1,
                        saldo: 0,
                        saving: 0,
                        date: '${DateTime.november}'), // dzisiejsze wydatki
                  ]),
                ),
              ),
              Gap(60),
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.statisticThreeDays,
                    style: TextStyle(color: MySavingColors.defaultGreyText, fontSize: 17),
                  ),
                  Gap(10),
                  Text(
                    "${statistics[0].total} PLN",
                    style: TextStyle(color: MySavingColors.defaultBlueText, fontSize: 38, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Gap(30),
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.statisticMostExpenses,
                    style: msstyles.mysavingInputTextStyles,
                  ),
                  dashboardExpenses()
                ],
              ),
              Gap(10)
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget dashboardExpenses() {
    return BlocConsumer<ExpenseCubit, ExpenseState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ExpenseError) {
          return Center(
            child: Text('Coś poszło nie tak'),
          );
        }
        if (state is ExpenseSuccess) {
          List<Expenses> expensesList = state.expenses;
          if (expensesList.isNotEmpty) {
            // Filtrowanie wydatków z 3 ostatnich dni
            DateTime now = DateTime.now();
            DateTime dayBeforeYesterday = now.subtract(Duration(days: 2));

            List<Expense> expensesFiltered = expensesList
                .expand((element) => element.categories)
                .expand((category) => category.expenses!)
                .where((expense) {
              Timestamp expenseTime = expense.expensesTime as Timestamp;
              DateTime expenseDateTime = expenseTime.toDate();
              return expenseDateTime.isAfter(dayBeforeYesterday) && expenseDateTime.isBefore(now);
            }).toList();

            // Sortowanie wydatków według kwoty (od najwyższej)
            expensesFiltered.sort((a, b) => b.cost!.compareTo(a.cost!));

            // Wybieranie 4 najdroższych wydatków
            List<Expense> topExpenses = expensesFiltered.take(4).toList();

            return StatisticExpensesWidget(expense: topExpenses);
          } else {
            return Center(
              child: Text('Dodaj jakieś wydatki'),
            );
          }
        }
        return Container();
      },
    );
  }
}
