import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'history_detail_page.dart';
import 'Data.dart' as user;

import 'internet_checker.dart';

class EditHistoryPage extends StatefulWidget {
  const EditHistoryPage({super.key});
  @override
  EditHistoryPageState createState() => EditHistoryPageState();
}

class EditHistoryPageState extends State<EditHistoryPage> {
  final TextEditingController amountOutField = TextEditingController();
  final TextEditingController adminOutField = TextEditingController();
  final TextEditingController timestampOutField = TextEditingController();

  final TextEditingController amountInField = TextEditingController();
  final TextEditingController adminInField = TextEditingController();
  final TextEditingController timestampInField = TextEditingController();

  //for drop down menus
  var admins = List<String>.filled(0, '', growable: true);

  //variables for error checking
  bool invalidTimeOut = false;
  bool invalidTimeIn = false;

  //variables for null checking
  bool invalidAmountOut = false;
  bool invalidAdminOut = false;
  bool invalidAmountIn = false;
  bool invalidAdminIn = false;

  String adminOut = '';
  String adminIn = '';

  var historyDetails = List<String>.filled(9, '', growable: true);

  @override
  void initState() {
    super.initState();
    //gets information
    () async {
      historyDetails = await getHistoryInfo(user.checkoutID);

      admins = await allAdminUsers();

      setState(() {
        historyDetails;

        admins;

        adminOut = historyDetails[4];
        amountOutField.text = historyDetails[3];
        timestampOutField.text = historyDetails[5];

        if (historyDetails.length > 6) {
          adminIn = historyDetails[7];
          amountInField.text = historyDetails[6];
          timestampInField.text = historyDetails[8];
        }
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> adminEntries =
        <DropdownMenuEntry<String>>[];

    if (admins.isNotEmpty && admins[0] == 'No Admin Users') {
      adminEntries.add(DropdownMenuEntry(value: '', label: admins[0]));
    } else {
      for (int i = 0; i < admins.length; i++) {
        adminEntries.add(DropdownMenuEntry(value: admins[i], label: admins[i]));
      }
    }

    // Creates the app bar at the top of the screen
    return Scaffold(
      appBar: AppBar(
        //creates top bar of the app
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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            //mainAxisAlignment:MainAxisAlignment.start,
            children: <Widget>[
              //Creates the text at the top of the equipment creation screen
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Edit Checkout History.',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Edit Checkout History Information:',
                  style: TextStyle(
                    fontSize: 17.0,
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

              TextFormField(
                controller: amountOutField,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount - Out',
                  errorText: invalidAmountOut ? 'Invalid Amount' : null,
                ),
              ),

              const SizedBox(height: 15),

              DropdownMenu<String>(
                controller: adminOutField,
                requestFocusOnTap: true,
                enableSearch: true,
                width: MediaQuery.of(context).size.width * .9,
                enableFilter: true,
                initialSelection: historyDetails[4],
                errorText: invalidAdminOut ? 'Invalid Admin': null,
                label: const Text('Admin - Checkout'),
                //makes the dropdown menu scrollable
                menuHeight: 300,
                //sets the entries to the dropdown menu
                dropdownMenuEntries: adminEntries,
                onSelected: (String? admin) {
                  if (admin != null) {
                    adminOut = admin;

                    setState(() {
                      adminOut;
                    });
                  }
                },
              ),

              TextFormField(
                controller: timestampOutField,
                decoration: InputDecoration(
                  labelText: 'Timestamp - Out',
                  errorText: invalidTimeOut ? 'Invalid Timestamp' : null,
                ),
              ),

              if (historyDetails.length > 6)
                TextFormField(
                  controller: amountInField,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount - Check-In',
                    errorText: invalidAmountIn ? 'Invalid Amount' : null,
                  ),
                ),

              if (historyDetails.length > 6) const SizedBox(height: 15),

              if (historyDetails.length > 6)
                DropdownMenu<String>(
                  controller: adminInField,
                  requestFocusOnTap: true,
                  enableSearch: true,
                  width: MediaQuery.of(context).size.width * .9,
                  enableFilter: true,
                  initialSelection: historyDetails[7],
                  errorText: invalidAdminIn ? 'Invalid Admin': null,
                  label: const Text('Admin - Check-In'),
                  //makes the dropdown menu scrollable
                  menuHeight: 300,
                  //sets the entries to the dropdown menu
                  dropdownMenuEntries: adminEntries,
                  onSelected: (String? admin) {
                    if (admin != null) {
                      adminIn = admin;

                      setState(() {
                        adminIn;
                      });
                    }
                  },
                ),

              if (historyDetails.length > 6)
                TextFormField(
                  controller: timestampInField,
                  decoration: InputDecoration(
                    labelText: 'Timestamp - In',
                    errorText:
                        invalidTimeIn ? 'Invalid Timestamp' : null,
                  ),
                ),

              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  //checks to see if the app is still connected to the internet
                  connectionCheck(context);

                  //check for invalid timestamps
                  List<String> timeParsed = timestampOutField.text.split('-');
                  int timeCode = 0;
                  int timeCode2 = 0;

                  if(timestampOutField.text != '') {
                    timeParsed.add(timeParsed[2].split(' ').last);
                    timeParsed[2] = timeParsed[2].split(' ').first;

                    if (timeParsed.length != 4 || timeParsed.contains('') ||
                        int.parse(timeParsed[0]) > DateTime.now().year || int.parse(timeParsed[0]) < 2023 ||
                        int.parse(timeParsed[1]) > 12 || int.parse(timeParsed[1]) < 1 ||
                        int.parse(timeParsed[2]) > 31 || int.parse(timeParsed[2]) < 1
                    ) {
                      invalidTimeOut = true;
                    } else {
                      invalidTimeOut = false;
                      if(int.parse(timeParsed[1]) < 10) {
                        timeParsed[1] = '0${timeParsed[1]}';
                      }
                      if(int.parse(timeParsed[2]) < 10) {
                        timeParsed[2] = '0${timeParsed[2]}';
                      }
                      timeCode = int.parse('${timeParsed[0]}${timeParsed[1]}${timeParsed[2]}');
                    }

                    if (!invalidTimeOut) {
                      timeParsed = timeParsed[3].split(':');
                      if (timeParsed.length != 3 || timeParsed.contains('') ||
                          int.parse(timeParsed[0]) > 23 || int.parse(timeParsed[0]) < 0 ||
                          int.parse(timeParsed[1]) > 59 || int.parse(timeParsed[1]) < 0 ||
                          int.parse(timeParsed[2]) > 59 || int.parse(timeParsed[2]) < 0
                      ) {
                        invalidTimeOut = true;
                      } else {
                        invalidTimeOut = false;
                        if(int.parse(timeParsed[0]) < 10) {
                          timeParsed[0] = '0${timeParsed[0]}';
                        }
                        if(int.parse(timeParsed[1]) < 10) {
                          timeParsed[1] = '0${timeParsed[1]}';
                        }
                        if(int.parse(timeParsed[2]) < 10) {
                          timeParsed[2] = '0${timeParsed[2]}';
                        }
                        timeCode = int.parse('${timeCode.toString()}${timeParsed[0]}${timeParsed[1]}${timeParsed[2]}');
                      }
                    }
                  } else {
                    invalidTimeOut = true;
                  }

                  if(historyDetails.length > 6) {
                    if (timestampInField.text != '') {
                      timeParsed = timestampInField.text.split('-');

                      timeParsed.add(timeParsed[2].split(' ').last);
                      timeParsed[2] = timeParsed[2].split(' ').first;

                      if (timeParsed.length != 4 || timeParsed.contains('') ||
                          int.parse(timeParsed[0]) > DateTime.now().year || int.parse(timeParsed[0]) < 2023 ||
                          int.parse(timeParsed[1]) > 12 || int.parse(timeParsed[1]) < 1 ||
                          int.parse(timeParsed[2]) > 31 || int.parse(timeParsed[2]) < 1
                      ) {
                        invalidTimeIn = true;
                      } else {
                        invalidTimeIn = false;
                        if(int.parse(timeParsed[1]) < 10) {
                          timeParsed[1] = '0${timeParsed[1]}';
                        }
                        if(int.parse(timeParsed[2]) < 10) {
                          timeParsed[2] = '0${timeParsed[2]}';
                        }
                        timeCode2 = int.parse('${timeParsed[0]}${timeParsed[1]}${timeParsed[2]}');
                      }

                      if (!invalidTimeIn) {
                        timeParsed = timeParsed[3].split(':');
                        if (timeParsed.length != 3 || timeParsed.contains('') ||
                            int.parse(timeParsed[0]) > 23 || int.parse(timeParsed[0]) < 0 ||
                            int.parse(timeParsed[1]) > 59 || int.parse(timeParsed[1]) < 0 ||
                            int.parse(timeParsed[2]) > 59 || int.parse(timeParsed[2]) < 0
                        ) {
                          invalidTimeIn = true;
                        } else {
                          invalidTimeIn = false;
                          if(int.parse(timeParsed[0]) < 10) {
                            timeParsed[0] = '0${timeParsed[0]}';
                          }
                          if(int.parse(timeParsed[1]) < 10) {
                            timeParsed[1] = '0${timeParsed[1]}';
                          }
                          if(int.parse(timeParsed[2]) < 10) {
                            timeParsed[2] = '0${timeParsed[2]}';
                          }
                          timeCode2 = int.parse('${timeCode2.toString()}${timeParsed[0]}${timeParsed[1]}${timeParsed[2]}');
                        }
                      }
                    } else {
                      invalidTimeIn = true;
                    }
                  }

                  if(timeCode2 != 0 && timeCode2 - timeCode <= 0){
                    invalidTimeIn = true;
                  }

                  if(adminOut == ''){
                    invalidAdminOut = true;
                  } else {
                    invalidAdminOut = false;
                  }

                  if(historyDetails.length > 6 && adminIn == ''){
                    invalidAdminIn = true;
                  } else {
                    invalidAdminIn = false;
                  }

                  if(amountOutField.text == ''){
                    invalidAmountOut = true;
                  } else {
                    invalidAmountOut = false;
                  }

                  if(historyDetails.length > 6 && amountInField.text == ''){
                    invalidAmountIn = true;
                  } else {
                    invalidAmountIn = false;
                  }

                  //if the timestamps are in the correct format and no values are null
                  if (!invalidTimeIn && !invalidTimeOut &&
                      !invalidAdminOut && !invalidAdminIn &&
                      !invalidAmountOut && !invalidAmountIn) {
                    if (historyDetails.length > 6) {
                      if (await editHistory(
                          user.checkoutID,
                          int.parse(amountOutField.text),
                          adminOut,
                          timestampOutField.text,
                          int.parse(amountInField.text),
                          adminIn,
                          timestampInField.text) ==
                          'Updated') {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoryDetailPage(),
                            ));
                        setState(() {
                          invalidAmountOut = false;
                          invalidAdminOut = false;
                          invalidTimeOut = false;
                          invalidAmountIn = false;
                          invalidAdminIn = false;
                          invalidTimeIn = false;
                        });
                      } else {
                        invalidAmountIn = true;
                        invalidAmountOut = true;
                      }
                    } else {
                      if (await editHistory(
                          user.checkoutID,
                          int.parse(amountOutField.text),
                          adminOut,
                          timestampOutField.text,
                          0, '', '') == 'Updated') {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoryDetailPage(),
                            ));
                        setState(() {
                          invalidAmountOut = false;
                          invalidAdminOut = false;
                          invalidTimeOut = false;
                          invalidAmountIn = false;
                          invalidAdminIn = false;
                          invalidTimeIn = false;
                        });
                      } else {
                        invalidAmountIn = true;
                        invalidAmountOut = true;
                      }
                    }
                  }

                  setState(() {
                    invalidTimeOut;
                    invalidTimeIn;
                    invalidAmountOut;
                    invalidAdminIn;
                    invalidAdminOut;
                    invalidAdminIn;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF963e3e),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
