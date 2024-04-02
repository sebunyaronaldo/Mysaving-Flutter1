import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mysavingapp/common/helpers/mysaving_content_title.dart';
import 'package:mysavingapp/common/helpers/mysaving_nav.dart';
import 'package:mysavingapp/data/models/expenses_model.dart';
import 'package:mysavingapp/data/repositories/Analytics_Repository.dart';
import 'package:mysavingapp/data/repositories/Statistic_Repository.dart';
import 'package:mysavingapp/data/repositories/dashboard_repository.dart';
import 'package:mysavingapp/data/repositories/expenses_repository.dart';
import 'package:mysavingapp/pages/dashboard/conf/cubit/dashboard_cubit.dart';
import 'package:mysavingapp/pages/expenses/config/cubit/expense_cubit.dart';
import 'package:flutter/services.dart';
import 'package:mysavingapp/pages/expenses/widgets/expenses_category_expense_item.dart';
import 'package:mysavingapp/pages/expenses/widgets/expenses_category_item.dart';
import 'package:mysavingapp/pages/expenses/widgets/expenses_category_row.dart';
import 'package:mysavingapp/pages/expenses/widgets/helpers/expenses_adding_textfield.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../common/helpers/mysaving_button.dart';
import '../../common/styles/mysaving_styles.dart';
import '../../common/utils/mysaving_colors.dart';
import '../analitycs/config/cubit/analitycs_cubit.dart';
import '../statistic/cubit/statistic_cubit.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _costController = TextEditingController();
  int? selectedCategoryId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MySavingColors.defaultBackgroundPage,
      body: SafeArea(
        child: SingleChildScrollView(
            child: MultiBlocProvider(
          providers: [
            BlocProvider<ExpenseCubit>(
              create: (context) => ExpenseCubit(expensesRepository: ExpensesRepository())..getSummary(),
            ),
            BlocProvider(
              create: (context) => DashboardCubit(dashboardRepository: DashboardRepository()),
            ),
            BlocProvider<StatisticCubit>(
                create: (context) => StatisticCubit(statisticRepository: StatisticRepository())),
            BlocProvider<AnalitycsCubit>(
                create: (context) => AnalitycsCubit(analitycsRepository: AnalyticsRepository())),
          ],
          child: blocBody(),
        )),
      ),
    );
  }

  Widget blocBody() {
    return BlocConsumer<ExpenseCubit, ExpenseState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.twistingDots(
                      leftDotColor: MySavingColors.defaultBlueText,
                      rightDotColor: MySavingColors.defaultGreen,
                      size: 40),
                ],
              ),
            ),
          );
        }
        if (state is ExpenseError) {
          return Center(
            child: Text('Coś poszło nie tak'),
          );
        }
        if (state is ExpenseSuccess) {
          List<Expenses> expenses = state.expenses;
          List<Category> categories = expenses.expand((element) => element.categories).toList();
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MySavingUpNav(),
              SizedBox(
                height: 20,
              ),
              expenseRowBloc(),
              expenseBloc(),
              addingForm(categories),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget addingForm(List<Category> categories) {
    var msstyles = MySavingStyles(context);
    return BlocConsumer<ExpenseCubit, ExpenseState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ExpenseError) {
          return Center(
            child: Text('Coś poszło nie tak'),
          );
        }
        if (state is ExpenseSuccess) {
          return Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.expensesAddTitle,
                    style: TextStyle(color: MySavingColors.defaultGreyText),
                  ),
                  Gap(15),
                  SizedBox(
                    width: 250,
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      elevation: 5.0,
                      shadowColor: MySavingColors.defaultBlueButton,
                      child: DropdownButtonFormField<int>(
                        value: selectedCategoryId ?? categories.firstWhere((category) => category.id == 1).id,
                        elevation: 6,
                        icon: Icon(Icons.arrow_downward),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: MySavingColors.defaultCategories,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: msstyles.mysavingExpensesAddingFormInputBorder,
                        ),
                        style: TextStyle(
                          color: MySavingColors.defaultExpensesText,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (int? value) {
                          setState(() {
                            selectedCategoryId = value;
                          });
                        },
                        items: categories.map<DropdownMenuItem<int>>(
                          (Category category) {
                            Map<String, String> categoryTranslations = {
                              'Shopping': AppLocalizations.of(context)!.expensesFirstCategory,
                              'Addictions': AppLocalizations.of(context)!.expensesSecondCategory,
                              'InTheCity': AppLocalizations.of(context)!.expensesThirdCategory,
                              'Bills': AppLocalizations.of(context)!.expensesFourthCategory,
                            };
                            String? translatedCategoryName = categoryTranslations[category.name] ?? category.name;
                            return DropdownMenuItem<int>(
                              value: category.id,
                              child: SizedBox(
                                width: 190,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(translatedCategoryName!),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  Gap(10),
                  ExpensesAddingTextField(
                    hintText: AppLocalizations.of(context)!.expensesAddNameInput,
                    textFieldController: _nameController,
                    formatter: [],
                    textInputType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nazwa nie może być pusta.';
                      }
                      return null;
                    },
                  ),
                  Gap(10),
                  ExpensesAddingTextField(
                    hintText: AppLocalizations.of(context)!.expensesAddCostInput,
                    textFieldController: _costController,
                    formatter: [FilteringTextInputFormatter.digitsOnly],
                    textInputType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Koszt nie może być pusty.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MySavingButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final name = _nameController.text;
                        final cost = int.tryParse(_costController.text) ?? 0;
                        final categoryId = selectedCategoryId;
                        if (categoryId != null) {
                          context.read<AnalitycsCubit>().addExpenseToMain(categoryId, cost, name);
                          context.read<StatisticCubit>().addToStatistic(cost);
                          context.read<ExpenseCubit>().addExpense(name, cost, categoryId);
                          _nameController.clear();
                          _costController.clear();
                          selectedCategoryId = null;
                        }
                      }
                    },
                    buttonTitle: AppLocalizations.of(context)!.expensesAddButton,
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget expenseRowBloc() {
    double calculatePercentage(double costs, double totalCosts, double totalPercentage) {
      if (totalCosts == 0) {
        return 0.0; // Handle division by zero case
      }
      double percentage = (costs / totalCosts) * 100.0;
      double adjustedPercentage = percentage / totalPercentage * 100.0;
      return adjustedPercentage.isNaN ? 0.0 : adjustedPercentage;
    }

    return BlocConsumer<ExpenseCubit, ExpenseState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ExpenseError) {
          return Center(
            child: Text('Cos poszlo nie tak'),
          );
        }
        if (state is ExpenseSuccess) {
          List<Expenses> expensesList = state.expenses;
          if (expensesList.isNotEmpty) {
            List<Category> categories = expensesList.expand((element) => element.categories).take(5).toList();
            double totalCategoryCosts = categories
                .map((category) => category.expenses!.map((expense) => expense.cost ?? 0).fold(0, (a, b) => a + b))
                .fold(0, (a, b) => a + b)
                .toDouble();

            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: 380,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        Category category = categories[index];
                        double categoryCosts =
                            category.expenses!.map((expense) => expense.cost ?? 0).fold(0, (a, b) => a + b).toDouble();

                        double categoryPercentage = calculatePercentage(
                          categoryCosts,
                          totalCategoryCosts,
                          100.0,
                        );

                        return ExpensesCategoryRow(
                            imageUrl: category.url!,
                            percentage: '${categories.isEmpty ? 0 : categoryPercentage.toStringAsFixed(0)}%');
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('Nie dodales jeszcze wydartków'),
            );
          }
        }
        return Container();
      },
    );
  }

  Widget expenseBloc() {
    return BlocConsumer<ExpenseCubit, ExpenseState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ExpenseError) {
          return Center(
            child: Text('Cos poszlo nie tak'),
          );
        }
        if (state is ExpenseSuccess) {
          List<Expenses> expensesList = state.expenses;

          if (expensesList.isNotEmpty) {
            List<Category> categories = expensesList.expand((element) => element.categories).take(5).toList();
            void showSuccesChangeEmail(BuildContext context) {
              Future.delayed(Duration.zero, () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.info,
                  title: AppLocalizations.of(context)!.infoCategoryModalTitle,
                  text: AppLocalizations.of(context)!.infoCategoryModalContent,
                  backgroundColor: Colors.black,
                  titleColor: Colors.white,
                  textColor: Colors.white,
                );
              });
            }

            return Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  MySavingContentTitle(
                    contentTitle: AppLocalizations.of(context)!.expensesColumnTitle,
                  ),
                  Gap(10),
                  SizedBox(
                    width: 370,
                    height: 260,
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        double totalCategoryCosts =
                            category.expenses!.map((expense) => expense.cost ?? 0).fold(0, (a, b) => a + b).toDouble();
                        Map<String, String> categoryTranslations = {
                          'Shopping': AppLocalizations.of(context)!.expensesFirstCategory,
                          'Addictions': AppLocalizations.of(context)!.expensesSecondCategory,
                          'InTheCity': AppLocalizations.of(context)!.expensesThirdCategory,
                          'Bills': AppLocalizations.of(context)!.expensesFourthCategory,
                        };
                        String? translatedCategoryName = categoryTranslations[category.name] ?? category.name;

                        return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: MySavingColors.defaultBackgroundPage,
                                builder: (BuildContext context) {
                                  return ListView.builder(
                                    itemCount: category.expenses!.length,
                                    itemBuilder: (BuildContext context, index) {
                                      Expense expense = category.expenses![index];
                                      return InkWell(
                                        onTap: () {
                                          QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.info,
                                              barrierDismissible: true,
                                              title: AppLocalizations.of(context)!.infoExpenseModalTitle,
                                              confirmBtnText: 'Wróć',
                                              widget: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            child: AutoSizeText(
                                                                '${AppLocalizations.of(context)!.infoExpenseModalContentName}: ${expense.name!}'),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                            '${AppLocalizations.of(context)!.infoExpenseModalContentCost}: ${expense.cost!} PLN'),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                            '${AppLocalizations.of(context)!.infoExpenseModalContentDate}: ${expense.expensesTime != null ? DateFormat('dd/MM/yyyy').format(expense.expensesTime!.toDate()) : ''}'),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                            '${AppLocalizations.of(context)!.infoExpenseModalContentTime}: ${expense.expensesTime != null ? DateFormat('HH:mm').format(expense.expensesTime!.toDate()) : ''}'),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ));
                                        },
                                        child: ExpensesCategoryExpenseItem(
                                          expenseName: '${expense.name}',
                                          expenseCost: '-${expense.cost} PLN',
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: ExpensesCategoryItem(
                                categoryId: index,
                                categoryName: translatedCategoryName!,
                                iconButtonMethod: () {
                                  showSuccesChangeEmail(context);
                                },
                                categoryCost: '-${totalCategoryCosts.toStringAsFixed(0)} PLN'));
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('Nie dodales jeszcze wydartków'),
            );
          }
        }
        return Container();
      },
    );
  }
}
