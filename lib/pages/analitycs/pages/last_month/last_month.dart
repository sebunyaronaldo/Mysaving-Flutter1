import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../common/styles/mysaving_styles.dart';
import '../../../../common/utils/mysaving_colors.dart';
import '../../../../data/models/Analytics_Model.dart';
import '../../../../data/repositories/Analytics_Repository.dart';
import '../../../../data/repositories/expenses_repository.dart';
import '../../../expenses/config/cubit/expense_cubit.dart';
import '../../config/cubit/analitycs_cubit.dart';
import '../compare_months/helpers/analitycs_colors_navigation.dart';
import '../compare_months/helpers/last_month_main_expenses.dart';
import '../compare_months/helpers/last_month_pie_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LastMonthPage extends StatelessWidget {
  const LastMonthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MySavingColors.defaultBackgroundPage,
      body: SafeArea(
        child: SingleChildScrollView(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AnalitycsCubit>(
                create: (context) => AnalitycsCubit(
                  analitycsRepository: AnalyticsRepository(),
                )..getSummary(),
              ),
              BlocProvider<ExpenseCubit>(
                create: (context) => ExpenseCubit(expensesRepository: ExpensesRepository())..getSummary(),
              ),
            ],
            child: lastMonth(),
          ),
        ),
      ),
    );
  }

  void showAnalitycs(BuildContext context) {
    Future.delayed(Duration.zero, () {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: AppLocalizations.of(context)!.infoStatisitcModalTitle,
        text: AppLocalizations.of(context)!.errorModalLastAnalitycsContent,
        backgroundColor: Colors.black,
        titleColor: Colors.white,
        textColor: Colors.white,
      );
    });
  }

  Widget lastMonth() {
    return BlocConsumer<AnalitycsCubit, AnalitycsState>(
      listener: (context, state) {},
      builder: (context, state) {
        var msstyles = MySavingStyles(context);
        if (state is AnalitycsLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is AnalitycsError) {
          return Center(
              child: Text(
            'Wystąpił błąd',
          ));
        }
        if (state is AnalitycsSuccess) {
          List<MainAnalitycs> analitycs = state.mainAnalitycs;
          if (analitycs[0].lastmonth![0].categories![0].expenses!.isEmpty &&
              analitycs[0].lastmonth![0].categories![1].expenses!.isEmpty &&
              analitycs[0].lastmonth![0].categories![2].expenses!.isEmpty &&
              analitycs[0].lastmonth![0].categories![3].expenses!.isEmpty &&
              analitycs[0].lastmonth![0].categories![4].expenses!.isEmpty) {
            showAnalitycs(context);
          }
          Map<String, String> monthlyTranslations = {
            'January': AppLocalizations.of(context)!.analitycsMonthsJanuary,
            'February': AppLocalizations.of(context)!.analitycsMonthsFebruary,
            'March': AppLocalizations.of(context)!.analitycsMonthsMarch,
            'April': AppLocalizations.of(context)!.analitycsMonthsApril,
            'May': AppLocalizations.of(context)!.analitycsMonthsMay,
            'June': AppLocalizations.of(context)!.analitycsMonthsJune,
            'July': AppLocalizations.of(context)!.analitycsMonthsJuly,
            'August': AppLocalizations.of(context)!.analitycsMonthsAugust,
            'September': AppLocalizations.of(context)!.analitycsMonthsSeptember,
            'October': AppLocalizations.of(context)!.analitycsMonthsOctober,
            'November': AppLocalizations.of(context)!.analitycsMonthsNovember,
            'December': AppLocalizations.of(context)!.analitycsMonthsDecember,
          };

          String? translatedLastMonthName =
              monthlyTranslations[analitycs[0].lastmonth![0].name] ?? analitycs[0].lastmonth![0].name;
          return Column(
            children: [
              Gap(20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        '$translatedLastMonthName',
                        style: msstyles.mysavingDashboardSectionTitle,
                      ),
                      Gap(5),
                      Text(
                        AppLocalizations.of(context)!.analitycsMonthsChart,
                        style: msstyles.mysavingInputTextStyles,
                      ),
                      Gap(5),
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CustomPieChart(
                          [
                            analitycs[0].lastmonth![0].categories![0].costs!,
                            analitycs[0].lastmonth![0].categories![1].costs!,
                            analitycs[0].lastmonth![0].categories![2].costs!,
                            analitycs[0].lastmonth![0].categories![3].costs!,
                            analitycs[0].lastmonth![0].categories![4].costs!,
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Gap(10),
              AnalitycsColorsNavigation(),
              Gap(30),
              Column(
                children: [
                  Text(
                    '$translatedLastMonthName',
                    style: TextStyle(color: MySavingColors.defaultBlueText, fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  Gap(5),
                  Text(
                    AppLocalizations.of(context)!.analitycsMonthsIssued,
                    style: TextStyle(color: MySavingColors.defaultGreyText, fontSize: 17),
                  ),
                  Gap(10),
                  Text(
                    '${analitycs[0].lastmonth![0].totalCosts} PLN',
                    style: TextStyle(color: MySavingColors.defaultBlueText, fontSize: 38, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Gap(0),
              Gap(40),
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.analitycsMonthsExpenses,
                    style: msstyles.mysavingInputTextStyles,
                  ),
                  dashboardExpenses()
                ],
              )
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget dashboardExpenses() {
    return BlocConsumer<AnalitycsCubit, AnalitycsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is AnalitycsLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is AnalitycsError) {
          return Center(
            child: Text('Coś poszło nie tak'),
          );
        }
        if (state is AnalitycsSuccess) {
          List<MainAnalitycs> expensesList = state.mainAnalitycs;
          List<LastMonth>? lastMonth = expensesList[0].lastmonth;
          if (expensesList.isNotEmpty) {
            // Sortowanie kategorii według ilości wydatków
            lastMonth!.sort((a, b) => b.categories!.length.compareTo(a.categories!.length));
            List categories = lastMonth
                .expand((element) => element.categories!)
                .take(5) // Pobieranie trzech kategorii z największą ilością wydatków
                .toList();
            categories.sort((a, b) {
              int totalCostA = a.expenses!.map((expense) => expense.cost ?? 0).fold(0, (a, b) => a + b).toInt();
              int totalCostB = b.expenses!.map((expense) => expense.cost ?? 0).fold(0, (a, b) => a + b).toInt();
              return totalCostB.compareTo(totalCostA);
            });
            return Column(
              children: categories.map((category) {
                Map<String, String> categoryTranslations = {
                  'Shopping': AppLocalizations.of(context)!.expensesFirstCategory,
                  'Addictions': AppLocalizations.of(context)!.expensesSecondCategory,
                  'InTheCity': AppLocalizations.of(context)!.expensesThirdCategory,
                  'Bills': AppLocalizations.of(context)!.expensesFourthCategory,
                };
                int totalCategoryCosts =
                    category.expenses!.map((expense) => expense.cost ?? 0).fold(0, (a, b) => a + b).toInt();
                String categoryName = categoryTranslations[category.name] ?? category.name!;
                return LastMonthMainExpenses(name: categoryName, costs: totalCategoryCosts);
              }).toList(),
            );
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
