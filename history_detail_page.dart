import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'home_page.dart';
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
          title: Text(
            user.equipment,
            style: const TextStyle(
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
                  //Displays the information for the equipment
                  Text('Checkout History ID: ${user.checkoutID}'),
                  if (user.adminStatus) Text('Username: ${historyDetails[1]}'),
                  Text('Checked Out Equipment: ${historyDetails[2]}'),
                  Text('Amount Checked Out: ${historyDetails[3]}'),
                  Text('Admin Approved Checkout: ${historyDetails[4]}'),
                  Text('Checkout Timestamp: ${historyDetails[5]}'),

                  if (historyDetails.length > 6)
                    Text('Amount Checked In: ${historyDetails[6]}'),
                  if (historyDetails.length > 6)
                    Text('Admin Approved Check-in: ${historyDetails[7]}'),
                  if (historyDetails.length > 6)
                    Text('Check-in Timestamp: ${historyDetails[8]}'),

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
      TextFormField(
        controller: uinField,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: 'UIN',
            helperText: 'Verify Students UIN for Verification',
            errorText: invalidUin ? 'Incorrect UIN' : null),
      ),
      TextFormField(
        controller: amountField,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: 'Check-In Amount',
            errorText: invalidAmount ? 'Invalid Check-In Amount' : null),
      ),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor:
                const Color(0xFFdedede), // changes color of the text
            backgroundColor:
                const Color(0xFF963e3e), // changes the color of the button
          ),
          onPressed: () async {
            if (amountField.text.toString() != '') {
              if (int.parse(amountField.text.toString()) < 1 ||
                  int.parse(amountField.text.toString()) > widget.amountAllowed) {
                setState(() {
                  invalidAmount = true;
                  invalidUin = false;
                });
              } else {
                if (uinField.text.toString() != '') {
                  switch (await verifyCheckIn(
                      user.checkoutID,
                      int.parse(uinField.text.toString()),
                      int.parse(amountField.text.toString()),
                      user.username)) {
                    case 'Invalid Amount':
                      {
                        invalidAmount = true;
                        invalidUin = false;
                      }
                      break;

                    case 'Invalid UIN':
                      {
                        invalidAmount = false;
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
                  setState(() {
                    invalidUin;
                    invalidAmount;
                  });
                }
              }
            }
          },
          child: const Text('Verify Check-In')),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor:
                const Color(0xFFdedede), // changes color of the text
            backgroundColor:
                const Color(0xFF963e3e), // changes the color of the button
          ),
          onPressed: () async {},
          child: const Text('Edit Checkout History')),
    ]);
  }
}
