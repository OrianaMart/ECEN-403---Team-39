import 'package:flutter/material.dart';
import 'model_controller.dart';
import 'package:flutter/services.dart';

void main () {
  runApp(ScannerApp());
}

class ScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return MaterialApp(
      title: 'Equipment Check',
      home: ScanningPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}