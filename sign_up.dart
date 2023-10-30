import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'login_screen.dart';
import 'home_page.dart';
import 'users_page.dart';
import 'Data.dart' as user;

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

  bool invalidUsername = false;
  bool invalidUin = false;
  bool invalidEmail = false;
  bool invalidPhoneNumber = false;
  bool invalidCourseNumber = false;
  bool invalidPassword = false;

  bool student = false;

  String pageName = 'Create your account.';

  @override
  void initState() {
    super.initState();

    () async {
      //if a logged in admin is accessing this page
      if (user.adminStatus) {
        //if the logged in admin is editing an account
        if (user.viewedUser != '') {
          pageName = 'Edit account';

          var temp = await getUserInfo(user.viewedUser);

          print(temp);
          if(temp.length > 6 && temp[6] != 'null'){
            student = true;
          }
          print(student);
          setState(() {
            student;
            firstNameField.text = temp[2];
            lastNameField.text = temp[3];
            emailField.text = temp[4];
            confirmEmailField.text = temp[4];
            phoneNumberField.text = temp[5];
            uinField.text = temp[1];
            if(student) {
              teamNumberField.text = temp[7];
              courseNumberField.text = temp[6];
            }
          });
        } else {
          pageName = 'Create admin account.';
        }
      }

      setState(() {
        pageName;
        student;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    // Creates the app bar at the top of the screen
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
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            //mainAxisAlignment:MainAxisAlignment.start,
            children: <Widget>[
              //Creates the text at the top of the account creation screen
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  pageName,
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!user.adminStatus)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Create a free account or return to",
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
              if (user.adminStatus && user.viewedUser != '')
                const SizedBox(height: 15),

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
                    labelText: 'E-mail', hintText: 'ex: email@tamu.edu'),
              ),
              TextFormField(
                controller: confirmEmailField,
                decoration: InputDecoration(
                    labelText: 'Confirm E-mail',
                    hintText: 'ex: email@tamu.edu',
                    errorText: invalidEmail ? 'Invalid Email' : null),
              ),
              TextFormField(
                controller: phoneNumberField,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Phone Number',
                    errorText:
                        invalidPhoneNumber ? 'Invalid Phone Number' : null),
              ),
              TextFormField(
                controller: uinField,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'UIN',
                    errorText: invalidUin ? 'Invalid UIN' : null),
              ),

              //Course Information Text
              const Align(
                child: SizedBox(height: 40),
              ),
              if (!user.adminStatus || student)
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
              if (!user.adminStatus || student)
                TextFormField(
                  controller: teamNumberField,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Team Number'),
                ),
              if (!user.adminStatus || student)
                TextFormField(
                  controller: courseNumberField,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Course Number',
                      hintText: 'ex: 403 or 404',
                      errorText:
                          invalidCourseNumber ? 'Invalid Course Number' : null),
                ),

              if (!user.adminStatus)
                //Account Information Text
                const Align(
                  child: SizedBox(height: 40),
                ),
              if (!user.adminStatus)
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
              if (user.adminStatus && user.viewedUser == '')
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Step 2: Account Information',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (user.viewedUser == '')
                TextFormField(
                  controller: usernameField,
                  decoration: InputDecoration(
                      labelText: 'Username',
                      errorText:
                          invalidUsername ? 'Username Already Exists' : null),
                ),
              if (user.viewedUser == '')
                TextFormField(
                  controller: passwordField,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
              if (user.viewedUser == '')
                TextFormField(
                  controller: confirmPasswordField,
                  decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      errorText:
                          invalidPassword ? 'Passwords Do Not Match' : null),
                ),

              // Submits information to data base and proceeds user to student home page
              const SizedBox(height: 5),
              if (!user.adminStatus)
                ElevatedButton(
                  onPressed: () async {
                    invalidUsername = false;
                    invalidUin = false;
                    invalidEmail = false;
                    invalidPhoneNumber = false;
                    invalidCourseNumber = false;
                    invalidPassword = false;

                    if (emailField.text != confirmEmailField.text) {
                      invalidEmail = true;
                    }
                    if (passwordField.text != confirmPasswordField.text) {
                      invalidPassword = true;
                    }

                    if (!invalidEmail && !invalidPassword) {
                      switch (await createStudentUser(
                          usernameField.text,
                          passwordField.text,
                          int.parse(uinField.text),
                          firstNameField.text,
                          lastNameField.text,
                          emailField.text,
                          int.parse(phoneNumberField.text),
                          int.parse(teamNumberField.text),
                          int.parse(courseNumberField.text))) {
                        case 'Invalid Username':
                          {
                            invalidUsername = true;
                          }
                          break;

                        case 'Invalid UIN':
                          {
                            invalidUin = true;
                          }
                          break;

                        case 'Invalid Email':
                          {
                            invalidEmail = true;
                          }
                          break;

                        case 'Invalid Phone Number':
                          {
                            invalidPhoneNumber = true;
                          }
                          break;

                        case 'Invalid Course Number':
                          {
                            invalidCourseNumber = true;
                          }
                          break;

                        case 'Created':
                          {
                            user.username = usernameField.text.toString();
                            user.adminStatus = false;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ));
                            setState(() {
                              invalidUsername = false;
                              invalidUin = false;
                              invalidEmail = false;
                              invalidPhoneNumber = false;
                              invalidCourseNumber = false;
                              invalidPassword = false;
                            });
                          }
                          break;
                      }
                    }

                    setState(() {
                      invalidUsername;
                      invalidUin;
                      invalidEmail;
                      invalidPhoneNumber;
                      invalidCourseNumber;
                      invalidPassword;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF963e3e),
                  ),
                  child: const Text('Submit'),
                ),

              //edit user
              if (user.viewedUser != '')
                ElevatedButton(
                    onPressed: () async {
                      invalidEmail = false;
                      invalidPhoneNumber = false;
                      invalidCourseNumber = false;

                      if (emailField.text != confirmEmailField.text) {
                        invalidEmail = true;
                      }

                      int teamNumber = 0;
                      int courseNumber = 0;

                      if(teamNumberField.text != '') {
                        teamNumber = int.parse(teamNumberField.text);
                      }

                      if(courseNumberField.text != '') {
                        if(int.parse(courseNumberField.text) == 403 || int.parse(courseNumberField.text) == 404) {
                          courseNumber = int.parse(courseNumberField.text);
                        } else {
                          invalidCourseNumber = true;
                        }
                      }

                      if(!invalidEmail && !invalidCourseNumber) {
                        switch (await editUserAccount(
                            user.viewedUser,
                            int.parse(uinField.text),
                            firstNameField.text,
                            lastNameField.text,
                            emailField.text,
                            int.parse(phoneNumberField.text),
                            teamNumber,
                            courseNumber)) {
                          case 'Invalid Email':
                            {
                              invalidEmail = true;
                            }

                            break;

                          case 'Invalid Phone Number':
                            {
                              invalidPhoneNumber = true;
                            }

                            break;

                          case 'Updated':
                            {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UsersPage(),
                                  ));
                              setState(() {
                                invalidEmail = false;
                                invalidPhoneNumber = false;
                                invalidCourseNumber = false;
                              });
                            }
                            break;
                        }

                      }
                      setState(() {
                        invalidEmail;
                        invalidPhoneNumber;
                        invalidCourseNumber;
                      });

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF963e3e),
                    ),
                    child: const Text('Submit')
                ),

              if (user.adminStatus && user.viewedUser == '')
                ElevatedButton(
                  onPressed: () async {
                    invalidUsername = false;
                    invalidUin = false;
                    invalidEmail = false;
                    invalidPhoneNumber = false;
                    invalidPassword = false;

                    if (emailField.text != confirmEmailField.text) {
                      invalidEmail = true;
                    }
                    if (passwordField.text != confirmPasswordField.text) {
                      invalidPassword = true;
                    }

                    if (!invalidEmail && !invalidPassword) {
                      switch (await createAdminUser(
                          usernameField.text,
                          passwordField.text,
                          int.parse(uinField.text),
                          firstNameField.text,
                          lastNameField.text,
                          emailField.text,
                          int.parse(phoneNumberField.text))) {
                        case 'Invalid Username':
                          {
                            invalidUsername = true;
                          }
                          break;

                        case 'Invalid UIN':
                          {
                            invalidUin = true;
                          }
                          break;

                        case 'Invalid Email':
                          {
                            invalidEmail = true;
                          }
                          break;

                        case 'Invalid Phone Number':
                          {
                            invalidPhoneNumber = true;
                          }
                          break;

                        case 'Created':
                          {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UsersPage(),
                                ));
                            setState(() {
                              invalidUsername = false;
                              invalidUin = false;
                              invalidEmail = false;
                              invalidPhoneNumber = false;
                              invalidCourseNumber = false;
                              invalidPassword = false;
                            });
                          }
                          break;
                      }
                    }

                    setState(() {
                      invalidUsername;
                      invalidUin;
                      invalidEmail;
                      invalidPhoneNumber;
                      invalidPassword;
                    });
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
