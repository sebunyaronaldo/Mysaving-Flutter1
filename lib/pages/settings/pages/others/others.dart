import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/common/helpers/mysaving_header.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common/theme/bloc/theme_bloc.dart';
import '../../../../common/theme/theme_constants.dart';
import '../../../../common/utils/mysaving_colors.dart';
import '../../widgets/settings_button.dart';
import '../profile/config/cubit/profile_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Others extends StatefulWidget {
  const Others({Key? key}) : super(key: key);

  @override
  State<Others> createState() => _OthersState();
  static Page<void> page() => const MaterialPage<void>(child: Others());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const Others());
  }
}

class _OthersState extends State<Others> {
  void changeTheme() {
    DarkModeSwitch.toggleDarkMode();
    setState(() {}); // Odświeżenie widoku po zmianie trybu
  }

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
            ],
            child: profileForm(),
          ),
        ),
      ),
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
                            radius: 65.0,
                            backgroundColor: Colors.transparent,
                            child: Text(
                              initials,
                              style: TextStyle(fontSize: 40.0, color: Colors.white),
                            ),
                          ),
                        )
                      : Container(
                          width: 150,
                          child: CircleAvatar(
                            radius: 75, // Adjust the radius as per your requirements
                            backgroundImage: NetworkImage("${profiles[0].pictureImage}"),
                          ),
                        ),
                  Column(
                    children: [
                      Gap(20),
                      Text(
                        "${profiles[0].name}",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MySavingColors.defaultDarkText),
                      ),
                      Gap(20),
                      Text(
                        "${profiles[0].email}",
                        style: TextStyle(fontSize: 18, color: MySavingColors.defaultDarkText),
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

  Widget profileForm() {
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
          return Column(
            children: [
              MySavingHeader(informationHeader: AppLocalizations.of(context)!.socialsSettingsTitle),
              Gap(20),
              profileImageBloc(),
              Gap(40),
              buttonsForm(),
              Gap(20),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget buttonsForm() {
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
          Future<void> _launchYoutube(Uri url) async {
            final Uri toLsunchYtube = Uri.parse('https://www.youtube.com/@MySaving-dj7ki');

            if (!await launchUrl(toLsunchYtube,
                mode: LaunchMode.externalApplication,
                webViewConfiguration: const WebViewConfiguration(headers: <String, String>{'lub': 'lubs'}))) {
              throw 'Could not launch $toLsunchYtube';
            }
          }

          Future<void> _launchFanpage(Uri url) async {
            final Uri toLaunch = Uri.parse('https://www.facebook.com/61550125618459');

            if (!await launchUrl(toLaunch,
                mode: LaunchMode.externalApplication,
                webViewConfiguration: const WebViewConfiguration(headers: <String, String>{'lub': 'lubs'}))) {
              throw 'Could not launch $toLaunch';
            }
          }

          final Map<String, String> queryParams = {
            'id': '61550125618459',
          };
          final Uri toLsunchYtube = Uri(
            scheme: 'https',
            host: 'www.youtube.com',
            path: '/@MySaving-dj7ki/about',
          );
          final Uri toLaunch = Uri(
            scheme: 'https',
            host: 'www.facebook.com',
            path: '/profile.php?id=',
            queryParameters: queryParams.map((key, value) {
              return MapEntry(key, Uri.encodeComponent(value));
            }),
          );
          return Column(
            children: [
              Row(
                children: [
                  Gap(35),
                  Text(
                    AppLocalizations.of(context)!.socialsSettingsTitle,
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
                icon: UniconsLine.facebook,
                buttonText: AppLocalizations.of(context)!.socialsSettingsOne,
                buttonMethod: () {
                  _launchFanpage(toLaunch);
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultBlueText,
              ),
              Gap(15),
              SettingsButton(
                icon: UniconsLine.youtube,
                buttonText: AppLocalizations.of(context)!.socialsSettingsTwo,
                buttonMethod: () {
                  _launchYoutube(toLsunchYtube);
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
