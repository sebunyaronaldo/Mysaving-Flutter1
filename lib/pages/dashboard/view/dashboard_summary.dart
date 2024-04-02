import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../common/theme/theme_constants.dart';
import '../../../common/utils/mysaving_colors.dart';
import '../helpers/widgets/dashboard_summary_row.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardSummaryWidget extends StatelessWidget {
  const DashboardSummaryWidget(
      {super.key, required this.saldo, required this.saving, required this.expenses, required this.savings});
  final String saldo;
  final String saving;
  final String expenses;
  final String savings;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Sprawdź szerokość dostępną w constraints i zmień układ na kolumnę, jeśli jest mała rozdzielczość.
        bool isSmallScreen = constraints.maxWidth < 330; // Dostosuj tę wartość do swoich potrzeb.

        return isSmallScreen ? _buildColumnLayout(context) : _buildRowLayout(context);
      },
    );
  }

  Widget _buildRowLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 170,
          width: 180,
          decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(MySavingColors.defaultBlueButton.withOpacity(0.6), BlendMode.dstATop),
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
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: Text(
                        AppLocalizations.of(context)!.dahboardSavingsSummary,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                Gap(42),
                Text(
                  savings,
                  style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
                ),
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
                colorFilter: new ColorFilter.mode(MySavingColors.defaultCategories.withOpacity(0.3), BlendMode.dstATop),
                image: AssetImage("assets/images/dashboard/right.png"),
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
                        AppLocalizations.of(context)!.dashboardSummary,
                        style: TextStyle(color: MySavingColors.defaultGreyText, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        child: Column(
                      children: [
                        DashboardSummaryRow(
                          titleText: AppLocalizations.of(context)!.dashboardSummaryAmount,
                          costs: saldo,
                          icon: Icons.abc,
                          iconColor: MySavingColors.defaultExpensesText,
                          textcolor: MySavingColors.defaultExpensesText,
                        ),
                        DashboardSummaryRow(
                          titleText: AppLocalizations.of(context)!.dashboardSummarySavings,
                          costs: saving,
                          icon: Icons.account_balance_wallet,
                          iconColor: MySavingColors.defaultGreen,
                          textcolor: MySavingColors.defaultGreen,
                        ),
                        DashboardSummaryRow(
                          titleText: AppLocalizations.of(context)!.dashboardSummaryExpenses,
                          costs: expenses,
                          icon: Icons.access_alarm,
                          iconColor: MySavingColors.defaultRed,
                          textcolor: MySavingColors.defaultRed,
                        )
                      ],
                    )),
                  ],
                )
              ],
            )),
          ]),
        ),
      ],
    );
  }

  Widget _buildColumnLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 170,
          width: 300,
          decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(MySavingColors.defaultBlueButton.withOpacity(0.6), BlendMode.dstATop),
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
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: Text(
                        AppLocalizations.of(context)!.dahboardSavingsSummary,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                Gap(42),
                Text(
                  savings,
                  style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
                ),
              ],
            )),
          ]),
        ),
        Gap(20),
        Container(
          height: 170,
          width: 300,
          decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(MySavingColors.defaultCategories.withOpacity(0.3), BlendMode.dstATop),
                image: AssetImage("assets/images/dashboard/right.png"),
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
                        AppLocalizations.of(context)!.dashboardSummary,
                        style: TextStyle(color: MySavingColors.defaultGreyText, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        child: Column(
                      children: [
                        DashboardSummaryRow(
                          titleText: AppLocalizations.of(context)!.dashboardSummaryAmount,
                          costs: saldo,
                          icon: Icons.abc,
                          iconColor: MySavingColors.defaultExpensesText,
                          textcolor: MySavingColors.defaultExpensesText,
                        ),
                        DashboardSummaryRow(
                          titleText: AppLocalizations.of(context)!.dashboardSummarySavings,
                          costs: saving,
                          icon: Icons.account_balance_wallet,
                          iconColor: MySavingColors.defaultGreen,
                          textcolor: MySavingColors.defaultGreen,
                        ),
                        DashboardSummaryRow(
                          titleText: AppLocalizations.of(context)!.dashboardSummaryExpenses,
                          costs: expenses,
                          icon: Icons.access_alarm,
                          iconColor: MySavingColors.defaultRed,
                          textcolor: MySavingColors.defaultRed,
                        )
                      ],
                    )),
                  ],
                )
              ],
            )),
          ]),
        ),
      ],
    );
  }
}
