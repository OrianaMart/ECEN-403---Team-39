import 'history_page.dart';
import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'home_page.dart';
import 'edit_history.dart';
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

  int amount = 0;

  @override
  void initState() {
    super.initState();
    () async {
      historyDetails = await getHistoryInfo(user.checkoutID);
      if (historyDetails.length > 6) {
        amount = int.parse(historyDetails[3]) - int.parse(historyDetails[6]);
      } else {
        amount = int.parse(historyDetails[3]);
      }
      setState(() {
        historyDetails;
        amount;
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
                child: Column(children: [
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

                  if (user.adminStatus)
                    Row(
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
                  if (historyDetails.length > 6)
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

                  if (historyDetails.length > 6)
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

                  if (historyDetails.length > 6)
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

                  if (user.adminStatus)
                    AdminHistoryDetails(amountAllowed: amount),
                ]))));
  }
}

class AdminHistoryDetails extends StatefulWidget {
  const AdminHistoryDetails({Key? key, required this.amountAllowed})
      : super(key: key);
  final int amountAllowed;
  @override
  AdminHistoryDetailsState createState() {
    return AdminHistoryDetailsState();
  }
}

class AdminHistoryDetailsState extends State<AdminHistoryDetails> {
  final uinField = TextEditingController();
  final amountField = TextEditingController();

  bool invalidUin = false;
  bool invalidAmount = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (widget.amountAllowed > 0)
        TextFormField(
          controller: uinField,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: 'UIN',
              helperText: 'Verify Students UIN for Verification',
              errorText: invalidUin ? 'Incorrect UIN' : null),
        ),
      if (widget.amountAllowed > 0)
        TextFormField(
          controller: amountField,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: 'Check-In Amount',
              errorText: invalidAmount ? 'Invalid Check-In Amount' : null),
        ),
      if (widget.amountAllowed > 0)
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor:
                  const Color(0xFFdedede), // changes color of the text
              backgroundColor:
                  const Color(0xFF963e3e), // changes the color of the button
            ),
            onPressed: () async {
              invalidAmount = false;
              invalidUin = false;

              if (amountField.text.toString() != '') {
                if (int.parse(amountField.text.toString()) < 1 ||
                    int.parse(amountField.text.toString()) >
                        widget.amountAllowed) {
                  invalidAmount = true;
                }
              } else {
                invalidAmount = true;
              }

              if (uinField.text.toString() == '') {
                invalidUin = true;
              }

              if (!invalidAmount && !invalidUin) {
                switch (await verifyCheckIn(
                    user.checkoutID,
                    int.parse(uinField.text.toString()),
                    int.parse(amountField.text.toString()),
                    user.username)) {
                  case 'Invalid Amount':
                    {
                      invalidAmount = true;
                    }
                    break;

                  case 'Invalid UIN':
                    {
                      invalidUin = true;
                    }
                    break;

                  case 'Checked In':
                    {
                      setState(() {
                        invalidAmount = false;
                        invalidUin = false;
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    }
                    break;
                }
              }

              setState(() {
                invalidAmount;
                invalidUin;
              });
            },
            child: const Text('Verify Check-In')),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor:
                const Color(0xFFdedede), // changes color of the text
            backgroundColor:
                const Color(0xFF963e3e), // changes the color of the button
          ),
          onPressed: () async {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditHistoryPage()));
          },
          child: const Text('Edit Checkout History')),
      if (widget.amountAllowed == 0)
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor:
                  const Color(0xFFdedede), // changes color of the text
              backgroundColor:
                  const Color(0xFF963e3e), // changes the color of the button
            ),
            onPressed: () async {
              _removalConfirmation(context);
            },
            child: const Text('Delete Checkout History')),
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
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Are you sure you want to permanently delete this history entry?')
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
                if (user.checkoutID != '') {
                  if (await removeHistory(user.checkoutID) == 'Removed') {
                    user.equipment = '';
                    user.checkoutID = '';
                    user.requestID = '';
                    user.mlCategory = null;
                    user.viewedUser = '';
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
