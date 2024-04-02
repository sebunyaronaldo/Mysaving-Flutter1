import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../common/utils/mysaving_colors.dart';
import '../../../data/models/expenses_model.dart';

import 'package:intl/intl.dart';

class StatisticExpensesWidget extends StatelessWidget {
  const StatisticExpensesWidget({super.key, required this.expense});
  final List<Expense> expense;
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (var i = 0; i < expense.length; i++) {
      children.add(Container(
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
                                  backgroundColor: MySavingColors.defaultLightBlueBackground,
                                  child: Icon(
                                    expense[i].cost! > 0 ? Icons.thumb_down_alt_outlined : Icons.link,
                                    color: MySavingColors.defaultRed,
                                    size: 20,
                                  ),
                                ),
                              ),
                              Gap(20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 130,
                                    child: AutoSizeText(
                                      '${expense[i].name}',
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: MySavingColors.defaultDarkText,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(),
                                    child: Text(
                                      '${expense[i].expensesTime != null ? DateFormat('dd/MM/yyyy').format(expense[i].expensesTime!.toDate()) : ''}',
                                      style: TextStyle(
                                        color: MySavingColors.defaultGreyText,
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
                          '-${expense[i].cost} PLN',
                          style: TextStyle(color: MySavingColors.defaultRed, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ));
    }
    return SizedBox(
      height: 280,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}
