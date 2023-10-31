import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Creates the forgot password page for the test app
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);
  @override
  ForgotPasswordPageState createState() {
    return ForgotPasswordPageState();
  }
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailField = TextEditingController();

  bool invalidEmail = false;

  var response = List<String>.filled(1, '', growable: true);

  Future sendPasswordEmail(
      String email, String name, String username, String password) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "service_id": "service_1nvn0iw",
          "template_id": "template_5nnfrsk",
          "user_id": '_eHi_zHyN4JO0d5a8',
          "accessToken": 'XcBCfW-cbWcRy2_eW64l_',
          "template_params": {
            "to_name": name,
            "user_name": username,
            "Password": password,
            "user_email": email,
          }
        }));
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //creates top bar of the app
        title: const Text(
          'Smart Inventory',
          style: TextStyle(
            fontSize: 24.0,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color(
            0xFF500000), //Sets background color of top bar to maroon
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Recover Password',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Input recovery email or return to",
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                      },
                      child: const Text(
                        'log in.',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: emailField,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  errorText: invalidEmail ? 'Invalid Email' : null,
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF963e3e),
                  ),
                  onPressed: () async {
                    if (emailField.text.toString() != '') {
                      response = (await forgotPassword(emailField.text));
                      switch (response[0]) {
                        case 'Invalid Email':
                          {
                            setState(() {
                              invalidEmail = true;
                            });
                          }
                          break;
                        default:
                          {
                            //sends email to the email address with the name, username, and password
                            if(await sendPasswordEmail(
                                emailField.text.toString(),
                                '${response[0]} ${response[1]}',
                                response[2],
                                response[3]) == 'OK') {
                              setState(() {
                                invalidEmail = false;
                                emailField.text = '';
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ));
                            }
                          }
                          break;
                      }
                    }
                  },
                  child: const Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
