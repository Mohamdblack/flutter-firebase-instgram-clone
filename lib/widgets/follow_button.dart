import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../provider/dark_themes_provider.dart';

class followButton extends StatelessWidget {
  const followButton({
    Key? key,
    required this.themeState,
    this.function,
    required this.backgroudColor,
    required this.text,
    required this.textColor,
  }) : super(key: key);

  final DarkThemeProfider themeState;
  final Function()? function;
  final Color backgroudColor;
  // final Color borderColor;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: backgroudColor,
      ),
      child: Center(
        child: TextButton(
          onPressed: function,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
