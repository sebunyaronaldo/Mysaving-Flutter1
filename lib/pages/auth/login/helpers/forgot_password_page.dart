import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/common/utils/mysaving_images.dart';

import 'package:mysavingapp/pages/auth/login/login.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../common/styles/mysaving_styles.dart';
import '../../../../data/repositories/auth_repository.dart';

import '../cubit/login_cubit.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  static Page<void> page() => const MaterialPage<void>(child: ForgotPasswordScreen());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ForgotPasswordScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<LoginCubit>(
                create: (_) => LoginCubit(
                  AuthRepository(),
                ),
              ),

              // BlocProvider<GoogleCubit>(
              //   create: (context) => GoogleCubit(GoogleRepository()),
              // ),
            ],
            child: ForgotPasswordForm(),
          ),
        ),
      )),
    );
  }
}

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);
    MySavingImages images = MySavingImages();
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
            r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
            r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
            r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
            r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
            r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
            r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
        final regex = RegExp(pattern);
        if (state.status == LoginStatus.passwordResetSuccess && regex.hasMatch(state.email) && state.email.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Link do resetowania hasła został wysłany.',
            ),
          );
        }
        if (state.status == LoginStatus.passwordResetSuccess && !regex.hasMatch(state.email)) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Wpisałeś zły email",
            ),
          );
        }
        if (state.status == LoginStatus.passwordResetSuccess && state.email.isEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Nie wpisałeś email",
            ),
          );
        }

        // if (state.status == LoginStatus.error &&
        //     state.email.isEmpty &&
        //     missingEmail.code == 'missing-email') {
        //   showTopSnackBar(
        //     Overlay.of(context),
        //     CustomSnackBar.error(
        //       message: 'Nic nie wpisałeś.',
        //     ),
        //   );
        // }
        // if (state.status == LoginStatus.error &&
        //     state.email.isEmpty &&
        //     missingEmail.code != 'missing-email') {
        //   showTopSnackBar(
        //     Overlay.of(context),
        //     CustomSnackBar.error(
        //       message: 'Coś się poszło nie tak. Spróbuj ponownie.',
        //     ),
        //   );
        // }
      },
      child: Column(
        children: [
          Gap(90),
          SvgPicture.asset(
            images.mysavingLogo,
          ),
          Gap(40),
          Text(
            'Witaj z powrotem',
            style: msstyles.mysavingAuthTitleStyle,
          ),
          Gap(60),
          LoginEmailTextField(),
          Gap(60),
          ResetPasswordButton(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push<void>(LoginScreen.route());
                },
                child: Text('Wróć do Logowania'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginEmailTextField extends StatelessWidget {
  const LoginEmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return Column(
        children: [
          SizedBox(
            height: 50,
            child: TextFormField(
              textAlignVertical: TextAlignVertical.bottom,
              onChanged: (email) {
                context.read<LoginCubit>().emailChanged(email);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.mail),
                hintText: "Email",
                hintStyle: msstyles.mysavingInputTextStyles,
                focusedBorder: msstyles.mysavingInputBorderStyle,
                enabledBorder: msstyles.mysavingInputBorderStyle,
              ),
            ),
          )
        ],
      );
    });
  }
}

class ResetPasswordButton extends StatelessWidget {
  const ResetPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == LoginStatus.submitting
            ? const CircularProgressIndicator.adaptive()
            : Container(
                height: 44,
                width: 250,
                decoration: msstyles.mysavingButtonContainerStyles,
                child: ElevatedButton(
                  style: msstyles.mysavingButtonStyles,
                  onPressed: () async {
                    final email = context.read<LoginCubit>().state.email;
                    try {
                      if (email.isEmpty) {
                        // Handle case where email is missing
                        throw FirebaseAuthException(code: 'missing-email', message: 'Adres email musi zostać podany.');
                      }
                      await context.read<LoginCubit>().resetPassword(email);
                      // Successful password reset
                      showTopSnackBar(
                        Overlay.of(context),
                        CustomSnackBar.success(
                          message: 'Link do resetowania hasła został wysłany.',
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-email') {
                        // Invalid email
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                            message: 'Wpisałeś zły mail.',
                          ),
                        );
                      } else if (e.code == 'user-not-found') {
                        // User not found
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                            message: 'Nie ma takiego użytkownika',
                          ),
                        );
                      } else if (e.code == 'missing-email') {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                            message: 'Nic nie wpisałeś.',
                          ),
                        );
                      } else {
                        // Other errors
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                            message: 'Coś się popsuło. Spróbuj ponownie.',
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Przypomnij hasło'),
                ),
              );
      },
    );
  }
}
