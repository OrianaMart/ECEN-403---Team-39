import 'package:database_demo_app/history_page.dart';
import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'Data.dart' as user;

class HistoryDetailPage extends StatefulWidget {
  const HistoryDetailPage({Key? key}) : super(key: key);
  @override
  HistoryDetailPageState createState() {
    return HistoryDetailPageState();
  }
}

class HistoryDetailPageState extends State<HistoryDetailPage> {
  //variables to be filled by the equipment details
  var historyDetails = List<String>.filled(9, '', growable: true);

  @override
  void initState() {
    super.initState();
    () async {
      historyDetails = await getHistoryInfo(user.checkoutID);
      setState(() {});
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
          backgroundColor: const Color(0xFF500000),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        body: Center(
            child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Checkout Details',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Checkout History ID: ",
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.checkoutID,
                            style: const TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ],
                      ),

                      if(user.adminStatus) Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Username: ",
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            historyDetails[1],
                            style: const TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Checked Out Equipment: ",
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            historyDetails[2],
                            style: const TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Amount Checked Out: ",
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            historyDetails[3],
                            style: const TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Admin Approved Checkout: ",
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            historyDetails[4],
                            style: const TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Checkout Timestamp: ",
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            historyDetails[5],
                            style: const TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ],
                      ),

                  //Displays the information for the equipment
                  if(historyDetails.length > 6)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Amount Checked In: ",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          historyDetails[6],
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),

                  if(historyDetails.length > 6)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Admin Approved Check-In: ",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          historyDetails[7],
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),

                  if(historyDetails.length > 6)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Check-in Timestamp: ",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          historyDetails[8],
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),

                  if(user.adminStatus)
                    const AdminHistoryDetails(),

                ]))));
  }
}

class AdminHistoryDetails extends StatefulWidget {
  const AdminHistoryDetails({Key? key}) : super(key: key);
  @override
  AdminHistoryDetailsState createState() {
    return AdminHistoryDetailsState();
  }
}
class AdminHistoryDetailsState extends State<AdminHistoryDetails> {

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
          child: Text('Delete History Entry', style: TextStyle(fontSize: 15)),
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
        title: const Text('Delete History'),
        content:  const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[Text('Are you sure you want to permanently delete this history entry?')],
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
                if(user.checkoutID != '') {
                  if (await removeHistory(user.checkoutID) == 'Removed') {
                    user.equipment = '';
                    user.checkoutID = '';
                    user.requestID = '';
                    user.username = '';
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HistoryPage(),
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