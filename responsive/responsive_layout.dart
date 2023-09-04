import 'package:flutter/material.dart';
import 'package:team_39_application/responsive/desktop_body.dart';
import 'package:team_39_application/responsive/mobile_body.dart';
import 'package:team_39_application/responsive/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;

  ResponsiveLayout({required this.mobileBody, required this.desktopBody});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (constant, constraints) {
          if (constraints.maxWidth < mobileWidth) {
            return mobileBody;
          } else {
            return desktopBody;
          }
        }
    );
  }
}