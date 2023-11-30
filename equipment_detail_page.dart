import 'equipment_page.dart';
import 'history_page.dart';
import 'new_equipment.dart';
import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'form_requirement_page.dart';
import 'Data.dart' as user;

import 'internet_checker.dart';

class EquipmentDetailPage extends StatefulWidget {
  const EquipmentDetailPage({Key? key}) : super(key: key);
  @override
  EquipmentDetailPageState createState() {
    return EquipmentDetailPageState();
  }
}

class EquipmentDetailPageState extends State<EquipmentDetailPage> {
  //variables to be filled by the equipment details
  var equipmentDetails = List<String>.filled(5, '', growable: true);

  bool forms = false;

  @override
  void initState() {
    super.initState();
    () async {
      equipmentDetails = await getEquipmentInfo(user.equipment);
      if (equipmentDetails.length > 5) {
        forms = true;
      }
      setState(() {
        equipmentDetails;
        forms;
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
                //checks to see if the app is still connected to the internet
                connectionCheck(context);

                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(child: Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Equipment Details',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //const SizedBox(height: 25),

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
                    'Equipment Name: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B8B8B),
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.equipment,
                    style: const TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 5),
              //Displays information for the equipment

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Equipment Category: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B8B8B),
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    equipmentDetails[1],
                    style: const TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 5),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Storage Location: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B8B8B),
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    equipmentDetails[2],
                    style: const TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 5),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Amount Available: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B8B8B),
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    equipmentDetails[3],
                    style: const TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 5),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Total Amount: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B8B8B),
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    equipmentDetails[4],
                    style: const TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 5),

              //Displays the information for the equipment if forms are required
              if (forms)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Required Forms: ',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B8B8B),
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      equipmentDetails[5],
                      style: const TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),

              if (forms)
                const SizedBox(height: 5),
              if (forms)
                const Divider(
                  color: Colors.grey,
                ),
              if (forms)
                const SizedBox(height: 5),

              if (!user.adminStatus) const StudentEquipmentDetails(),

              if (user.adminStatus) AdminEquipmentDetails(forms: forms),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class StudentEquipmentDetails extends StatefulWidget {
  const StudentEquipmentDetails({Key? key}) : super(key: key);
  @override
  StudentEquipmentDetailsState createState() {
    return StudentEquipmentDetailsState();
  }
}

class StudentEquipmentDetailsState extends State<StudentEquipmentDetails> {
  final amountField = TextEditingController();

  //variables for error checking
  bool invalidAmount = false;
  bool invalidPermissions = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 25),
      Table(children: [
        TableRow(children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: amountField,
            decoration: InputDecoration(
              labelText: 'Amount Requested',
              errorText: invalidAmount ? 'Invalid Amount' : null,
            ),
          ),
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
            onPressed: () async {
              //checks to see if the app is still connected to the internet
              connectionCheck(context);

              if (amountField.text.toString() != '') {
                switch (await generateNewRequest(user.username, user.equipment,
                    int.parse(amountField.text.toString()))) {
                  case 'Invalid Amount':
                    {
                      setState(() {
                        invalidAmount = true;
                        invalidPermissions = false;
                      });
                    }
                    break;

                  case 'Invalid Permissions':
                    {
                      setState(() {
                        invalidAmount = false;
                        invalidPermissions = true;
                      });
                    }
                    break;

                  case 'Generated':
                    {
                      setState(() {
                        invalidAmount = false;
                        invalidPermissions = false;
                      });
                      Navigator.pop(context);
                    }
                    break;
                }
              } else {
                setState(() {
                  amountField.text = '';
                  invalidAmount = true;
                  invalidPermissions = false;
                });
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Generate Request',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
      ]),
      const SizedBox(
        height: 16,
      ),
      if (invalidPermissions) const Text('Invalid Permissions')
    ]);
  }
}

class AdminEquipmentDetails extends StatelessWidget {
  const AdminEquipmentDetails({Key? key, required this.forms})
      : super(key: key);
  final bool forms;

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
          //checks to see if the app is still connected to the internet
          connectionCheck(context);

          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const NewEquipmentPage(),
          ));
        },
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Edit Equipment', style: TextStyle(fontSize: 15)),
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
          //checks to see if the app is still connected to the internet
          connectionCheck(context);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const AddFormRequirementPage(),
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Add Form Requirement', style: TextStyle(fontSize: 15)),
        ),
      ),
      const SizedBox(height: 5),
      if (forms)
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
            //checks to see if the app is still connected to the internet
            connectionCheck(context);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const RemoveFormRequirementPage(),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child:
                Text('Remove Form Requirement', style: TextStyle(fontSize: 15)),
          ),
        ),
      if (forms) const SizedBox(height: 5),
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
          //checks to see if the app is still connected to the internet
          connectionCheck(context);

          Navigator.of(context).pushReplacement(
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
          //checks to see if the app is still connected to the internet
          connectionCheck(context);

          _removalConfirmation(context);
        },
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Delete Equipment', style: TextStyle(fontSize: 15)),
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
        title: const Text('Delete Equipment'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Are you sure you want to permanently delete "${user.equipment}"')
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                //checks to see if the app is still connected to the internet
                connectionCheck(context);

                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text('Go Back')),
          TextButton(
              onPressed: () async {
                //checks to see if the app is still connected to the internet
                connectionCheck(context);

                if (user.equipment != '') {
                  if (await removeEquipment(user.equipment) == 'Removed') {
                    user.equipment = '';
                    user.checkoutID = '';
                    user.requestID = '';
                    user.mlCategory = null;
                    user.viewedUser = '';
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const EquipmentPage(),
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
