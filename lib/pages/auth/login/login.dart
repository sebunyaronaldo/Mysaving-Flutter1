import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/common/utils/mysaving_images.dart';
import 'package:mysavingapp/data/repositories/apple_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:unicons/unicons.dart';
import '../../../common/styles/mysaving_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../others/apple/cubit/apple_cubit.dart';
import '../register/register.dart';
import 'cubit/login_cubit.dart';
import 'helpers/forgot_password_page.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static Page<void> page() => const MaterialPage<void>(child: LoginScreen());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginScreen());
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
                create: (_) => LoginCubit(AuthRepository()),
              ),
              BlocProvider<AppleCubit>(
                create: (context) => AppleCubit(AppleRepository(FirebaseAuth.instance)),
              ),
              // BlocProvider<GoogleCubit>(
              //   create: (context) => GoogleCubit(GoogleRepository()),
              // ),
            ],
            child: LoginForm(),
          ),
        ),
      )),
    );
  }
}

// ignore: must_be_immutable
class LoginForm extends StatelessWidget {
  LoginForm({super.key});
  MySavingImages images = MySavingImages();
  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);
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
        if (state.status == LoginStatus.success &&
            state.password.length > 5 &&
            regex.hasMatch(state.email) &&
            state.email.isNotEmpty &&
            state.password.isNotEmpty) {}
        if (state.status == LoginStatus.error) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Oops... Something went wrong",
            ),
          );
        }
        if (state.status == LoginStatus.success && state.password.length < 5 && state.password.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Wpisałeś za krótkie hasło",
            ),
          );
        }
        if (state.status == LoginStatus.success && !regex.hasMatch(state.email) && state.email.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Wpisałeś zły email",
            ),
          );
        }
        if (state.status == LoginStatus.success && state.email.isEmpty && state.password.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Nie wpisałeś email",
            ),
          );
        }
        if (state.status == LoginStatus.success && state.password.isEmpty && state.email.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Nie wpisałeś password",
            ),
          );
        }
        if (state.status == LoginStatus.success && state.email.isEmpty && state.password.isEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Wypełnij formularz",
            ),
          );
        }
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
          SizedBox(
            height: 20,
          ),
          LoginPasswordTextField(),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push<void>(ForgotPasswordScreen.route());
                    },
                    child: Text('Przypomnij hasło'))
                // AppleLoginScreen(),
              ],
            ),
          ),
          Gap(20),
          LoginButton(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Nie posiadasz konta?'),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push<void>(RegisterScreen.route());
                  },
                  child: Text('Zarejestruj się'))
            ],
          ),
          // Text(
          //   'LUB',
          //   style: msstyles.mysavingNavNameStyle,
          // ),
          // SizedBox(
          //   height: 20,
          // ),
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

class LoginPasswordTextField extends StatefulWidget {
  const LoginPasswordTextField({super.key});

  @override
  _LoginPasswordTextFieldState createState() => _LoginPasswordTextFieldState();
}

class _LoginPasswordTextFieldState extends State<LoginPasswordTextField> {
  bool _obscurePassword = true;

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
              obscureText: _obscurePassword, // Hide or show password based on this flag
              onChanged: (password) {
                context.read<LoginCubit>().passwordChanged(password);
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
          ),
        ],
      );
    });
  }
}

class LoginButton extends StatelessWidget {
  LoginButton({super.key});
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
                      onPressed: () {
                        context.read<LoginCubit>().singInFormSubmitted();
                      },
                      child: Text('Login')),
                );
        });
  }
}
