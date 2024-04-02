import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../common/utils/mysaving_colors.dart';

class ExpensesCategoryItem extends StatelessWidget {
  const ExpensesCategoryItem(
      {super.key,
      required this.categoryName,
      required this.categoryCost,
      required this.categoryId,
      required this.iconButtonMethod});
  final String categoryName;
  final String categoryCost;
  final int categoryId;
  final Function iconButtonMethod;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      child: Card(
        color: MySavingColors.defaultCategories,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      style: TextStyle(
                        color: MySavingColors.defaultExpensesText,
                        fontSize: 16,
                      ),
                    ),
                    if (categoryId == 0)
                      IconButton(
                          onPressed: () => iconButtonMethod(),
                          icon: Icon(
                            UniconsLine.info_circle,
                            color: MySavingColors.defaultBlueText,
                          ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  categoryCost,
                  style: TextStyle(
                    color: MySavingColors.defaultRed,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
