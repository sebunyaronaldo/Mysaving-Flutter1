import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/data/repositories/auth_repository.dart';
import 'package:mysavingapp/pages/app_tutorial/welcome_tutorial.dart';
import 'package:mysavingapp/pages/auth/login/login.dart';
import 'package:mysavingapp/pages/auth/register/cubit/register_cubit.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:unicons/unicons.dart';

import '../../../common/styles/mysaving_styles.dart';
import '../../../common/utils/mysaving_images.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  static Page<void> page() => const MaterialPage<void>(child: RegisterScreen());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const RegisterScreen());
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
              BlocProvider<RegisterCubit>(
                create: (_) => RegisterCubit(AuthRepository()),
              ),
            ],
            child: RegisterForm(),
          ),
        ),
      )),
    );
  }
}

// ignore: must_be_immutable
class RegisterForm extends StatelessWidget {
  RegisterForm({super.key});
  MySavingImages images = MySavingImages();
  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            const pattern = r"(?:[a-z0-9!#//$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                r'\x7f]|\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                r'x21-\x5a\x53-\x7f]|\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
            final regex = RegExp(pattern);
            if (state.status == RegisterStatus.success &&
                state.password.length > 5 &&
                regex.hasMatch(state.email) &&
                state.email.isNotEmpty &&
                state.password.isNotEmpty) {
              Navigator.of(context).pushReplacement(WelcomeTutorialScreen.route());
            }
            if (state.status == RegisterStatus.error) {
              showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.error(
                  message: "Oops... Something went wrong",
                ),
              );
            }
            if (state.status == RegisterStatus.success && state.password.length < 5 && state.password.isNotEmpty) {
              showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.error(
                  message: "Wpisałeś za krótkie hasło",
                ),
              );
            }
            if (state.status == RegisterStatus.success && !regex.hasMatch(state.email) && state.email.isNotEmpty) {
              showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.error(
                  message: "Wpisałeś zły email",
                ),
              );
            }
            if (state.status == RegisterStatus.success && state.email.isEmpty && state.password.isNotEmpty) {
              showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.error(
                  message: "Nie wpisałeś email",
                ),
              );
            }
            if (state.status == RegisterStatus.success && state.password.isEmpty && state.email.isNotEmpty) {
              showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.error(
                  message: "Nie wpisałeś password",
                ),
              );
            }
            if (state.status == RegisterStatus.success && state.email.isEmpty && state.password.isEmpty) {
              showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.error(
                  message: "Wypełnij formularz",
                ),
              );
            }
          },
        ),
      ],
      child: Column(
        children: [
          Gap(70),
          SvgPicture.asset(
            images.mysavingLogo,
          ),
          Gap(40),
          Text(
            'Zarejestruj się',
            style: msstyles.mysavingAuthTitleStyle,
          ),
          Gap(60),
          RegisterNameTextField(),
          SizedBox(
            height: 20,
          ),
          RegisterEmailTextField(),
          SizedBox(
            height: 20,
          ),
          RegisterPasswordTextField(),
          Gap(60),
          RegisterButton(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Posiadasz konto?'),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(LoginScreen.route());
                  },
                  child: Text('Zaloguj się'))
            ],
          ),
        ],
      ),
    );
  }
}

class RegisterEmailTextField extends StatelessWidget {
  const RegisterEmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);
    return BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
      return Column(
        children: [
          SizedBox(
            height: 50,
            child: TextFormField(
              textAlignVertical: TextAlignVertical.bottom,
              onChanged: (email) {
                context.read<RegisterCubit>().emailChanged(email);
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.mail),
                  hintText: "Email",
                  hintStyle: msstyles.mysavingInputTextStyles,
                  focusedBorder: msstyles.mysavingInputBorderStyle,
                  enabledBorder: msstyles.mysavingInputBorderStyle),
            ),
          )
        ],
      );
    });
  }
}

class RegisterPasswordTextField extends StatefulWidget {
  const RegisterPasswordTextField({super.key});

  @override
  _RegisterPasswordTextFieldState createState() => _RegisterPasswordTextFieldState();
}

class _RegisterPasswordTextFieldState extends State<RegisterPasswordTextField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: 50,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                obscureText: _obscurePassword,
                onChanged: (password) {
                  context.read<RegisterCubit>().passwordChanged(password);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Hasło",
                  hintStyle: msstyles.mysavingInputTextStyles,
                  focusedBorder: msstyles.mysavingInputBorderStyle,
                  enabledBorder: msstyles.mysavingInputBorderStyle,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? UniconsLine.eye : UniconsLine.eye_slash,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

// ignore: must_be_immutable
class RegisterNameTextField extends StatelessWidget {
  RegisterNameTextField({super.key});
  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);
    return BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
      return Column(
        children: [
          SizedBox(
            height: 50,
            child: TextFormField(
              onChanged: (name) {
                context.read<RegisterCubit>().nameChanged(name);
              },
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.near_me),
                  hintText: "Nazwa",
                  hintStyle: msstyles.mysavingInputTextStyles,
                  focusedBorder: msstyles.mysavingInputBorderStyle,
                  enabledBorder: msstyles.mysavingInputBorderStyle),
            ),
          )
        ],
      );
    });
  }
}

class RegisterButton extends StatelessWidget {
  RegisterButton({super.key});
  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);
    return BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return state.status == RegisterStatus.submitting
              ? const CircularProgressIndicator.adaptive()
              : Container(
                  height: 44,
                  width: 250,
                  decoration: msstyles.mysavingButtonContainerStyles,
                  child: ElevatedButton(
                      style: msstyles.mysavingButtonStyles,
                      onPressed: () {
                        context.read<RegisterCubit>().signUpFormSubmitted();
                      },
                      child: Text('Register')),
                );
        });
  }
}
