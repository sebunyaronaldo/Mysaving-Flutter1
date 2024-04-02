import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../common/styles/mysaving_styles.dart';
import '../../../common/utils/mysaving_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticCostsColumn extends StatelessWidget {
  const StatisticCostsColumn(
      {super.key,
      required this.todayCosts,
      required this.yesterdayCosts,
      required this.beforeYesterDayCosts});
  final String todayCosts;
  final String yesterdayCosts;
  final String beforeYesterDayCosts;
  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);

    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.statisticTitle,
          style: TextStyle(
              color: MySavingColors.defaultBlueText,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        Gap(10),
        SizedBox(
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.statisticToday,
                style: msstyles.mysavingInputTextStyles,
              ),
              Text(todayCosts,
                  style: TextStyle(
                      color: MySavingColors.defaultBlueText,
                      fontWeight: FontWeight.bold,
                      fontSize: 16))
            ],
          ),
        ),
        Gap(5),
        SizedBox(
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.statisticYesterday,
                style: msstyles.mysavingInputTextStyles,
              ),
              Text(yesterdayCosts,
                  style: TextStyle(
                      color: MySavingColors.defaultBlueText,
                      fontWeight: FontWeight.bold,
                      fontSize: 16))
            ],
          ),
        ),
        Gap(5),
        SizedBox(
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.statisticBeforeYesterday,
                style: msstyles.mysavingInputTextStyles,
              ),
              Text(beforeYesterDayCosts,
                  style: TextStyle(
                      color: MySavingColors.defaultBlueText,
                      fontWeight: FontWeight.bold,
                      fontSize: 16))
            ],
          ),
        )
      ],
    );
  }
}
