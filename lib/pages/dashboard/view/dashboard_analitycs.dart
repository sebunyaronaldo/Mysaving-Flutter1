import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../common/styles/mysaving_styles.dart';
import '../../../common/utils/mysaving_colors.dart';
import '../../../data/models/dashboard_model.dart';
import '../helpers/widgets/dashboard_analitycs_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardAnalyticsWidget extends StatelessWidget {
  const DashboardAnalyticsWidget(
      {super.key,
      required this.last7DaysExpenses,
      required this.currenTime,
      required this.analytics,
      required this.maxPerDay});
  final List<DashboardAnalitycsDay> last7DaysExpenses;
  final DateTime currenTime;
  final int analytics;
  final int maxPerDay;
  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.dashboardAnalitycsTitle,
                  style: msstyles.mysavingDashboardSectionTitle,
                ),
              ),
              Container(
                width: 120,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: MySavingColors.defaultLightBlueBackground,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.dashboardAnalitycsSubTitle,
                    style: TextStyle(color: MySavingColors.defaultExpensesText),
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${AppLocalizations.of(context)!.dashboardAnalitycsLimit} $maxPerDay PLN',
                  style: msstyles.mysavingDashboardSummaryTitleStyle,
                ),
              ),
            ],
          ),
        ),
        last7DaysExpenses.isNotEmpty
            ? Container(
                height: 200,
                child: CustomPaint(
                  painter: VerticalBarChartPainter(
                      last7DaysExpenses, currenTime, analytics, context),
                ),
              )
            : Text(
                'Brak danych dla wykresu'), // Show a message when there are no expenses data available.
      ],
    );
  }
}
