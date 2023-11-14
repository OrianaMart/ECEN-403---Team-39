import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'home_page.dart';
import 'sign_up.dart';
import 'forgot_password_page.dart';
import 'Data.dart' as user;

import 'internet_checker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameField = TextEditingController();
  final TextEditingController passwordField = TextEditingController();

  bool invalidLogin = false;

  @override
  Widget build(BuildContext context) {
    initializeDatabase();
    // Creates app bar at the top of the screen that says "Smart Inventory"
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Smart Inventory',
                style: TextStyle(
                  fontSize: 24.0, // Changes font size of the Smart Inventory text in the app bar
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF500000), // Adds Maroon color to background of app bar
      ),
      // Creates the text and input text fields on the log in page
      body: Center(
        child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          //mainAxisAlignment:MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Align(
            alignment: Alignment.topLeft,
              child: Text(
                'Hello!',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Sign in to your account.",
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: usernameField,
              decoration: InputDecoration(labelText: 'Username',
              errorText: invalidLogin ? 'Incorrect Username or Password': null),
            ),
            TextFormField(
              controller: passwordField,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  //checks to see if the app is still connected to the internet
                  connectionCheck(context);

                  // Goes to forgot password page
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => const ForgotPasswordPage(),
                  ));
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () async{
                //checks to see if the app is still connected to the internet
                connectionCheck(context);

                if(usernameField.text.toString() != '' && passwordField.text.toString() != '') {
                  switch (await authenticate(usernameField.text,
                      passwordField.text)) { // implement authentication
                    case 'Valid Student':
                      {
                        user.username = usernameField.text.toString();
                        user.adminStatus = false;
                        setState(() {
                          invalidLogin = false;
                        });
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                      }
                      break;

                    case 'Valid Admin':
                      {
                        user.username = usernameField.text.toString();
                        user.adminStatus = true;
                        setState(() {
                          invalidLogin = false;
                        });
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                      }
                      break;

                    default:
                      {
                        setState(() {
                          invalidLogin = true;
                        });
                      }
                      break;
                  }
                  // Add login code here with database
                  // Include code to navigate to the homepage
                } else {

                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF963e3e),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //checks to see if the app is still connected to the internet
                      connectionCheck(context);

                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                      ));
                    },
                    child: const Text(
                      'Sign Up.',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

