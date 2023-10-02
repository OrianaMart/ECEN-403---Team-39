import 'package:flutter/material.dart';
import 'login_screen.dart'; //Imports the login page
import 'home_page.dart';//Imports the home page
import 'sign_up.dart';

void main() {
  runApp(const MyApp()); //Runs app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the homepage of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        //title: 'Smart Inventory',
        //home: HomePage(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomePage(),
      },
    );
  }
}