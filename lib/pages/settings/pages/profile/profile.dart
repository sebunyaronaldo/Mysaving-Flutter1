import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysavingapp/common/helpers/mysaving_header.dart';
import 'package:mysavingapp/data/repositories/auth_repository.dart';
import 'package:mysavingapp/pages/settings/pages/profile/helpers/profile_dialog_content.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:unicons/unicons.dart';
import '../../../../common/theme/bloc/theme_bloc.dart';
import '../../../../common/theme/theme_constants.dart';
import '../../../../common/utils/mysaving_colors.dart';
import 'config/cubit/profile_cubit.dart';
import '../../widgets/settings_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
  static Page<void> page() => const MaterialPage<void>(child: Profile());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const Profile());
  }
}

class _ProfileState extends State<Profile> {
  void changeTheme() {
    DarkModeSwitch.toggleDarkMode();
    setState(() {}); // Odświeżenie widoku po zmianie trybu
  }

  @override
  void initState() {
    super.initState();
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
              MySavingHeader(
                informationHeader: AppLocalizations.of(context)!.headerProfile,
              ),
              Gap(20),
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

  bool _obscurePassword = true;

  Widget buttonsForm() {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
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
          final profileCubit = context.read<ProfileCubit>();

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

          void showErrorBadEmail() {
            Future.delayed(Duration.zero, () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: AppLocalizations.of(context)!.infoStatisitcModalTitle,
                text: AppLocalizations.of(context)!.errorBadEmailContent,
                backgroundColor: Colors.black,
                titleColor: Colors.white,
                textColor: Colors.white,
              );
            });
          }

          void showErrorBadPassword() {
            Future.delayed(Duration.zero, () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: AppLocalizations.of(context)!.infoStatisitcModalTitle,
                text: AppLocalizations.of(context)!.errorBadPasswordContent,
                backgroundColor: Colors.black,
                titleColor: Colors.white,
                textColor: Colors.white,
              );
            });
          }

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

          Future<void> _pickImageFromGallery() async {
            final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (pickedImage != null) {
              final imagePath = pickedImage.path;
              profileCubit.updateProfilePicture(imagePath);
              showSucces();
              setState(() {});
            }
          }

          void _showPasswordChangeDialog(BuildContext context) {
            showDialog(
              context: context,
              builder: (context) {
                return ProfileDialogContent(
                  formatter: [],
                  textInputType: TextInputType.name,
                  buttonMethod: () {
                    if (_passwordController.text.isEmpty) {
                      showErrorChangeEmail();
                    } else if (_passwordController.text.length < 5 && _passwordController.text.isNotEmpty) {
                      showErrorBadPassword();
                    } else {
                      profileCubit.updatePassword(_passwordController.text);
                      AuthRepository().changePassword(_passwordController.text);
                      showSucces();
                      setState(() {});

                      Navigator.of(context).pop();
                    }
                  },
                  dialogTitle: AppLocalizations.of(context)!.profileSettingsTwo,
                  obscureText: _obscurePassword,
                  icon: UniconsLine.asterisk,
                  controller: _passwordController,
                  hintText: AppLocalizations.of(context)!.profilePopupPasswordInput,
                );
              },
            );
          }

          void _openEmailForm(BuildContext context) {
            showDialog(
              context: context,
              builder: (context) {
                const pattern = r"(?:[a-z0-9!#//$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                    r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                    r'\x7f]|\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                    r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                    r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                    r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                    r'x21-\x5a\x53-\x7f]|\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                final regex = RegExp(pattern);
                return ProfileDialogContent(
                  formatter: [],
                  textInputType: TextInputType.emailAddress,
                  buttonMethod: () {
                    if (_emailController.text.isEmpty) {
                      showErrorChangeEmail();
                    } else if (!regex.hasMatch(_emailController.text) && _emailController.text.isNotEmpty) {
                      showErrorBadEmail();
                    } else {
                      profileCubit.updateEmail(_emailController.text);
                      showSucces();

                      setState(() {});
                      Navigator.of(context).pop();
                    }
                  },
                  dialogTitle: AppLocalizations.of(context)!.profileSettingsThree,
                  obscureText: false,
                  icon: UniconsLine.envelope,
                  controller: _emailController,
                  hintText: AppLocalizations.of(context)!.profilePopupEmailInput,
                );
              },
            );
          }

          void _openNameForm(BuildContext context) {
            showDialog(
              context: context,
              builder: (context) {
                return ProfileDialogContent(
                  formatter: [],
                  textInputType: TextInputType.name,
                  buttonMethod: () {
                    if (_nameController.text.isEmpty) {
                      showErrorChangeEmail();
                    } else {
                      profileCubit.updateName(_nameController.text);
                      showSucces();
                      setState(() {});
                      Navigator.of(context).pop();
                    }
                  },
                  dialogTitle: AppLocalizations.of(context)!.profileSettingsOne,
                  obscureText: false,
                  icon: UniconsLine.user,
                  controller: _nameController,
                  hintText: AppLocalizations.of(context)!.profilePopupNameInput,
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
                    AppLocalizations.of(context)!.profileSettingsTitle,
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
                buttonText: AppLocalizations.of(context)!.profileSettingsOne,
                buttonMethod: () {
                  _openNameForm(context);
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultBlueText,
              ),
              Gap(25),
              SettingsButton(
                icon: UniconsLine.asterisk,
                buttonText: AppLocalizations.of(context)!.profileSettingsTwo,
                buttonMethod: () {
                  _showPasswordChangeDialog(context);
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultBlueText,
              ),
              Gap(25),
              SettingsButton(
                icon: UniconsLine.envelope,
                buttonText: AppLocalizations.of(context)!.profileSettingsThree,
                buttonMethod: () {
                  _openEmailForm(context);
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultBlueText,
              ),
              Gap(25),
              SettingsButton(
                icon: UniconsLine.image,
                buttonText: AppLocalizations.of(context)!.profileSettingsFour,
                buttonMethod: () {
                  _pickImageFromGallery();
                },
                containerColor: MySavingColors.settingsButtonBackground,
                iconColor: MySavingColors.defaultBlueText,
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
