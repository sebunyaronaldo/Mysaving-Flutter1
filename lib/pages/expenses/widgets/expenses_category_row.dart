import 'package:flutter/material.dart';

import '../../../common/theme/theme_constants.dart';
import '../../../common/utils/mysaving_colors.dart';

class ExpensesCategoryRow extends StatelessWidget {
  const ExpensesCategoryRow({super.key, required this.imageUrl, required this.percentage});
  final String imageUrl;
  final String percentage;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: 75,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MySavingColors.defaultCategories,
                boxShadow: [
                  DarkModeSwitch.isDarkMode
                      ? BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        )
                      : BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 35,
                    child: Image.asset(imageUrl),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 75,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    percentage,
                    style: TextStyle(
                      color: MySavingColors.defaultGreyText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
