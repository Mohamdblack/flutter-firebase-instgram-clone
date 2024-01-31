import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme
          ? const Color.fromARGB(255, 11, 11, 21)
          : const Color.fromARGB(255, 241, 240, 240),
      primaryColor: Colors.blue,
      colorScheme: ThemeData().colorScheme.copyWith(
            secondary: isDarkTheme ? Colors.black : Colors.white,
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          ),
      cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme
                ? const ColorScheme.dark()
                : const ColorScheme.light(),
          ),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: isDarkTheme ? Colors.white : Colors.black),
    );
  }
}
