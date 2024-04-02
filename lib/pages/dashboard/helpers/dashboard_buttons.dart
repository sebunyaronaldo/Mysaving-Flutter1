import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/common/utils/mysaving_colors.dart';
import 'package:mysavingapp/pages/analitycs/analitycs.dart';
import 'package:mysavingapp/pages/statistic/statistic.dart';
import 'package:unicons/unicons.dart';

import '../../../common/styles/mysaving_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardButtons extends StatelessWidget {
  const DashboardButtons({Key? key});

  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 44.0,
          width: 150,
          decoration: msstyles.mysavingDashboardButtonsContainerStyle,
          child: ElevatedButton.icon(
              style: msstyles.mysavingDashboardButtonsButtonStyle,
              onPressed: () {
                Navigator.of(context).push<void>(StatisticPage.route());
              },
              icon: Icon(
                UniconsLine.analytics,
                color: MySavingColors.defaultExpensesText,
              ),
              label: Text(
                AppLocalizations.of(context)!.dashboardButtonsStats,
                style: TextStyle(color: MySavingColors.defaultDarkText),
              )),
        ),
        Gap(20),
        Container(
          height: 44.0,
          width: 150,
          decoration: msstyles.mysavingDashboardButtonsContainerStyle,
          child: ElevatedButton.icon(
              style: msstyles.mysavingDashboardButtonsButtonStyle,
              onPressed: () {
                Navigator.of(context).push<void>(AnalitycsPage.route());
              },
              icon: Icon(
                UniconsLine.chart_pie,
                color: MySavingColors.defaultExpensesText,
              ),
              label: Text(
                AppLocalizations.of(context)!.dashboardButtonsAnal,
                style: TextStyle(color: MySavingColors.defaultDarkText),
              )),
        ),
      ],
    );
  }
}
