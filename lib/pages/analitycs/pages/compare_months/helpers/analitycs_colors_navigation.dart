import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/data/models/expenses_model.dart';
import 'package:mysavingapp/data/repositories/Analytics_Repository.dart';
import 'package:mysavingapp/pages/expenses/config/cubit/expense_cubit.dart';

import '../../../../../common/utils/mysaving_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../config/cubit/analitycs_cubit.dart';

class AnalitycsLegend extends StatelessWidget {
  const AnalitycsLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnalitycsCubit>(
      create: (context) => AnalitycsCubit(analitycsRepository: AnalyticsRepository())..getSummary(),
      child: AnalitycsColorsNavigation(),
    );
  }
}

class AnalitycsColorsNavigation extends StatelessWidget {
  const AnalitycsColorsNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseCubit, ExpenseState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is ExpenseError) {
          return Center(
              child: Text(
            'Wystąpił błąd',
          ));
        }
        if (state is ExpenseSuccess) {
          List<Expenses> analitycs = state.expenses;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: MySavingColors.defaultBlueText,
                      ),
                      Text(
                        ' -${analitycs[0].categories[0].name}',
                        style: TextStyle(color: MySavingColors.defaultDarkText),
                      )
                    ],
                  ),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: MySavingColors.defaultGreen,
                      ),
                      Text(
                        ' -${AppLocalizations.of(context)!.expensesFirstCategory}',
                        style: TextStyle(color: MySavingColors.defaultDarkText),
                      )
                    ],
                  ),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: MySavingColors.defaultRed,
                      ),
                      Text(
                        ' -${AppLocalizations.of(context)!.expensesSecondCategory}',
                        style: TextStyle(color: MySavingColors.defaultDarkText),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: MySavingColors.defaultPurple,
                      ),
                      Text(
                        ' -${AppLocalizations.of(context)!.expensesThirdCategory}',
                        style: TextStyle(color: MySavingColors.defaultDarkText),
                      )
                    ],
                  ),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: MySavingColors.defaultOrange,
                      ),
                      Text(
                        ' -${AppLocalizations.of(context)!.expensesFourthCategory}',
                        style: TextStyle(color: MySavingColors.defaultDarkText),
                      )
                    ],
                  )
                ],
              )
            ],
          );
        }
        return Container();
      },
    );
  }
}
