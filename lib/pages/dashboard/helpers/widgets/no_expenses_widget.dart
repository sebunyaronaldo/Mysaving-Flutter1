import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../common/styles/mysaving_styles.dart';
import '../../../../common/utils/mysaving_colors.dart';

class DashboardEmptyExpenses extends StatelessWidget {
  const DashboardEmptyExpenses({super.key});

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
                  'Ostatnie Wydatki',
                  style: msstyles.mysavingDashboardSectionTitle,
                ),
              ),
            ],
          ),
        ),
        Gap(10),
        Center(
          child: Text(
            'Nie dodałeś jeszcze wydatków',
            style: TextStyle(
              color: MySavingColors.defaultDarkText,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
