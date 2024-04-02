import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mysavingapp/common/helpers/mysaving_nav.dart';
import 'package:mysavingapp/common/utils/mysaving_colors.dart';
import 'package:mysavingapp/data/repositories/dashboard_repository.dart';
import 'package:mysavingapp/data/repositories/expenses_repository.dart';
import 'package:mysavingapp/pages/dashboard/helpers/dashboard_buttons.dart';
import 'package:mysavingapp/pages/dashboard/view/dashboard_analitycs.dart';
import 'package:mysavingapp/pages/dashboard/view/dashboard_expenses.dart';
import 'package:mysavingapp/pages/dashboard/view/dashboard_summary.dart';
import 'package:provider/provider.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/models/expenses_model.dart';
import '../../l10n/locale_provider.dart';
import '../expenses/config/cubit/expense_cubit.dart';
import 'conf/cubit/dashboard_cubit.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static Page<void> page() => const MaterialPage<void>(child: Dashboard());
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MySavingColors.defaultBackgroundPage,
      body: SafeArea(
        child: SingleChildScrollView(
            child: MultiBlocProvider(
          providers: [
            BlocProvider<DashboardCubit>(
              create: (context) =>
                  DashboardCubit(dashboardRepository: DashboardRepository())..calculateSavingsAndExpenses(),
            ),
            BlocProvider<ExpenseCubit>(
              create: (context) => ExpenseCubit(expensesRepository: ExpensesRepository())..getSummary(),
            ),
          ],
          child: blocBody(),
        )),
      ),
    );
  }

  Widget blocBody() {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is DashboardLoading) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.twistingDots(
                      leftDotColor: MySavingColors.defaultBlueText,
                      rightDotColor: MySavingColors.defaultGreen,
                      size: 40),
                ],
              ),
            ),
          );
        }
        if (state is DashboardError) {
          return Center(
            child: Text('Coś poszło nie tak'),
          );
        }
        if (state is DashboardSuccess) {
          Provider.of<LocaleProvider>(context, listen: false).loadSavedLocale();

          return Column(
            children: [
              MySavingUpNav(),
              Gap(20),
              summaryBloc(),
              Gap(20),
              DashboardButtons(),
              Gap(20),
              dashboardAnalitics(),
              Gap(40),
              dashboardExpenses(),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget summaryBloc() {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is DashboardError) {
          return const Center(child: Text('Cos poszlo nie tak'));
        }
        if (state is DashboardSuccess) {
          List<DashboardSummary> dashboardSummaryList = state.dashboardSummaryList;

          if (dashboardSummaryList.isNotEmpty) {
            int index = 0;
            DashboardSummary dashboardSummary = dashboardSummaryList[index];
            return DashboardSummaryWidget(
              savings: '${dashboardSummary.saving} PLN',
              saldo: '${dashboardSummary.saldo} PLN',
              saving: '${dashboardSummary.saving} PLN',
              expenses: '${dashboardSummary.expenses} PLN',
            );
          } else {
            return Text('No dashboard summary available.');
          }
        }
        return Container();
      },
    );
  }

  Widget dashboardAnalitics() {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is DashboardAnalitycsSuccess) {}
      },
      builder: (context, state) {
        if (state is DashboardError) {
          return const Center(child: Text('Coś poszło nie tak'));
        }
        if (state is DashboardSuccess) {
          List<DashboardAnalytics> dashboardAnalitycs = state.dashboardAnalyticsList;

          if (dashboardAnalitycs.isNotEmpty) {
            List<DashboardAnalitycsDay> last7DaysExpenses =
                dashboardAnalitycs.expand((analytics) => analytics.summary).take(7).toList();
            return DashboardAnalyticsWidget(
              last7DaysExpenses: last7DaysExpenses,
              currenTime: DateTime.now(),
              analytics: dashboardAnalitycs[0].maxExpensesPerDay!,
              maxPerDay: dashboardAnalitycs[0].maxExpensesPerDay!,
            );
          } else {
            return Text('Brak dostępnych danych analitycznych.');
          }
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
            child: Text('Cos poszlo nie tak'),
          );
        }
        if (state is ExpenseSuccess) {
          List<Expenses> expensesList = state.expenses;
          if (expensesList.isNotEmpty) {
            List<Category> categories = expensesList.expand((element) => element.categories).take(4).toList();
            List<Expense> expense = categories.expand((element) => element.expenses!).toList();

// Sortowanie wydatków według daty dodania (od najnowszego)
            expense.sort((a, b) {
              if (a.expensesTime != null && b.expensesTime != null) {
                return b.expensesTime!.compareTo(a.expensesTime!);
              }
              return 0;
            });
// Wybieranie pięciu najnowszych wydatków
            expense = expense.take(5).toList();
            return Column(
              children: [
                DashboardLastExpensesWidget(
                  expense: expense,
                ),
              ],
            );
          } else {
            return Center(
              child: Text('Dodaj jakies wydatki'),
            );
          }
        }
        return Container();
      },
    );
  }
}
