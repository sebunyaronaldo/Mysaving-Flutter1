import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysavingapp/common/utils/mysaving_colors.dart';
import 'package:mysavingapp/data/repositories/dashboard_repository.dart';
import 'package:mysavingapp/pages/dashboard/conf/cubit/dashboard_analitycs_cubit.dart';
import 'package:mysavingapp/pages/dashboard/helpers/widgets/dashboard_analitycs_chart.dart';

import '../../../common/styles/mysaving_styles.dart';
import '../../../data/models/dashboard_model.dart';

class DashboardAnalitycsPage extends StatelessWidget {
  const DashboardAnalitycsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DashboardAnalitycsCubit(dashboardRepository: DashboardRepository())
            ..getSummary(),
      child: analitycsBloc(),
    );
  }

  Widget analitycsBloc() {
    return BlocConsumer<DashboardAnalitycsCubit, DashboardAnalitycsState>(
      listener: (context, state) {
        if (state is DashboardAnalitycsSuccess) {}
      },
      builder: (context, state) {
        if (state is DashboardAnalitycsLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is DashboardAnalitycsError) {
          return const Center(child: Text('Coś poszło nie tak'));
        }
        if (state is DashboardAnalitycsSuccess) {
          List<DashboardAnalytics> dashboardExpenses = state.dashboardExpenses;

          if (dashboardExpenses.isNotEmpty) {
            List<DashboardAnalitycsDay> last7DaysExpenses = dashboardExpenses
                .expand((analytics) => analytics.summary)
                .take(7)
                .toList();
            var msstyles = MySavingStyles(context);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Moja analiza',
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
                            'Ten tydzień',
                            style: TextStyle(
                                color: MySavingColors.defaultExpensesText),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  child: CustomPaint(
                    painter: VerticalBarChartPainter(
                        last7DaysExpenses, DateTime.now(), 1, context),
                  ),
                ),
              ],
            );
          } else {
            return Text('Brak dostępnych danych analitycznych.');
          }
        }
        return Container();
      },
    );
  }
}
