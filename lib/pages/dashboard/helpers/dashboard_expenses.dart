import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/data/repositories/expenses_repository.dart';
import 'package:intl/intl.dart';

import '../../../common/styles/mysaving_styles.dart';
import '../../../common/utils/mysaving_colors.dart';
import '../../../data/models/expenses_model.dart';
import '../../expenses/config/cubit/expense_cubit.dart';

class DashboardExpenses extends StatelessWidget {
  const DashboardExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ExpenseCubit(expensesRepository: ExpensesRepository())..getSummary(),
      child: dashboardExpenesesBloc(),
    );
  }

  Widget dashboardExpenesesBloc() {
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
            child: Text('Cos poszlo nie tak'),
          );
        }
        if (state is ExpenseSuccess) {
          List<Expenses> expensesList = state.expenses;
          if (expensesList.isNotEmpty) {
            List<Category> categories = expensesList
                .expand((element) => element.categories)
                .take(5)
                .toList();
            List<Expense> expense =
                categories.expand((element) => element.expenses!).toList();

// Sortowanie wydatków według daty dodania (od najnowszego)
            expense.sort((a, b) {
              if (a.expensesTime != null && b.expensesTime != null) {
                return b.expensesTime!.compareTo(a.expensesTime!);
              }
              return 0;
            });
            var msstyles = MySavingStyles(context);
// Wybieranie pięciu najnowszych wydatków
            expense = expense.take(5).toList();
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
                SizedBox(
                  height: 250,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
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
                                                    color: MySavingColors
                                                        .defaultRed,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              Gap(20),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${expense[index].name}',
                                                    style: TextStyle(
                                                      color: MySavingColors
                                                          .defaultDarkText,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(),
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
                                        padding:
                                            const EdgeInsets.only(right: 20),
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
          } else {
            return Center(
              child: Text('Dodaj jakies wydatki'),
            );
          }
        }
        return Container();
      },
    );
  }
}
