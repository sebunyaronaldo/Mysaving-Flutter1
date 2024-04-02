import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/data/repositories/dashboard_repository.dart';
import 'package:mysavingapp/pages/dashboard/conf/cubit/dashboard_summary_cubit.dart';

import '../../../../common/styles/mysaving_styles.dart';
import '../../../../common/utils/mysaving_colors.dart';

class AddingSaldoForm extends StatelessWidget {
  AddingSaldoForm({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _costController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DashboardSummaryCubit(dashboardRepository: DashboardRepository())
            ..getSummary(),
      child: addingForm(),
    );
  }

  Widget addingForm() {
    return BlocConsumer<DashboardSummaryCubit, DashboardSummaryState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is DashboardSummaryLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is DashboardSummaryError) {
          return Center(
            child: Text('Coś poszło nie tak'),
          );
        }
        if (state is DashboardSummarySuccess) {
          var msstyles = MySavingStyles(context);
          return Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Dodaj Saldo',
                    style: TextStyle(color: MySavingColors.defaultGreyText),
                  ),
                  Gap(10),
                  SizedBox(
                    width: 250,
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      elevation: 5.0,
                      shadowColor: MySavingColors.defaultBlueButton,
                      child: TextFormField(
                        controller: _costController,
                        decoration: InputDecoration(
                          hintText: 'Koszt',
                          suffix: Text('.PLN'),
                          suffixStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: MySavingColors.defaultGreyText),
                          filled: true,
                          fillColor: MySavingColors.defaultCategories,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border:
                              msstyles.mysavingExpensesAddingFormInputBorder,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Koszt nie może być pusty.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 44,
                    width: 250,
                    decoration: msstyles.mysavingButtonContainerStyles,
                    child: ElevatedButton(
                      style: msstyles.mysavingButtonStyles,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final cost = int.tryParse(_costController.text) ?? 0;

                          context.read<DashboardSummaryCubit>().addSaldo(cost);

                          _costController.clear();
                        }
                      },
                      child: Text('Dodaj'),
                    ),
                  ),
                  Gap(20),
                  Container(
                    height: 44,
                    width: 250,
                    decoration: msstyles.mysavingButtonContainerStyles,
                    child: ElevatedButton(
                      style: msstyles.mysavingButtonStyles,
                      onPressed: () {
                        context
                            .read<DashboardSummaryCubit>()
                            .calculateExpenses();
                      },
                      child: Text('Calculate expenses'),
                    ),
                  ),
                  Gap(20),
                  Container(
                    height: 44,
                    width: 250,
                    decoration: msstyles.mysavingButtonContainerStyles,
                    child: ElevatedButton(
                      style: msstyles.mysavingButtonStyles,
                      onPressed: () {
                        context
                            .read<DashboardSummaryCubit>()
                            .calculateSavings();
                      },
                      child: Text('Calculate Savings'),
                    ),
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
}
