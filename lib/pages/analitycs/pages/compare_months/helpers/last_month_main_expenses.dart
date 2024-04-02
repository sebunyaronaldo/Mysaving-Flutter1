import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:unicons/unicons.dart';

import '../../../../../../common/utils/mysaving_colors.dart';

class LastMonthMainExpenses extends StatelessWidget {
  const LastMonthMainExpenses({super.key, required this.name, required this.costs});
  final String name;
  final int costs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 70,
            child: Container(
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
                                          costs > 0 ? UniconsLine.bill : UniconsLine.bill,
                                          color: MySavingColors.defaultRed,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    Gap(20),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${name}',
                                          style: TextStyle(
                                            color: MySavingColors.defaultDarkText,
                                            fontSize: 16,
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
                                '-${costs} PLN',
                                style: TextStyle(
                                    color: MySavingColors.defaultRed, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))
      ],
    );
  }
}
