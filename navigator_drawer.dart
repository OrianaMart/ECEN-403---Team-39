import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_page.dart';
import 'equipment_page.dart';
import 'forms_page.dart';
import 'history_page.dart';
import 'Data.dart' as user;

class NavigatorDrawer extends StatelessWidget {
  const NavigatorDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //Creates navigation drawer
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 113,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF500000),
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 24.0,
                ),
              ),
            ),
          ),

          // Sends user back to home page when home button is pushed
          ListTile(
            //Home Drawer Option
            leading: const Icon(Icons.home),
            title: const Text(
              'Home',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF500000),
              ),
            ),
            onTap: () {
              user.equipment = '';
              user.checkoutID = '';
              user.requestID = '';
              user.viewedUser = '';
              user.mlCategory = null;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
            },
          ),

          //only displays notifications is user is an admin user
          if (user.adminStatus == true)
            // Sends user to the notifications page when this button is pushed
            ListTile(
              //Profile Drawer Option
              leading: const Icon(Icons.all_inbox),
              title: const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF500000),
                ),
              ),
              onTap: () {
                user.equipment = '';
                user.checkoutID = '';
                user.requestID = '';
                user.viewedUser = '';
                user.mlCategory = null;
                //Navigator to profile page goes here
              },
            ),

          //only displays profile is user is a student user
          if (user.adminStatus == false)
            // Sends user to the profile page when this button is pushed
            ListTile(
              //Profile Drawer Option
              leading: const Icon(Icons.person),
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF500000),
                ),
              ),
              onTap: () {
                user.equipment = '';
                user.checkoutID = '';
                user.requestID = '';
                user.viewedUser = '';
                user.mlCategory = null;
                //Navigator to profile page goes here
              },
            ),

          // Sends users to equipment search page
          ListTile(
            //Equipment Drawer Option
            leading: const Icon(Icons.shopping_cart),
            title: const Text(
              'Equipment',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF500000),
              ),
            ),
            onTap: () {
              user.equipment = '';
              user.checkoutID = '';
              user.requestID = '';
              user.viewedUser = '';
              user.mlCategory = null;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EquipmentPage(),
                  ));
            },
          ),

          // Sends user to page to submit forms for equipment checkout
          ListTile(
            //Forms Drawer Option
            leading: const Icon(Icons.checklist),
            title: const Text(
              'Forms',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF500000),
              ),
            ),
            onTap: () {
              user.equipment = '';
              user.checkoutID = '';
              user.requestID = '';
              user.viewedUser = '';
              user.mlCategory = null;
              // add more code here
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const FormsPage()));
            },
          ),

          //only displays notifications is user is an admin user
          if (user.adminStatus == true)
            // Sends user to the history page when this button is pushed
            ListTile(
              //Profile Drawer Option
              leading: const Icon(Icons.auto_stories_outlined),
              title: const Text(
                'Checkout History',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF500000),
                ),
              ),
              onTap: () {
                user.equipment = '';
                user.checkoutID = '';
                user.requestID = '';
                user.viewedUser = '';
                user.mlCategory = null;
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryPage(),
                    ));
                //Navigator to history page goes here
              },
            ),

          //only displays notifications is user is an admin user
          if (user.adminStatus == true)
            // Sends user to the users page when this button is pushed
            ListTile(
              //Profile Drawer Option
              leading: const Icon(Icons.person),
              title: const Text(
                'Users',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF500000),
                ),
              ),
              onTap: () {
                user.equipment = '';
                user.checkoutID = '';
                user.requestID = '';
                user.viewedUser = '';
                user.mlCategory = null;
                //Navigator to user page goes here
              },
            ),

          // Sends users to
          ListTile(
            //Forms Drawer Option
            leading: const Icon(Icons.camera_alt_rounded),
            title: const Text(
              'Scan',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF500000),
              ),
            ),
            onTap: () {
              user.equipment = '';
              user.checkoutID = '';
              user.requestID = '';
              user.viewedUser = '';
              user.mlCategory = 'Display';
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EquipmentPage(),
                  ));
            },
          ),

          //Sends user to logout confirmation pop up box
          ListTile(
            //Logout Drawer Option
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF500000),
              ),
            ),
            onTap: () {
              _logoutConfirmation(context);
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              // add more code here
            },
          ),
        ],
      ),
    );
  }
}

//Function to make a pop out dialogue box appear when logout button is pushed
Future<void> _logoutConfirmation(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Signing Out'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[Text('Are you sure you want to log out?')],
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
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                user.equipment = '';
                user.checkoutID = '';
                user.requestID = '';
                user.username = '';
                user.viewedUser = '';
                user.mlCategory = null;
                user.adminStatus = false;
                _performLogout(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('Logout')),
        ],
      );
    },
  );
}

//Function to perform the actions of logging out or not when either button is pushed on pop out dialogue box
void _performLogout(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}
