import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/common/utils/mysaving_colors.dart';
import 'package:mysavingapp/common/theme/theme_constants.dart';
import 'package:mysavingapp/data/models/dashboard_model.dart';
import 'package:mysavingapp/pages/dashboard/helpers/widgets/dashboard_currency_picker.dart';
import 'package:mysavingapp/pages/dashboard/helpers/widgets/dashboard_summary_row.dart';

import '../../../data/repositories/dashboard_repository.dart';
import '../conf/cubit/dashboard_summary_cubit.dart';

class DashboardSummaryPage extends StatelessWidget {
  const DashboardSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DashboardSummaryCubit(dashboardRepository: DashboardRepository())
            ..getSummary(),
      child: summaryBlocBody(),
    );
  }

  Widget summaryBlocBody() {
    return BlocProvider(
      create: (context) =>
          DashboardSummaryCubit(dashboardRepository: DashboardRepository())
            ..getSummary(),
      child: BlocConsumer<DashboardSummaryCubit, DashboardSummaryState>(
        listener: (context, state) {
          if (state is DashboardSummarySuccess) {}
        },
        builder: (context, state) {
          if (state is DashboardSummaryLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is DashboardSummaryError) {
            return const Center(child: Text('Cos poszlo nie tak'));
          }
          if (state is DashboardSummarySuccess) {
            List<DashboardSummary> dashboardSummaryList =
                state.dashboardSummaryList;

            if (dashboardSummaryList.isNotEmpty) {
              int index = 0;
              DashboardSummary dashboardSummary = dashboardSummaryList[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 170,
                    width: 180,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/dashboard/left.png"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: MySavingColors.defaultBlueButton),
                    child: Column(children: [
                      Expanded(
                          child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 10),
                                child: Text(
                                  'Twoje oszczednosci',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          Gap(35),
                          Text(
                            '${dashboardSummary.saving} PLN',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, top: 10),
                            child: SizedBox(
                              width: 200,
                              height: 70,
                              child: DashboardCurrencyPicker(
                                onCurrencyChanged: (String) {},
                              ),
                            ),
                          )
                        ],
                      )),
                    ]),
                  ),
                  Gap(20),
                  Container(
                    height: 170,
                    width: 180,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage("assets/images/dashboard/right.png"),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          DarkModeSwitch.isDarkMode
                              ? BoxShadow()
                              : BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: MySavingColors.defaultCategories),
                    child: Column(children: [
                      Expanded(
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Podsumowanie',
                                  style: TextStyle(
                                      color: Color(0xFFC0C0C0), fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              width: 100,
                              child: Column(
                                children: [
                                  DashboardSummaryRow(
                                    titleText: 'Saldo',
                                    costs: '${dashboardSummary.saldo}',
                                    icon: Icons.abc,
                                    iconColor:
                                        MySavingColors.defaultExpensesText,
                                    textcolor:
                                        MySavingColors.defaultExpensesText,
                                  ),
                                  DashboardSummaryRow(
                                    titleText: 'Oszczędności',
                                    costs: '${dashboardSummary.saving}',
                                    icon: Icons.account_balance_wallet,
                                    iconColor: MySavingColors.defaultGreen,
                                    textcolor: MySavingColors.defaultGreen,
                                  ),
                                  DashboardSummaryRow(
                                    titleText: 'Wydatki',
                                    costs: '${dashboardSummary.expenses}',
                                    icon: Icons.access_alarm,
                                    iconColor: MySavingColors.defaultRed,
                                    textcolor: MySavingColors.defaultRed,
                                  )
                                ],
                              ))
                        ],
                      )),
                    ]),
                  ),
                ],
              );
            } else {
              return Text('No dashboard summary available.');
            }
          }
          return Container();
        },
      ),
    );
  }
}
