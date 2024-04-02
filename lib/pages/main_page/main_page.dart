import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysavingapp/common/helpers/mysaving_bottom_nav_bar.dart';
import 'package:mysavingapp/common/theme/bloc/theme_bloc.dart';
import 'package:mysavingapp/common/utils/mysaving_colors.dart';
import 'package:mysavingapp/pages/expenses/expenses.dart';
import 'package:mysavingapp/pages/settings/settings.dart';

import '../../common/theme/theme_constants.dart';
import '../dashboard/dashboard.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key});

  static Page<void> page() => const MaterialPage<void>(child: MainPage());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const MainPage());
  }

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedIndex = 0;

  List<Widget> _widgetOptions(BuildContext context) {
    return [
      Dashboard(),
      ExpensesScreen(),
      SettingsScreen(
        switchValue: DarkModeSwitch.isDarkMode,
        switchFunction: (value) {
          _toggleDarkMode(context);
        },
      ),
    ];
  }

  void _toggleDarkMode(BuildContext context) {
    setState(() {});
    BlocProvider.of<DarkModeBloc>(context).add(ToggleDarkModeEvent());
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // If the same tab is selected, do nothing
      return;
    }
    setState(() {
      if (index == 0) {
        // If the selected tab is the home icon, pop all routes except the first one
        _navigatorKey.currentState?.popUntil((route) => route.isFirst);
      }
      if (index > 0) {
        _navigatorKey.currentState?.popUntil((route) => route.isFirst);
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DarkModeBloc(),
      child: Scaffold(
        backgroundColor: MySavingColors.defaultBackgroundPage,
        body: SafeArea(
          child: Navigator(
            key: _navigatorKey,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) {
                  if (settings.name == '/') {
                    // Handle the default route to show the selected tab
                    return _widgetOptions(context).elementAt(_selectedIndex);
                  } else {
                    // Handle named routes for specific screens
                    switch (settings.name) {
                      case '/expenses':
                        return ExpensesScreen();
                      case '/settings':
                        return SettingsScreen(
                          switchValue: DarkModeSwitch.isDarkMode,
                          switchFunction: (value) {
                            _toggleDarkMode(context);
                          },
                        );
                      default:
                        return Container();
                    }
                  }
                },
              );
            },
          ),
        ),
        bottomNavigationBar: MySavingBottomNav(
          onTap: _onItemTapped,
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }
}
