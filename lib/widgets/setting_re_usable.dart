import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetiingReUsable extends StatelessWidget {
  SetiingReUsable({
    required this.iconName,
    required this.tileName,
    required this.tapClick,
    this.themeIcon,
    Key? key,
  }) : super(key: key);

  IconData iconName;
  String tileName;
  IconData? themeIcon;
  Function tapClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          onTap: () {
            tapClick();
          },
          child: Row(
            children: [
              Icon(
                iconName,
                size: 36,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                tileName,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    themeIcon,
                    size: 35,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
