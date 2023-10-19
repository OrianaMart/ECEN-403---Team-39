import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'login_screen.dart';
import 'home_page.dart';
import 'equipment_page.dart';
import 'navigator_drawer.dart';
import 'sign_up.dart';
import 'Data.dart' as user;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}): super(key: key);
  @override
  ProfilePageState createState() {
    return ProfilePageState();
  }
}
class ProfilePageState extends State<ProfilePage> {
  String username = '';
  String uin = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String courseNumber = '';
  String teamNumber = '';

  @override
  void initState() {
    super.initState();
    () async {
      //gets the users information and stores it to a temp variable
      var temp = await getUserInfo(user.username);

      //stores the users name for display later
      username = temp[0];
      uin = temp[1];
      firstName = temp[2];
      lastName = temp[3];
      email = temp[4];
      phoneNumber = temp[5];
      courseNumber = temp[6];
      teamNumber = temp[7];

      //sets the page state to have the users name populated correctly
      setState(() {
        username;
        uin;
        firstName;
        lastName;
        email;
        phoneNumber;
        courseNumber;
        teamNumber;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //creates top bar of the app that includes navigation widget
        title: const Text(
          'Smart Inventory',
          style: TextStyle(
            fontSize: 24.0,
          ),
        textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF500000), //Sets background color of top bar to maroon
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),

      drawer: const NavigatorDrawer(),

        body: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Column(
                    children: [

                      // Username information for students
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Username: ',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          username,
                          style: const TextStyle(
                            fontSize: 23.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Name information for students (first and last name are populated on the same line
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Name: ',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            firstName,
                            style: const TextStyle(
                              fontSize: 23.0,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            ' ',
                            style: TextStyle(
                              fontSize: 23.0,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            lastName,
                            style: const TextStyle(
                              fontSize: 23.0,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // UIN information for students
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'UIN: ',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          uin,
                          style: const TextStyle(
                            fontSize: 23.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email information for students
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              'Email: ',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                          ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          email,
                          style: const TextStyle(
                            fontSize: 23.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Phone number information for students
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Phone Number: ',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          phoneNumber,
                          style: const TextStyle(
                            fontSize: 23.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Class for students
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Course Information: ',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'ECEN ',
                            style: TextStyle(
                              fontSize: 23.0,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            courseNumber,
                            style: const TextStyle(
                              fontSize: 23.0,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            ' - Team ',
                            style: TextStyle(
                              fontSize: 23.0,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            teamNumber,
                            style: const TextStyle(
                              fontSize: 23.0,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                ),
            ),
        ),
    );
  }
}


