import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysavingapp/common/utils/mysaving_colors.dart';
import 'package:mysavingapp/data/repositories/profile_repository.dart';

import '../../pages/settings/pages/profile/config/cubit/profile_cubit.dart';
import '../../pages/settings/pages/profile/profile.dart';
import '../styles/mysaving_styles.dart';
import '../utils/mysaving_images.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class MySavingUpNav extends StatelessWidget {
  MySavingUpNav({super.key});
  MySavingImages images = MySavingImages();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(profileRepository: ProfileRepository())..fetchProfile(),
      child: navBloc(),
    );
  }

  Widget navBloc() {
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
          var msstyles = MySavingStyles(context);
          String initials = profiles![0].name.isNotEmpty
              ? profiles[0].name.trim().split(' ').map((part) => part[0]).take(2).join().toUpperCase()
              : profiles[0].name.isNotEmpty // Jeśli jest tylko jedno słowo, zwróć jedną literę
                  ? profiles[0].name[0].toUpperCase()
                  : "";
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 10, top: 20),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      profiles[0].pictureImage.isEmpty
                          ? InkWell(
                              onTap: () {
                                Navigator.of(context).push<void>(Profile.route());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(colors: [
                                      Color(0xFF407AFF),
                                      Color(0xFF91F2C5),
                                    ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.transparent,
                                  child: Text(
                                    initials,
                                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).push<void>(Profile.route());
                              },
                              child: Container(
                                width: 50,
                                child: CircleAvatar(
                                  radius: 30,
                                  // Adjust the radius as per your requirements
                                  backgroundImage: NetworkImage("${profiles[0].pictureImage}"),
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.dashboardHelloMessage,
                              style: TextStyle(fontSize: 16, color: MySavingColors.defaultDarkText),
                            ),
                            Text(
                              profiles[0].name,
                              style: msstyles.mysavingNavNameStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // IconButton(
                //     onPressed: () {},
                //     icon: Icon(Icons.notifications,
                //         color: MySavingColors.defaultDarkText))
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
