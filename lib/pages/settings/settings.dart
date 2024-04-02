import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mysavingapp/data/repositories/dashboard_repository.dart';
import 'package:mysavingapp/pages/dashboard/conf/cubit/dashboard_cubit.dart';
import 'package:mysavingapp/pages/settings/pages/general/general_settings.dart';
import 'package:mysavingapp/pages/settings/pages/others/others.dart';
import 'package:mysavingapp/pages/settings/pages/profile/config/cubit/profile_cubit.dart';
import 'package:mysavingapp/pages/settings/pages/profile/profile.dart';
import 'package:mysavingapp/pages/settings/widgets/settings_button.dart';
import 'package:mysavingapp/pages/settings/widgets/settings_switch.dart';
import 'package:unicons/unicons.dart';

import '../../bloc/app_bloc.dart';
import '../../common/theme/bloc/theme_bloc.dart';
import '../../common/utils/mysaving_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    this.switchValue,
    this.switchFunction,
    this.initialTabIndex = 0,
  });
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SettingsScreen());
  }

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
  final bool? switchValue;
  final Function(bool)? switchFunction;
  final int initialTabIndex;
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MySavingColors.defaultBackgroundPage,
      body: SafeArea(
        child: SingleChildScrollView(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>(
                create: (context) => ProfileCubit()..fetchProfile(),
              ),
              BlocProvider<DarkModeBloc>(
                create: (context) => DarkModeBloc(),
              ),
              BlocProvider<DashboardCubit>(
                create: (context) => DashboardCubit(dashboardRepository: DashboardRepository()),
              ),
            ],
            child: settingsForm(),
          ),
        ),
      ),
    );
  }

  Widget settingsForm() {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ProfileLoading) {
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
        if (state is ProfileError) {
          return Center(
            child: Text('Cos poszlo nie tak'),
          );
        }
        if (state is ProfileLoaded) {
          return Column(
            children: [
              // ProfileNav(),
              Gap(30),
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
          if (state is ProfileError) {
            return Center(
              child: Text('Cos poszlo nie tak'),
            );
          }
          if (state is ProfileLoaded) {
            final profiles = state.profiles;
            String initials = profiles![0].name.isNotEmpty
                ? profiles[0].name.trim().split(' ').map((part) => part[0]).take(2).join().toUpperCase()
                : profiles[0].name.isNotEmpty // Jeśli jest tylko jedno słowo, zwróć jedną literę
                    ? profiles[0].name[0].toUpperCase()
                    : "";

            // Wyświetl dane profilowe
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
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ProfileError) {
          return Center(
            child: Text('Cos poszlo nie tak'),
          );
        }
        if (state is ProfileLoaded) {
          void _openNameForm(BuildContext context) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: MySavingColors.defaultBackgroundPage,
                  title: Text(
                    AppLocalizations.of(context)!.settingsUpgradePopup,
                    style: TextStyle(color: MySavingColors.defaultDarkText),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Zamknij"),
                    ),
                  ],
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
                    AppLocalizations.of(context)!.settingsTitle,
                    style: TextStyle(
                      color: MySavingColors.defaultGreyText,
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Gap(25),
              SettingsButton(
                icon: UniconsLine.user,
                buttonText: AppLocalizations.of(context)!.settingsOne,
                buttonMethod: () {
                  Navigator.of(context).push<void>(Profile.route());
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultBlueText,
              ),
              Gap(25),
              SettingsButton(
                icon: UniconsLine.location_point,
                buttonText: AppLocalizations.of(context)!.settingsTwo,
                buttonMethod: () {
                  Navigator.of(context).push<void>(GeneralSettingsPage.route());
                  // _openNameForm(context);
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultBlueText,
              ),
              Gap(25),
              SettingsSwitch(
                buttonText: AppLocalizations.of(context)!.settingsThree,
                switchValue: widget.switchValue!,
                switchFunction: (p0) => widget.switchFunction!(p0),
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultBlueText,
              ),
              Gap(25),
              SettingsButton(
                icon: UniconsLine.usd_circle,
                buttonText: AppLocalizations.of(context)!.settingsFour,
                buttonMethod: () {
                  _openNameForm(context);
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultBlueText,
              ),
              Gap(25),
              SettingsButton(
                icon: UniconsLine.info_circle,
                buttonText: AppLocalizations.of(context)!.settingsFive,
                buttonMethod: () {
                  Navigator.of(context).push<void>(Others.route());
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultBlueText,
              ),
              Gap(25),
              SettingsButton(
                icon: UniconsLine.signout,
                buttonText: AppLocalizations.of(context)!.settingsSix,
                buttonMethod: () {
                  context.read<AppBloc>().add(AppLogoutRequested());
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultRed,
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
