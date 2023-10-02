import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'login_screen.dart';
import 'equipment_page.dart';
import 'request_detail_page.dart';
import 'history_detail_page.dart';
import 'Data.dart' as user;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var requests = List<String>.filled(0, '', growable: true);
  var requestIDs = List<String>.filled(0, '', growable: true);

  var checkouts = List<String>.filled(0, '', growable: true);
  var historyIDs = List<String>.filled(0, '', growable: true);

  String firstName = '';

  @override
  void initState() {
    super.initState();
    () async {
      var temp = await getUserInfo(user.username);
      firstName = temp[2];

      requestIDs = await findRequests(user.username);
      if (requestIDs[0] == 'No Requests') {
        requests.add(requestIDs[0]);
      } else {
        for (int i = 0; i < requestIDs.length; i++) {
          var temp = await getRequestInfo(requestIDs[i]);
          requests.add(temp[2]);
        }
      }

      historyIDs = await historyIDbyUser(user.username);
      if (historyIDs[0] == 'No Checkout History') {
        checkouts.add(historyIDs[0]);
      } else {
        for (int i = 0; i < historyIDs.length; i++) {
          var temp = await getHistoryInfo(historyIDs[i]);
          if (temp.length < 7) {
            checkouts.add(temp[2]);
          } else if (int.parse(temp[6]) < int.parse(temp[3])) {
            checkouts.add(temp[2]);
          } else {
            historyIDs.removeAt(i);
            i--;
          }
        }
      }

      setState(() {
        firstName;

        requests;
        requestIDs;

        checkouts;
        historyIDs;
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
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),

      //Navigation drawer code starts here
      drawer: Drawer(
        //Creates navigation drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 115,
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

            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Hi, $firstName',
                style: const TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ));
              },
            ),

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
                //add code here
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
                // add more code here
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
                // add more code here
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
                user.username = '';
                user.adminStatus = false;
                _logoutConfirmation(context);
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                // add more code here
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // The top widget on the home page that shows requests the student currently has sent out
            Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 20
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF963e3e),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: const Offset(3, 4),
                    ),
                  ],
                  border: Border.all(
                    width: 3,
                    color: const Color(0xFF500000),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          'Requests',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if(requests.isNotEmpty && requests[0] != 'No Requests')
                        for (int i = 0; i < requests.length; i++)
                          Table(
                            children: [
                              TableRow(children: <Widget>[
                                Text(requests[i], style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 20,)),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color(
                                        0xFFdedede), // changes color of the text
                                    backgroundColor: const Color(
                                        0xFF963e3e), // changes the color of the button
                                  ),
                                  /*style: ButtonStyle( 0xFFdedede
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ))),
                                      */
                                  onPressed: () {
                                    user.equipment = requests[i];
                                    user.requestID = requestIDs[i];
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const RequestDetailPage(),
                                    ));
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text('Select',
                                        style: TextStyle(fontSize: 14)),
                                  ),
                                ),
                              ])
                            ],
                          ),
                      if(requests.isNotEmpty && requests[0] == 'No Requests')
                        const Text('No Active Requests', style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20,))
                    ],
                  ),
                )
              ),
            const SizedBox(height: 20),

            // The button in the middle that allows the student to submit a new request
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EquipmentPage(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor:
                    const Color(0xFF963e3e), // changes color of the text
                backgroundColor:
                    const Color(0xFFdedede), // changes the color of the button
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child:
                    Text('Submit New Request', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 20),

            // The bottom widget that allows the student to view what items they currently have checked out
            Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 20
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF963e3e),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: const Offset(3, 4),
                    ),
                  ],
                  border: Border.all(
                    width: 3,
                    color: const Color(0xFF500000),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          'Active Checkouts',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if(checkouts.isNotEmpty && checkouts[0] != 'No Checkout History')
                        for (int i = 0; i < checkouts.length; i++)
                          Table(
                            children: [
                              TableRow(children: <Widget>[
                                Text(checkouts[i], style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 20,)),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color(
                                        0xFFdedede), // changes color of the text
                                    backgroundColor: const Color(
                                        0xFF963e3e), // changes the color of the button
                                  ),
                                  /*style: ButtonStyle( 0xFFdedede
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ))),
                                      */
                                  onPressed: () {
                                    user.equipment = checkouts[i];
                                    user.checkoutID = historyIDs[i];
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const HistoryDetailPage(),
                                    ));
                                    },
                                  child: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text('Select',
                                        style: TextStyle(fontSize: 14)),
                                  ),
                                ),
                              ])
                            ],
                          ),
                      if(checkouts.isNotEmpty && checkouts[0] == 'No Checkout History')
                        const Text('No Active Checkouts', style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20,))
                    ],
                  ),
                )),
          ],
        ),
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
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[Text('Are you sure you want to log out?')],
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
  Navigator.of(context).pop();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}
