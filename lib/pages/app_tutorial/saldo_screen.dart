import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:mysavingapp/common/styles/mysaving_styles.dart';
import 'package:mysavingapp/pages/dashboard/conf/cubit/dashboard_cubit.dart';

import '../../common/utils/mysaving_colors.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../main_page/main_page.dart';

class SaldoScreen extends StatelessWidget {
  SaldoScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _costController = TextEditingController();
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SaldoScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => DashboardCubit(dashboardRepository: DashboardRepository())..getSummaryAndAnalytics(),
            child: blocBody(),
          ),
        ),
      ),
    );
  }

  Widget blocBody() {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is DashboardLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is DashboardError) {
          return Center(
            child: Text('Coś poszło nie tak'),
          );
        }
        if (state is DashboardSuccess) {
          var msstyles = MySavingStyles(context);
          return Column(
            children: [
              Gap(80),
              SizedBox(
                width: 300,
                height: 300,
                child: Lottie.asset('assets/animations/saldo.json'),
              ),
              Gap(30),
              SizedBox(
                width: 360,
                child: Text(
                  'Wpisz swoją aktualną kwotę którą chcesz zarządzać!',
                  textAlign: TextAlign.center,
                  style: msstyles.mysavingAuthTitleStyle,
                ),
              ),
              Gap(30),
              addingForm()
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget addingForm() {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        // if (_formKey.currentState!.validate()) {
        //   Navigator.of(context).push<void>(MySavingTutorial.route());
        // }
      },
      builder: (context, state) {
        if (state is DashboardLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is DashboardError) {
          return Center(
            child: Text('Coś poszło nie tak'),
          );
        }
        if (state is DashboardSuccess) {
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
                              fontSize: 14, fontWeight: FontWeight.bold, color: MySavingColors.defaultGreyText),
                          filled: true,
                          fillColor: MySavingColors.defaultCategories,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: msstyles.mysavingExpensesAddingFormInputBorder,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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

                          context.read<DashboardCubit>().addSaldo(cost);

                          _costController.clear();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const MainPage()),
                          );
                        }
                      },
                      child: Text('Dodaj'),
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
