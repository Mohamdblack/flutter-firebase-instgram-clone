import 'package:flutter/material.dart';
import 'package:somGram/services/dark_theme_prefs.dart';

class DarkThemeProfider with ChangeNotifier {
  DarkThemePrefs darkThemeprefs = DarkThemePrefs();

  bool _darkTheme = false;
  bool get getDarkTheme => _darkTheme;

  set setDarkTheme(bool value) {
    _darkTheme = value;
    darkThemeprefs.setDarkTheme(value);
    notifyListeners();
  }
}
