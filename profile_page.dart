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
              /*CircleAvatar(
                radius: 53, // Change this radius for the width of the circular border
                backgroundColor: const Color(0xFF500000),
                child: CircleAvatar(
                  radius: 48, // This radius is the radius of the picture in the circle avatar itself.
                  backgroundImage: Image.asset(
                   'assets/seal_avatar.jpg'
                  ).image,
                ),
              ),

               */
              // Username information for students
              //const SizedBox(height: 5),
              //const Divider(
              //  color: Colors.grey,
              //),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.account_circle, size: 45, color: Color(0xFF87352F)),
                  const SizedBox(width: 20),
                  //const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const Text(
                          'Username: ',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B8B8B),
                          ),
                        ),
                      const SizedBox(height: 2),
                        Text(
                          username,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 5),

              // Name information for students (first and last name are populated on the same line
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.person, size: 45, color: Color(0xFF87352F)),
                  const SizedBox(width: 20),
                  //const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'First Name: ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B8B8B),
                        ),
                      ),
                      const SizedBox(height: 2),

                      Text(
                        '$firstName $lastName',
                        //softWrap: true,
                        style: const TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 5),

              // UIN information for students
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.numbers, size: 45, color: Color(0xFF87352F)),
                  const SizedBox(width: 20),
                  //const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'UIN: ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B8B8B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        uin,
                        style: const TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 5),

              // Email information for students
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.email, size: 45, color: Color(0xFF87352F)),
                  const SizedBox(width: 20),
                  //const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email: ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B8B8B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 5),

              // Phone number information for students
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.local_phone_rounded, size: 45, color: Color(0xFF87352F)),
                  const SizedBox(width: 20),
                  //const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phone Number: ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B8B8B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        phoneNumber,
                        style: const TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 5),

              if (!user.adminStatus || courseNumber != 'null')
              //const SizedBox(height: 20),

              // Class for students
              if (!user.adminStatus || courseNumber != 'null')
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.book, size: 45, color: Color(0xFF87352F)),
                    const SizedBox(width: 20),
                    //const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Course Information: ',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B8B8B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ECEN $courseNumber - Team $teamNumber',
                          style: const TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 5),
              //TESTING SOFT WRAP
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TESTING NAME: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B8B8B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'abcdhalfksjdfhlaksjdhfawefuhalskdjhfawehliaweufhaskjdfhlkawehjfliawuefhlaksjdfhawhefliawuefhajkshflawieufhaskjdfhalefhjkaw',
                    style: const TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'TESTING NAME: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B8B8B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  /*Flexible(
                    Text(
                    'abcdhalfksjdfhlaksjdhfawefuhalskdjhfawehliaweufhaskjdfhlkawehjfliawuefhlaksjdfhawhefliawuefhajkshflawieufhaskjdfhalefhjkaw',
                    style: const TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                  )

                   */
                ],
              ),

              if(user.adminStatus)
                const AdminUserDetails(),
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
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
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
      if(user.username != user.viewedUser)
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
            children: <Widget>[Text('Are you sure you want to permanently delete "${user.viewedUser}"')],
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
                if(user.viewedUser != '' && user.username != user.viewedUser) {
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
