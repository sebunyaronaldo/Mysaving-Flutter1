import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  // Load the selected language from SharedPreferences
  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('selectedLanguage') ?? 'pl';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  // Save the selected language to SharedPreferences
  Future<void> saveLocale(Locale loc) async {
    _locale = loc;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', loc.languageCode);
    notifyListeners();
  }
}
