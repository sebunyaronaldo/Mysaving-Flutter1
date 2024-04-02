import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../common/styles/mysaving_styles.dart';
import '../../../common/utils/mysaving_colors.dart';
import '../../../data/models/expenses_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardLastExpensesWidget extends StatelessWidget {
  const DashboardLastExpensesWidget({super.key, required this.expense});
  final List<Expense> expense;

  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);

    if (expense.isEmpty) {
      // Jeśli lista wydatków jest pusta, wyświetl odpowiedni tekst.
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.dashboardLastActivity,
                    style: msstyles.mysavingDashboardSectionTitle,
                  ),
                ),
              ],
            ),
          ),
          Gap(10),
          Center(
            child: Text(
              AppLocalizations.of(context)!.dashboardLastActivityError,
              style: TextStyle(
                color: MySavingColors.defaultRed,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    } else {
      // Jeśli lista wydatków nie jest pusta, wyświetl wydatki.
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.dashboardLastActivity,
                    style: msstyles.mysavingDashboardSectionTitle,
                  ),
                ),
              ],
            ),
          ),
          Gap(10),
          SizedBox(
            height: 220,
            child: ListView.builder(
              itemCount: expense.length,
              itemBuilder: (BuildContext context, index) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          color: MySavingColors.defaultCategories,
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 35,
                                          child: CircleAvatar(
                                            backgroundColor: MySavingColors
                                                .defaultLightBlueBackground,
                                            child: Icon(
                                              expense[index].cost! > 0
                                                  ? Icons
                                                      .thumb_down_alt_outlined
                                                  : Icons.link,
                                              color: MySavingColors.defaultRed,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        Gap(20),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 130,
                                              child: AutoSizeText(
                                                maxLines: 2,
                                                '${expense[index].name}',
                                                style: TextStyle(
                                                  color: MySavingColors
                                                      .defaultDarkText,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(),
                                              child: Text(
                                                '${expense[index].expensesTime != null ? DateFormat('dd/MM/yyyy').format(expense[index].expensesTime!.toDate()) : ''}',
                                                style: TextStyle(
                                                  color: MySavingColors
                                                      .defaultGreyText,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Text(
                                    '-${expense[index].cost} PLN',
                                    style: TextStyle(
                                        color: MySavingColors.defaultRed,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
    }
  }
}
