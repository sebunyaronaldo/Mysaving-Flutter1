import 'package:shared_preferences/shared_preferences.dart';

class DarkModeSwitch {
  static bool _isDarkMode = false;

  static bool get isDarkMode => _isDarkMode;

  static Future<void> initDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
  }

  static Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  static void resetDarkMode() {
    _isDarkMode = false;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isDarkMode', _isDarkMode);
    });
  }

  static Future<void> storeDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }
}
