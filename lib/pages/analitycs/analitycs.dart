import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:mysavingapp/pages/analitycs/pages/compare_months/compare_months.dart';
import 'package:mysavingapp/pages/analitycs/pages/last_month/last_month.dart';
import 'package:mysavingapp/pages/analitycs/pages/this_month/this_month.dart';

import '../../common/helpers/mysaving_header.dart';
import '../../common/utils/mysaving_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnalitycsPage extends StatelessWidget {
  const AnalitycsPage({super.key});
  static Page<void> page() => const MaterialPage<void>(child: AnalitycsPage());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AnalitycsPage());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: MySavingColors.defaultBackgroundPage,
        body: SafeArea(
          child: Stack(
            children: [
              // MySavingHeader(informationHeader: 'Poprzedni miesiąc'),
              Padding(
                padding: const EdgeInsets.all(.0),
                child: Column(
                  children: [
                    MySavingHeader(informationHeader: AppLocalizations.of(context)!.dashboardButtonsAnal),
                    SegmentedTabControl(
                      // Customization of widget
                      radius: const Radius.circular(20),
                      backgroundColor: MySavingColors.defaultLightBlueBackground,
                      indicatorColor: Colors.orange.shade200,
                      tabTextColor: MySavingColors.defaultBlueText,
                      selectedTabTextColor: Colors.white,
                      squeezeIntensity: 2,
                      height: 35,
                      tabPadding: const EdgeInsets.symmetric(horizontal: 8),
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      // Options for selection
                      // All specified values will override the [SegmentedTabControl] setting
                      tabs: [
                        SegmentTab(
                          label: AppLocalizations.of(context)!.analitycsNavbarThisMonth,
                          // For example, this overrides [indicatorColor] from [SegmentedTabControl]
                          color: MySavingColors.defaultBlueText,
                        ),
                        SegmentTab(
                          label: AppLocalizations.of(context)!.analitycsNavbarLastMonth,
                          color: MySavingColors.defaultBlueText,
                        ),
                        SegmentTab(
                          label: AppLocalizations.of(context)!.analitycsNavbarCompareMonths,
                          color: MySavingColors.defaultBlueText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Sample pages
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [ThisMonthPage(), LastMonthPage(), CompareMonthsPage()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
