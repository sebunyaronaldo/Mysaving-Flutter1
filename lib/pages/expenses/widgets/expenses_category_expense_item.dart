import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../common/utils/mysaving_colors.dart';

class ExpensesCategoryExpenseItem extends StatelessWidget {
  const ExpensesCategoryExpenseItem({super.key, required this.expenseName, required this.expenseCost});
  final String expenseName;
  final String expenseCost;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      child: Card(
        color: MySavingColors.defaultCategories,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: AutoSizeText(
                      maxLines: 2,
                      expenseName,
                      style: TextStyle(
                        color: MySavingColors.defaultExpensesText,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    expenseCost,
                    style: TextStyle(
                      color: MySavingColors.defaultRed,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
