import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:mysavingapp/data/repositories/profile_repository.dart';
import 'package:mysavingapp/pages/app_tutorial/mysaving_tutorial.dart';
import '../../common/styles/mysaving_styles.dart';
import '../../common/utils/mysaving_images.dart';
import '../settings/pages/profile/config/cubit/profile_cubit.dart';

// ignore: must_be_immutable
class WelcomeTutorialScreen extends StatelessWidget {
  WelcomeTutorialScreen({super.key});
  static Page<void> page() => MaterialPage<void>(child: WelcomeTutorialScreen());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => WelcomeTutorialScreen());
  }

  MySavingImages images = MySavingImages();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: BlocProvider<ProfileCubit>(
        create: (context) => ProfileCubit(profileRepository: ProfileRepository())..fetchProfile(),
        child: welcomeBloc(),
      ))),
    );
  }

  Widget welcomeBloc() {
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
            child: Text('Coś poszlo nie tak'),
          );
        }
        if (state is ProfileLoaded) {
          var msstyles = MySavingStyles(context);
          final profiles = state.profiles;
          return Center(
            child: Column(children: [
              Gap(180),
              SvgPicture.asset(
                images.mysavingLogo,
              ),
              Gap(100),
              Text(
                'Witaj ${profiles![0].name} w MySaving!',
                style: msstyles.mysavingAuthTitleStyle,
              ),
              Gap(30),
              SizedBox(
                width: 350,
                child: Text(
                  'Kliknij w przycisk aby zacząć oszczędzać na swoje marzenia!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF202020), fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ),
              Gap(80),
              Container(
                height: 44.0,
                width: 250,
                decoration: msstyles.mysavingButtonContainerStyles,
                child: ElevatedButton(
                    style: msstyles.mysavingButtonStyles,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MySavingTutorial.route());
                    },
                    child: Text('Zacznijmy')),
              ),
            ]),
          );
        }
        return Container();
      },
    );
  }
}
