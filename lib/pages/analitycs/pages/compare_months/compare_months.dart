import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/common/utils/mysaving_colors.dart';
import 'package:mysavingapp/data/models/Analytics_Model.dart';
import 'package:mysavingapp/data/repositories/expenses_repository.dart';
import 'package:mysavingapp/pages/analitycs/pages/compare_months/helpers/analitycs_colors_navigation.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../../../common/styles/mysaving_styles.dart';
import '../../../../data/repositories/Analytics_Repository.dart';
import '../../../expenses/config/cubit/expense_cubit.dart';
import '../../config/cubit/analitycs_cubit.dart';
import 'helpers/last_month_pie_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompareMonthsPage extends StatelessWidget {
  const CompareMonthsPage({super.key});
  static Page<void> page() => const MaterialPage<void>(child: CompareMonthsPage());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const CompareMonthsPage());
  }

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
          if (analitycs[0].currentmonth![0].categories![0].expenses!.isEmpty &&
                  analitycs[0].currentmonth![0].categories![1].expenses!.isEmpty &&
                  analitycs[0].currentmonth![0].categories![2].expenses!.isEmpty &&
                  analitycs[0].currentmonth![0].categories![3].expenses!.isEmpty &&
                  analitycs[0].currentmonth![0].categories![4].expenses!.isEmpty ||
              analitycs[0].lastmonth![0].categories![0].expenses!.isEmpty &&
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

          String? translatedCurrentMonthName =
              monthlyTranslations[analitycs[0].currentmonth![0].name] ?? analitycs[0].currentmonth![0].name;
          String? translatedLastMonthName =
              monthlyTranslations[analitycs[0].lastmonth![0].name] ?? analitycs[0].lastmonth![0].name;
          return Column(
            children: [
              Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        '$translatedCurrentMonthName',
                        style: msstyles.mysavingDashboardSectionTitle,
                      ),
                      Gap(5),
                      Text(
                        AppLocalizations.of(context)!.analitycsMonthsChart,
                        style: msstyles.mysavingInputTextStyles,
                      ),
                      Gap(5),
                      Column(
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: CustomPieChart(
                              [
                                analitycs[0].currentmonth![0].categories![0].costs!,
                                analitycs[0].currentmonth![0].categories![1].costs!,
                                analitycs[0].currentmonth![0].categories![2].costs!,
                                analitycs[0].currentmonth![0].categories![3].costs!,
                                analitycs[0].currentmonth![0].categories![4].costs!,
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Gap(30),
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
              Gap(20),
              Text(
                AppLocalizations.of(context)!.analitycsCompareMonthsExpenses,
                style: msstyles.mysavingInputTextStyles,
              ),
              Gap(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        '$translatedCurrentMonthName',
                        style:
                            TextStyle(color: MySavingColors.defaultBlueText, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Gap(5),
                      Text(
                        AppLocalizations.of(context)!.analitycsMonthsIssued,
                        style: TextStyle(color: MySavingColors.defaultGreyText, fontSize: 17),
                      ),
                      Gap(10),
                      Text(
                        '${analitycs[0].currentmonth![0].totalCosts} PLN',
                        style:
                            TextStyle(color: MySavingColors.defaultBlueText, fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '$translatedLastMonthName',
                        style:
                            TextStyle(color: MySavingColors.defaultBlueText, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Gap(5),
                      Text(
                        AppLocalizations.of(context)!.analitycsMonthsIssued,
                        style: TextStyle(color: MySavingColors.defaultGreyText, fontSize: 17),
                      ),
                      Gap(10),
                      Text(
                        '${analitycs[0].lastmonth![0].totalCosts} PLN',
                        style:
                            TextStyle(color: MySavingColors.defaultBlueText, fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
              Gap(0),
              Gap(40),
            ],
          );
        }
        return Container();
      },
    );
  }
}
