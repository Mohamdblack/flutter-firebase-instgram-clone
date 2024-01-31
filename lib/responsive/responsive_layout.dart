import 'package:flutter/material.dart';

import '../utilis/dimensions.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
      },
    );
  }
}
