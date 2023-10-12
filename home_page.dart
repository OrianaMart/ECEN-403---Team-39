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

      resizeToAvoidBottomInset: false,
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
            if (user.adminStatus) const AdminHomePage(),
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

      //checks to see if there are checkouts but they are all fully checked in
      if (historyIDs.isEmpty) {
        historyIDs.add('No Checkout History');
        checkouts.add(historyIDs[0]);
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
                        ))
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
                        ))
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
  final TextEditingController historyField = TextEditingController();

  //variable to store information for request searching
  var requestUins = List<String>.filled(0, '', growable: true);
  var requestedEquipment = List<String>.filled(0, '', growable: true);
  var requestIDs = List<String>.filled(0, '', growable: true);
  String? currentRequestUin = '';

  //variable to store information for check-ins
  var historyUins = List<String>.filled(0, '', growable: true);
  var historyEquipment = List<String>.filled(0, '', growable: true);
  var historyIDs = List<String>.filled(0, '', growable: true);
  String? currentHistoryUin = '';

  @override
  void initState() {
    super.initState();
    () async {
      //gets unique ID for all requests
      var allRequests = await allRequestIDs();

      //creates empty variable for logic inside for loop
      var usernames = List<String>.filled(0, '', growable: true);

      //checks to see if there are any requests
      if (allRequests[0] != 'No Requests') {
        //iterates through all request IDs
        for (int i = 0; i < allRequests.length; i++) {
          //checks request info to get username
          var temp = await getRequestInfo(allRequests[i]);

          //checks to see if that user has already been saved to requestUins
          if (!usernames.contains(temp[1])) {
            //if it hasn't been saved yet, it gets saved
            usernames.add(temp[1]);

            //gets the users info
            var temp2 = await getUserInfo(usernames.last);

            //adds the users uin to the list of uins with active requests
            requestUins.add(temp2[1]);
          }
        }
      }

      //checks to see if any requests are active
      if (requestUins.isEmpty) {
        //fills that there are no active requests
        requestUins.add('No Active Requests');
      }

      //~~~~~~~~~~~~~Checkout loading

      //gets all unique IDs for history entries
      var allHistory = await allHistoryIDs();

      //empties usernames for reuse
      usernames = [];

      //checks to see if there is any history
      if (allHistory[0] != 'No Checkout History') {
        //iterates through all history IDs
        for (int i = 0; i < allHistory.length; i++) {
          //creates a temp to hold the history info
          var temp = await getHistoryInfo(allHistory[i]);

          //checks to see if the checkout has not been fully checked in
          if (temp.length < 7 || int.parse(temp[3]) - int.parse(temp[6]) > 0) {
            //checks to see if that user has already been saved for history uins
            if (!usernames.contains(temp[1])) {
              //if it hasn't been saved yet, it gets saved
              usernames.add(temp[1]);
            }
          } else {
            allHistory.removeAt(i);
            i--;
          }
          temp = [];
        }
        for (int i = 0; i < usernames.length; i++) {
          //gets the users info
          var temp = await getUserInfo(usernames[i]);

          //adds the users uin to the list of uins with active checkouts
          historyUins.add(temp[1]);
        }
      }
      //checks if there is any active checkout history
      if (historyUins.isEmpty) {
        historyUins.add('No Active Checkouts');
      }

      setState(() {
        //sets the request uins
        requestUins;

        //sets the history search info
        historyUins;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> requestUinEntries =
        <DropdownMenuEntry<String>>[];
    final List<DropdownMenuEntry<String>> historyUinEntries =
        <DropdownMenuEntry<String>>[];

    if (requestUins.isNotEmpty && requestUins[0] == 'No Active Requests') {
      requestUinEntries
          .add(DropdownMenuEntry(value: '0', label: requestUins[0]));
    } else {
      for (int i = 0; i < requestUins.length; i++) {
        requestUinEntries.add(
            DropdownMenuEntry(value: requestUins[i], label: requestUins[i]));
      }
    }

    if (historyUins.isNotEmpty && historyUins[0] == 'No Active Checkouts') {
      historyUinEntries
          .add(DropdownMenuEntry(value: '0', label: historyUins[0]));
    } else {
      for (int i = 0; i < historyUins.length; i++) {
        historyUinEntries.add(
            DropdownMenuEntry(value: historyUins[i], label: historyUins[i]));
      }
    }

    return Column(
      children: [
        //Display container for requests
        Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .45),
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
                  DropdownMenu<String>(
                    controller: requestField,
                    requestFocusOnTap: true,
                    enableSearch: true,
                    width: MediaQuery.of(context).size.width * .8,
                    enableFilter: true,
                    label: const Text(
                      'UIN',
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                    hintText: currentRequestUin,
                    textStyle: const TextStyle(color: Color(0xFFFFFFFF)),
                    inputDecorationTheme: const InputDecorationTheme(
                      hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
                      prefixStyle: TextStyle(color: Color(0xFFFFFFFF)),
                      filled: true,
                      fillColor: Color(0xFF9F5555),
                      suffixIconColor: Color(0xFFFFFFFF),
                      //Prevents the hint text from going away
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                    ),
                    //makes the dropdown menu scrollable
                    menuHeight: 300,
                    //sets the entries to the dropdown menu
                    dropdownMenuEntries: requestUinEntries,
                    onSelected: (String? selectedUin) async {
                      //checks to see if there is a valid uin selected that hasn't already been selected
                      if (selectedUin != null &&
                          selectedUin != currentRequestUin) {
                        //uin is good and wasn't already selected

                        //sets current request uin to the selected uin
                        currentRequestUin = selectedUin;

                        //gets the selected uins username
                        var username = await userByUIN(int.parse(selectedUin));

                        //checks that the uin is valid
                        if (username[0] != 'I') {
                          //sets the request IDs to those valid for the selected user account
                          requestIDs = await findRequests(username);

                          //empties the requested equipment variable to be refilled
                          requestedEquipment = [];

                          //iterates through request IDs
                          for (int i = 0; i < requestIDs.length; i++) {
                            //temp variable gets the request information
                            var temp = await getRequestInfo(requestIDs[i]);

                            //fills requested equipment list for displaying equipment names
                            requestedEquipment.add(temp[2]);
                          }
                        } else {
                          //resets the displayed requests
                          requestIDs = [];
                          requestedEquipment = [];
                          currentRequestUin = null;
                        }
                      } else {
                        //The selected uin is invalid or is being selected again (deselection)

                        //resets the displayed requests
                        requestIDs = [];
                        requestedEquipment = [];
                        currentRequestUin = null;
                      }

                      //sets the state to save all the logic that has gone down yo
                      setState(() {
                        requestIDs;
                        requestedEquipment;
                        requestField.text = '';
                        currentRequestUin;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  for (int i = 0; i < requestedEquipment.length; i++)
                    Table(children: [
                      TableRow(children: <Widget>[
                        Text(
                          requestedEquipment[i],
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFFFFFFFF)),
                        ),
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
                            user.equipment = requestedEquipment[i];
                            user.requestID = requestIDs[i];
                            user.checkoutID = '';
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RequestDetailPage(),
                                ));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child:
                                Text('Select', style: TextStyle(fontSize: 14)),
                          ),
                        ),
                      ])
                    ]),
                ],
              ),
            )),

        const SizedBox(height: 20),

        Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .45),
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
                      'Check-In',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownMenu<String>(
                    controller: historyField,
                    requestFocusOnTap: true,
                    enableSearch: true,
                    width: MediaQuery.of(context).size.width * .8,
                    enableFilter: true,
                    label: const Text(
                      'UIN',
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                    hintText: currentHistoryUin,
                    textStyle: const TextStyle(color: Color(0xFFFFFFFF)),
                    inputDecorationTheme: const InputDecorationTheme(
                      hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
                      prefixStyle: TextStyle(color: Color(0xFFFFFFFF)),
                      filled: true,
                      fillColor: Color(0xFF9F5555),
                      suffixIconColor: Color(0xFFFFFFFF),
                      //Prevents the hint text from going away
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                    ),
                    //makes the dropdown menu scrollable
                    menuHeight: 300,
                    //sets the entries to the dropdown menu
                    dropdownMenuEntries: historyUinEntries,
                    onSelected: (String? selectedUin) async {
                      //checks to see if there is a valid uin selected that hasn't already been selected
                      if (selectedUin != null &&
                          selectedUin != currentHistoryUin) {
                        //uin is good and wasn't already selected

                        //sets current history uin to the selected uin
                        currentHistoryUin = selectedUin;

                        //gets the selected uins username
                        var username = await userByUIN(int.parse(selectedUin));

                        //checks that there is a valid uin
                        if (username[0] != 'I') {
                          //sets the history IDs to those valid for the selected user account
                          historyIDs = await historyIDbyUser(username);

                          //iterates through history IDs for user
                          for (int i = 0; i < historyIDs.length; i++) {
                            //temp variable gets the history information
                            var temp = await getHistoryInfo(historyIDs[i]);

                            if (temp.length < 7 ||
                                int.parse(temp[3]) - int.parse(temp[6]) > 0) {
                              //fills requested equipment list for displaying equipment names
                              historyEquipment.add(temp[2]);
                            } else {
                              historyIDs.removeAt(i);
                              i--;
                            }
                            temp = [];
                          }
                        } else {
                          //resets the displayed requests
                          historyIDs = [];
                          historyEquipment = [];
                          currentHistoryUin = null;
                        }
                      } else {
                        //The selected uin is invalid or is being selected again (deselection)

                        //resets the displayed requests
                        historyIDs = [];
                        historyEquipment = [];
                        currentHistoryUin = null;
                      }

                      //sets the state to save all the logic that has gone down yo
                      setState(() {
                        historyIDs;
                        historyEquipment;
                        historyField.text = '';
                        currentHistoryUin;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  for (int i = 0; i < historyEquipment.length; i++)
                    Table(children: [
                      TableRow(children: <Widget>[
                        Text(
                          historyEquipment[i],
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFFFFFFFF)),
                        ),
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
                            user.requestID = '';
                            user.equipment = historyEquipment[i];
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
                            child:
                                Text('Select', style: TextStyle(fontSize: 14)),
                          ),
                        ),
                      ])
                    ]),
                ],
              ),
            )),
      ],
    );
  }
}
