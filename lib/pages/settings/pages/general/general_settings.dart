import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/common/helpers/mysaving_header.dart';
import 'package:mysavingapp/data/repositories/dashboard_repository.dart';
import 'package:mysavingapp/pages/analitycs/config/cubit/analitycs_cubit.dart';
import 'package:mysavingapp/pages/dashboard/conf/cubit/dashboard_cubit.dart';
import 'package:mysavingapp/pages/settings/pages/general/cubit/general_cubit.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:unicons/unicons.dart';

import '../../../../common/theme/bloc/theme_bloc.dart';
import '../../../../common/utils/mysaving_colors.dart';
import '../../../../l10n/locale_provider.dart';
import '../../../expenses/config/cubit/expense_cubit.dart';
import '../../widgets/settings_button.dart';
import '../profile/config/cubit/profile_cubit.dart';
import '../profile/helpers/profile_dialog_content.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});
  static Page<void> page() => const MaterialPage<void>(child: GeneralSettingsPage());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const GeneralSettingsPage());
  }

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  late Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    const countdownDuration = Duration(days: 30);
    _countdownTimer = Timer(countdownDuration, () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MySavingColors.defaultBackgroundPage,
      body: SafeArea(
        child: SingleChildScrollView(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DashboardCubit>(
                create: (context) => DashboardCubit(dashboardRepository: DashboardRepository())..getSummary(),
              ),
              BlocProvider<GeneralCubit>(
                create: (context) => GeneralCubit()..fetchGeneral(),
              ),
              BlocProvider<ProfileCubit>(
                create: (context) => ProfileCubit()..fetchProfile(),
              ),
              BlocProvider<DarkModeBloc>(
                create: (context) => DarkModeBloc(),
              ),
              ChangeNotifierProvider<LocaleProvider>(
                create: (context) => LocaleProvider(),
              )
            ],
            child: settingsForm(),
          ),
        ),
      ),
    );
  }

  Widget settingsForm() {
    return BlocConsumer<GeneralCubit, GeneralState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GeneralLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is GeneralError) {
          return Center(
            child: Text('Cos poszlo nie tak'),
          );
        }
        if (state is GeneralLoaded) {
          return Column(
            children: [
              MySavingHeader(
                informationHeader: AppLocalizations.of(context)!.headerGeneral,
              ),
              Gap(10),
              profileImageBloc(),
              Gap(40),
              buttonsForm(),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget profileImageBloc() {
    return BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is ProfileError) {
            return Center(
              child: Text('Cos poszlo nie tak'),
            );
          }
          if (state is ProfileLoaded) {
            final profiles = state.profiles;
            // Wyświetl dane profilowe
            String initials = profiles![0].name.isNotEmpty
                ? profiles[0].name.trim().split(' ').map((part) => part[0]).take(2).join().toUpperCase()
                : profiles[0].name.isNotEmpty // Jeśli jest tylko jedno słowo, zwróć jedną literę
                    ? profiles[0].name[0].toUpperCase()
                    : "";
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profiles[0].pictureImage.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [
                                Color(0xFF407AFF),
                                Color(0xFF91F2C5),
                              ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundColor: Colors.transparent,
                            child: Text(
                              initials,
                              style: TextStyle(fontSize: 30.0, color: Colors.white),
                            ),
                          ),
                        )
                      : Container(
                          width: 150,
                          child: CircleAvatar(
                            radius: 60, // Adjust the radius as per your requirements
                            backgroundImage: NetworkImage("${profiles[0].pictureImage}"),
                          ),
                        ),
                  Gap(20),
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dashboardHelloMessage,
                        style: TextStyle(fontSize: 18, color: MySavingColors.defaultDarkText),
                      ),
                      Text(
                        "${profiles[0].name}",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MySavingColors.defaultDarkText),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return Container();
        });
  }

  Widget buttonsForm() {
    return BlocConsumer<GeneralCubit, GeneralState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GeneralLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is GeneralError) {
          return Center(
            child: Text('Cos poszlo nie tak'),
          );
        }
        if (state is GeneralLoaded) {
          TextEditingController _saldoController = TextEditingController();
          TextEditingController _expensesLimitController = TextEditingController();
          TextEditingController _savingsController = TextEditingController();

          TextEditingController _nameCategoryController = TextEditingController();
          void showSucces() {
            Future.delayed(Duration.zero, () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                title: AppLocalizations.of(context)!.succesSettingsModalTitle,
                text: AppLocalizations.of(context)!.succesSettingsModalContent,
                backgroundColor: Colors.black,
                titleColor: Colors.white,
                textColor: Colors.white,
              );
            });
          }

          void showErrorChangeEmail() {
            Future.delayed(Duration.zero, () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: AppLocalizations.of(context)!.infoStatisitcModalTitle,
                text: AppLocalizations.of(context)!.errorSettingsModal,
                backgroundColor: Colors.black,
                titleColor: Colors.white,
                textColor: Colors.white,
              );
            });
          }

          void _openEdit(BuildContext context) {
            showDialog(
                context: context,
                builder: (context) {
                  return ProfileDialogContent(
                    formatter: [],
                    textInputType: TextInputType.name,
                    buttonMethod: () {
                      if (_nameCategoryController.text.isEmpty) {
                        showErrorChangeEmail();
                      } else {
                        final expenseCubit = context.read<ExpenseCubit>();
                        final analitycsCubit = context.read<AnalitycsCubit>();
                        expenseCubit.updateCategoryName(_nameCategoryController.text);

                        analitycsCubit.addCustomNameCategory(_nameCategoryController.text);
                        showSucces();

                        Navigator.of(context).pop();
                        _nameCategoryController.clear();
                      }
                    },
                    dialogTitle: AppLocalizations.of(context)!.generalSettingsFive,
                    obscureText: false,
                    icon: UniconsLine.edit,
                    controller: _nameCategoryController,
                    hintText: AppLocalizations.of(context)!.generalPopupCategoryInput,
                  );
                });
          }

          void _showSaldoChangeDialog(BuildContext context) {
            showDialog(
              context: context,
              builder: (context) {
                return ProfileDialogContent(
                  formatter: [FilteringTextInputFormatter.digitsOnly],
                  textInputType: TextInputType.number,
                  buttonMethod: () {
                    if (_saldoController.text.isEmpty) {
                      showErrorChangeEmail();
                    } else {
                      final cost = int.tryParse(_saldoController.text) ?? 0;

                      ProfileCubit()..setSaldo(cost);
                      print('Cost: $cost');
                      _saldoController.clear();
                      showSucces();
                      setState(() {});
                      Navigator.of(context).pop();
                    }
                  },
                  dialogTitle: AppLocalizations.of(context)!.generalSettingsTwo,
                  obscureText: false,
                  icon: UniconsLine.asterisk,
                  controller: _saldoController,
                  hintText: AppLocalizations.of(context)!.generalPopupBalanceInput,
                );
              },
            );
          }

          void _showExpensesLimitChangeDialog(BuildContext context) {
            showDialog(
              context: context,
              builder: (context) {
                return ProfileDialogContent(
                  formatter: [FilteringTextInputFormatter.digitsOnly],
                  textInputType: TextInputType.number,
                  buttonMethod: () {
                    if (_expensesLimitController.text.isEmpty) {
                      showErrorChangeEmail();
                    } else {
                      final inputValue = _expensesLimitController.text;
                      print('Input Value: $inputValue'); // Add this line to check the input value
                      final cost = int.tryParse(_expensesLimitController.text) ?? 0;
                      print('Cost: $cost'); // Add this line to check the parsed value

                      DashboardCubit(dashboardRepository: DashboardRepository()).addMaxExpensesPerDay(cost);

                      _expensesLimitController.clear();
                      showSucces();
                      setState(() {});
                      Navigator.of(context).pop();
                    }
                  },
                  dialogTitle: AppLocalizations.of(context)!.generalSettingsThree,
                  obscureText: false,
                  icon: UniconsLine.asterisk,
                  controller: _expensesLimitController,
                  hintText: AppLocalizations.of(context)!.generalPopupLimitInput,
                );
              },
            );
          }

          void _showSavingsChangeDialog(BuildContext context) {
            showDialog(
              context: context,
              builder: (context) {
                return ProfileDialogContent(
                  formatter: [FilteringTextInputFormatter.digitsOnly],
                  textInputType: TextInputType.number,
                  buttonMethod: () {
                    if (_savingsController.text.isEmpty) {
                      showErrorChangeEmail();
                    } else {
                      final inputValue = _savingsController.text;
                      print('Input Value: $inputValue'); // Add this line to check the input value
                      final cost = int.tryParse(_savingsController.text) ?? 0;
                      print('Cost: $cost'); // Add this line to check the parsed value

                      DashboardCubit(dashboardRepository: DashboardRepository()).addToSavings(cost);

                      _savingsController.clear();
                      showSucces();
                      setState(() {});
                      Navigator.of(context).pop();
                    }
                  },
                  dialogTitle: AppLocalizations.of(context)!.generalSettingsOne,
                  obscureText: false,
                  icon: UniconsLine.asterisk,
                  controller: _savingsController,
                  hintText: AppLocalizations.of(context)!.generalPopupSavingsInput,
                );
              },
            );
          }

          void _showLanguagePicker(BuildContext context) {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                  title: Text(
                    AppLocalizations.of(context)!.generalPopupLanguageTitle,
                  ),
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(context);
                        GeneralCubit()..updateLanguage('en');
                        final provider = Provider.of<LocaleProvider>(context, listen: false);
                        provider.saveLocale(Locale('en')); // Save 'en' as selected language
                        // Update language when option is selected
                      },
                      child: Text('English'),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                        GeneralCubit()..updateLanguage('Ukrainian');
                        final provider = Provider.of<LocaleProvider>(context, listen: false);
                        provider.saveLocale(Locale('uk')); // Save 'es' as selected language
                        Navigator.pop(context);
                      },
                      child: Text('Ukrainian'),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                        GeneralCubit()..updateLanguage('pl');
                        final provider = Provider.of<LocaleProvider>(context, listen: false);
                        provider.saveLocale(Locale('pl')); // Save 'pl' as selected language
                        Navigator.pop(context);
                      },
                      child: Text('Polski'),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                        GeneralCubit()..updateLanguage('de');
                        DashboardCubit(dashboardRepository: DashboardRepository())..getSummary();
                        final provider = Provider.of<LocaleProvider>(context, listen: false);
                        provider.saveLocale(Locale('de')); // Save 'de' as selected language
                        Navigator.pop(context);
                      },
                      child: Text('Deutsch'),
                    ),
                    // Add more language options as needed
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                );
              },
            );
          }

          return Column(
            children: [
              Row(
                children: [
                  Gap(35),
                  Text(
                    AppLocalizations.of(context)!.generalSettingsTitle,
                    style: TextStyle(
                      color: Color(0xFF80818D),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Gap(25),
              SettingsButton(
                icon: UniconsLine.money_bill,
                buttonText: AppLocalizations.of(context)!.generalSettingsOne,
                buttonMethod: () {
                  _showSavingsChangeDialog(context);
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultGreen,
              ),
              Gap(25),
              SettingsButton(
                icon: UniconsLine.money_bill,
                buttonText: AppLocalizations.of(context)!.generalSettingsTwo,
                buttonMethod: () {
                  _showSaldoChangeDialog(context);
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultGreen,
              ),
              Gap(25),
              SettingsButton(
                icon: UniconsLine.money_bill_slash,
                buttonText: AppLocalizations.of(context)!.generalSettingsThree,
                buttonMethod: () {
                  _showExpensesLimitChangeDialog(context);
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultGreen,
              ),
              Gap(25),
              SettingsButton(
                icon: UniconsLine.language,
                buttonText: AppLocalizations.of(context)!.generalSettingsFour,
                buttonMethod: () {
                  _showLanguagePicker(context); // Show the language selection sheet
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultBlueText,
              ),
              Gap(25),
              SettingsButton(
                icon: UniconsLine.pen,
                buttonText: AppLocalizations.of(context)!.generalSettingsFive,
                buttonMethod: () {
                  _openEdit(context); // Show the language selection sheet
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultBlueText,
              ),
              Gap(25),
            ],
          );
        }
        return Container();
      },
    );
  }
}
