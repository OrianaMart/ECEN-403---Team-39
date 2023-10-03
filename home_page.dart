import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'navigator_drawer.dart';
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
  //variables for storing and displaying the users name on the home page
  String firstName = '';
  String lastName = '';

  @override
  void initState() {
    super.initState();
    () async {
      //gets the users information and stores it to a temp variable
      var temp = await getUserInfo(user.username);

      //stores the users name for display later
      firstName = temp[2];
      lastName = temp[3];

      //sets the page state to have the users name populated correctly
      setState(() {
        firstName;
        lastName;
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

      //Navigation drawer code is called here
      drawer: const NavigatorDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // The top widget on the home page that shows requests the student currently has sent out

            //Displays the users name that was found earlier
            Text(
              '$firstName $lastName',
              style: const TextStyle(
                color: Color(0xFF000000),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            //if the user is a student, it displays the student home page column
            if (!user.adminStatus) const StudentHomePage(),

            //if the user is an admin it displays the admin home page column
            if(user.adminStatus) const AdminHomePage(),
          ],
        ),
      ),
    );
  }
}

//student home page column that displays information only for student accounts
class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);
  @override
  StudentHomePageState createState() {
    return StudentHomePageState();
  }
}

class StudentHomePageState extends State<StudentHomePage> {
  //variables to store all active requests and their unique IDs for display and selection
  var requests = List<String>.filled(0, '', growable: true);
  var requestIDs = List<String>.filled(0, '', growable: true);

  //variables to store all active checkouts and their unique IDs for display and selection
  var checkouts = List<String>.filled(0, '', growable: true);
  var historyIDs = List<String>.filled(0, '', growable: true);

  @override
  void initState() {
    super.initState();
    () async {
      //finds all requests for the student
      requestIDs = await findRequests(user.username);

      //checks if there are any requests
      if (requestIDs[0] == 'No Requests') {
        //if not, the requests will display that there are none
        requests.add(requestIDs[0]);
      } else {
        //if there are requests

        //iterated through all requests
        for (int i = 0; i < requestIDs.length; i++) {

          //save the requested equipments name
          var temp = await getRequestInfo(requestIDs[i]);
          requests.add(temp[2]);
        }
      }

      //gets all history unique IDs for a user
      historyIDs = await historyIDbyUser(user.username);

      //checks to see if the user has any history
      if (historyIDs[0] == 'No Checkout History') {
        //if not, history will display that there is none
        checkouts.add(historyIDs[0]);
      } else {
        //if there is history for the user

        //iterates through all histories
        for (int i = 0; i < historyIDs.length; i++) {

          //gets the history information
          var temp = await getHistoryInfo(historyIDs[i]);

          //checks to see if there has been any checkins under the checkout ID
          if (temp.length < 7) {
            //if no checkins, saves equipment name to list of actively checked out equipment
            checkouts.add(temp[2]);
          } else if (int.parse(temp[6]) < int.parse(temp[3])) {
            //if there are check ins but the amount checked in is less than the amount checked out it saves the equipment name
            checkouts.add(temp[2]);
          } else {
            //if the amount checked out is the amount checked in the history ID is removed from the list of IDs and the iterative variable is subtracted by 1
            historyIDs.removeAt(i);
            i--;
          }
        }
      }

      setState(() {
        //sets the state for the active requests
        requests;
        requestIDs;

        //sets the state for the active checkouts
        checkouts;
        historyIDs;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Display container for requests
        Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                  //checks to see if there are any requests and if the data has loaded
                  if (requests.isNotEmpty && requests[0] != 'No Requests')

                    //iterates through all requests making selectable buttons for each request
                    for (int i = 0; i < requests.length; i++)
                      Table(
                        children: [
                          TableRow(children: <Widget>[
                            Text(requests[i],
                                style: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 20,
                                )),
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

                                //sets the information to be displayed when the user reaches the request details
                                user.equipment = requests[i];
                                user.requestID = requestIDs[i];
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RequestDetailPage(),
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
                  //outputs that there are no requests if the data has loaded and the user has no associated requests
                  if (requests.isNotEmpty && requests[0] == 'No Requests')
                    const Text('No Active Requests',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 20,
                        )
                    )
                ],
              ),
            )),
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
            child: Text('Submit New Request', style: TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(height: 20),

        // The bottom widget that allows the student to view what items they currently have checked out
        Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                  //checks to see if the data has loaded and there is active checkouts for the user
                  if (checkouts.isNotEmpty &&
                      checkouts[0] != 'No Checkout History')

                    //iterates through each checkout making selectable buttons for each checkout entry
                    for (int i = 0; i < checkouts.length; i++)
                      Table(
                        children: [
                          TableRow(children: <Widget>[
                            Text(checkouts[i],
                                style: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 20,
                                )),
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

                                //sets the information to be displayed when the user reaches the history details
                                user.equipment = checkouts[i];
                                user.checkoutID = historyIDs[i];
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HistoryDetailPage(),
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
                  //outputs that there is no history if the data has loaded and the user has no associated history
                  if (checkouts.isNotEmpty &&
                      checkouts[0] == 'No Checkout History')
                    const Text('No Active Checkouts',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 20,
                        )
                    )
                ],
              ),
            )),
      ],
    );
  }
}

//student home page column that displays information only for student accounts
class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);
  @override
  AdminHomePageState createState() {
    return AdminHomePageState();
  }
}

class AdminHomePageState extends State<AdminHomePage> {
  //text controller for request search
  final TextEditingController requestField = TextEditingController();

  //text controllers for check-in search
  final TextEditingController equipmentField = TextEditingController();
  final TextEditingController uinField = TextEditingController();
  final TextEditingController amountField = TextEditingController();

  //variable to store information for request searching
  var requestUins = List<String>.filled(0, '', growable: true);

  //variable to store information for check-ins


  @override
  void initState() {
    super.initState();
    () async {
      //gets unique ID for all requests
      var allRequests = await allRequestIDs();



      setState(() {

      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Display container for requests
        Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
            child: const SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Requests',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                ],
              ),
            )
        ),

        const SizedBox(height: 20),

        Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
            child: const SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Check-In',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                ],
              ),
            )),
      ],
    );
  }
}