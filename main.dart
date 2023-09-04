import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:team_39_application/responsive/responsive_layout.dart';
import 'navbar.dart';
import 'package:team_39_application/responsive/responsive_layout.dart';
import 'package:team_39_application/responsive/mobile_body.dart';
import 'package:team_39_application/responsive/desktop_body.dart';

//Database imports
import 'database_functions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'SmartInventory';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Colors.amber[400],
        ),
        backgroundColor: Colors.yellow[50],
        body: ResponsiveLayout(
          mobileBody: MyMobileBody(),
          desktopBody: MyDesktopBody(),
        ),
      ),
    );
  }
}