import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'login_screen.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstNameField = TextEditingController();
  final TextEditingController lastNameField = TextEditingController();
  final TextEditingController uinField = TextEditingController();
  final TextEditingController usernameField = TextEditingController();
  final TextEditingController passwordField = TextEditingController();
  final TextEditingController confirmPasswordField = TextEditingController();
  final TextEditingController emailField = TextEditingController();
  final TextEditingController confirmEmailField = TextEditingController();
  final TextEditingController phoneNumberField = TextEditingController();
  final TextEditingController teamNumberField = TextEditingController();
  final TextEditingController courseNumberField = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // Creates the app bar at the top of the screen
    return Scaffold(
      appBar: AppBar( //creates top bar of the app
        title: const Text(
          'Smart Inventory',
          style: TextStyle(
            fontSize: 24.0,
          ),
        textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF500000), //Sets background color of top bar to maroon
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            //mainAxisAlignment:MainAxisAlignment.start,
            children: <Widget>[

              //Creates the text at the top of the account creation screen
              const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Create your account.',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Create a free account or",
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
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
              //const SizedBox(height: 15),

              // Personal Information Text
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Step 1: Personal Information',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                controller: firstNameField,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                controller: lastNameField,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                controller: emailField,
                decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'ex: email@tamu.edu'
                ),
              ),
              TextFormField(
                controller: confirmEmailField,
                decoration: const InputDecoration(
                    labelText: 'Confirm E-mail',
                    hintText: 'ex: email@tamu.edu',
                ),
              ),
              TextFormField(
                controller: phoneNumberField,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextFormField(
                controller: uinField,
                decoration: const InputDecoration(labelText: 'UIN'),
              ),

              //Course Information Text
              const Align(
                child: SizedBox(height: 40),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Step 2: Course Information',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                controller: teamNumberField,
                decoration: const InputDecoration(labelText: 'Team Number'),
              ),
              TextFormField(
                controller: courseNumberField,
                decoration: const InputDecoration(
                    labelText: 'Course Number',
                    hintText: 'ex: 403 or 404'
                ),
              ),

              //Account Information Text
              const Align(
                child: SizedBox(height: 40),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Step 3: Account Information',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                controller: usernameField,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: passwordField,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              TextFormField(
                controller: confirmPasswordField,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
              ),

            // Submits information to data base and proceeds user to student home page
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () async{
                switch(await createStudentUser(usernameField.text, passwordField.text, int.parse(uinField.text), firstNameField.text, lastNameField.text, emailField.text, int.parse(phoneNumberField.text), int.parse(teamNumberField.text), int.parse(courseNumberField.text))){

                  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~CHECK ERROR CASES
                }
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF963e3e),
                ),
              child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}