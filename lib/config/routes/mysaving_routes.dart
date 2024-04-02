import 'package:flutter/material.dart';
import 'package:mysavingapp/pages/main_page/main_page.dart';

import '../../bloc/app_bloc.dart';
import '../../pages/auth/login/login.dart';

List<Page<dynamic>> onGeneratedMysavingViewPages(
  AppStatus status,
  List<Page<dynamic>> pages,
) {
  switch (status) {
    case AppStatus.authenticated:
      return [MainPage.page()];
    case AppStatus.unauthenticated:
      return [LoginScreen.page()];
  }
}
