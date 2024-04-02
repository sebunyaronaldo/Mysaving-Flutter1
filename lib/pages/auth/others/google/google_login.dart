// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gap/gap.dart';
// import 'package:mysavingapp/data/repositories/google_repository.dart';
// import 'package:mysavingapp/pages/auth/login/login.dart';
// import 'package:mysavingapp/pages/auth/others/google/cubit/google_cubit.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';

// import '../../../../common/helpers/mysaving_snackbar.dart';
// import '../../../../common/styles/mysaving_styles.dart';
// import '../../../../common/utils/mysaving_images.dart';
// import '../../../app_tutorial/welcome_tutorial.dart';
// import '../../register/register.dart';

// class GoogleLoginScreen extends StatelessWidget {
//   const GoogleLoginScreen({super.key});
//   static Route route() {
//     return MaterialPageRoute<void>(builder: (_) => const GoogleLoginScreen());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<GoogleCubit>(
//       create: (_) => GoogleCubit(GoogleRepository()),
//       child: GoogleLoginForm(),
//     );
//   }
// }

// class GoogleLoginForm extends StatelessWidget {
//   const GoogleLoginForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: Padding(
//         padding: EdgeInsets.all(40),
//         child: SingleChildScrollView(
//           child: MultiBlocProvider(
//             providers: [
//               BlocProvider<GoogleCubit>(
//                 create: (context) => GoogleCubit(GoogleRepository()),
//               ),
//             ],
//             child: LoginForm(),
//           ),
//         ),
//       )),
//     );
//   }
// }

// class LoginForm extends StatelessWidget {
//   LoginForm({super.key});
//   MySavingImages images = MySavingImages();
//   @override
//   Widget build(BuildContext context) {
//     var msstyles = MySavingStyles(context);
//     return BlocListener<GoogleCubit, GoogleState>(
//       listener: (context, state) {
//         if (state.status == GoogleStatus.success) {
//           Navigator.of(context).pushReplacement(WelcomeTutorialScreen.route());
//         }
//       },
//       child: Column(
//         children: [
//           Gap(70),
//           SvgPicture.asset(
//             images.mysavingLogo,
//           ),
//           Gap(40),
//           Text(
//             'Zaloguj się z Google',
//             style: msstyles.mysavingAuthTitleStyle,
//           ),
//           Gap(60),
//           Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GoogleLogin(),
//                 // AppleLoginScreen(),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Text(
//             'LUB',
//             style: msstyles.mysavingNavNameStyle,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Wróć do '),
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(context).push<void>(LoginScreen.route());
//                   },
//                   child: Text('Logowania tardycyjnego'))
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ignore: must_be_immutable
// class GoogleLogin extends StatelessWidget {
//   GoogleLogin({super.key});
//   MySavingImages images = MySavingImages();
//   @override
//   Widget build(BuildContext context) {
//     var msstyles = MySavingStyles(context);
//     return BlocBuilder<GoogleCubit, GoogleState>(
//       buildWhen: (previous, current) => previous.status != current.status,
//       builder: (context, state) {
//         return state.status == GoogleStatus.submitting
//             ? const CircularProgressIndicator.adaptive()
//             : Container(
//                 height: 44,
//                 width: 250,
//                 decoration: msstyles.mysavingButtonContainerStyles,
//                 child: ElevatedButton(
//                   style: msstyles.mysavingButtonStyles,
//                   onPressed: () {
//                     context.read<GoogleCubit>().signUpFormSubmitted();
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                           width: 20, child: Image.asset(images.googleImage)),
//                       Gap(10),
//                       Text('Zaloguj się z Google')
//                     ],
//                   ),
//                 ),
//               );
//       },
//     );
//   }
// }
