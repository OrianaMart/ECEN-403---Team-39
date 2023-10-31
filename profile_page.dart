import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'sign_up.dart';
import 'navigator_drawer.dart';
import 'users_page.dart';
import 'history_page.dart';
import 'Data.dart' as user;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
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
      var temp = List<String>.filled(0, '', growable: true);

      if (!user.adminStatus) {
        temp = await getUserInfo(user.username);
      } else {
        temp = await getUserInfo(user.viewedUser);
      }

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
      appBar: AppBar(
        //creates top bar of the app that includes navigation widget
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
        leading: Builder(
          builder: (BuildContext context) {
            if (!user.adminStatus) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UsersPage(),
                      ));
                },
              );
            }
          },
        ),
      ),
      drawer: const NavigatorDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            children: [
              CircleAvatar(
                radius:
                    53, // Change this radius for the width of the circular border
                backgroundColor: const Color(0xFF500000),
                child: CircleAvatar(
                  radius:
                      48, // This radius is the radius of the picture in the circle avatar itself.
                  backgroundImage: Image.asset('assets/seal_avatar.jpg').image,
                ),
              ),
              // Username information for students
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle),
                  //const SizedBox(height: 10),
                  //const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username: ',
                        style: TextStyle(
                          fontSize: 20.0,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
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

              if (!user.adminStatus || courseNumber != 'null')
                const SizedBox(height: 20),

              // Class for students
              if (!user.adminStatus || courseNumber != 'null')
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
              if (!user.adminStatus || courseNumber != 'null')
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'ECEN $courseNumber - Team $teamNumber',
                    style: const TextStyle(
                      fontSize: 23.0,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              if (user.adminStatus) const AdminUserDetails(),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminUserDetails extends StatelessWidget {
  const AdminUserDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 15),
      ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFF963e3e)), // changes color of text
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFFdedede)), // changes color of button
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              // makes edges of button round instead of square
              borderRadius: BorderRadius.circular(12.0),
            ),
          ), // changes the color of the button
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const SignUpPage(),
          ));
        },
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Edit Account', style: TextStyle(fontSize: 15)),
        ),
      ),
      const SizedBox(height: 5),
      ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFF963e3e)), // changes color of text
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFFdedede)), // changes color of button
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              // makes edges of button round instead of square
              borderRadius: BorderRadius.circular(12.0),
            ),
          ), // changes the color of the button
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HistoryPage(),
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('View Checkout History', style: TextStyle(fontSize: 15)),
        ),
      ),
      const SizedBox(height: 5),
      if (user.username != user.viewedUser)
        ElevatedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
                const Color(0xFFFFFFFF)), // changes color of text
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color(0xFF963e3e)), // changes color of button
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                // makes edges of button round instead of square
                borderRadius: BorderRadius.circular(12.0),
              ),
            ), // changes the color of the button
          ),
          onPressed: () {
            _removalConfirmation(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Delete Account', style: TextStyle(fontSize: 15)),
          ),
        ),
    ]);
  }
}

//Function to make a pop out dialogue box appear when delete button is pushed
Future<void> _removalConfirmation(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Account'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Are you sure you want to permanently delete "${user.viewedUser}"')
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text('Go Back')),
          TextButton(
              onPressed: () async {
                if (user.viewedUser != '' && user.username != user.viewedUser) {
                  if (await removeUser(user.viewedUser) == 'Removed') {
                    user.equipment = '';
                    user.checkoutID = '';
                    user.requestID = '';
                    user.mlCategory = null;
                    user.viewedUser = '';
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const UsersPage(),
                      ),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('Delete')),
        ],
      );
    },
  );
}
