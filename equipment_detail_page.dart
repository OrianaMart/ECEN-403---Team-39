import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'Data.dart' as user;

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

  @override
  void initState() {
    super.initState();
    () async {
      equipmentDetails = await getEquipmentInfo(user.equipment);
      setState(() {});
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
                  Text('Equipment Name: ${user.equipment}'),
                  Text('Equipment Category: ${equipmentDetails[1]}'),
                  Text('Storage Location: ${equipmentDetails[2]}'),
                  Text('Amount Available: ${equipmentDetails[3]}'),
                  Text('Total Amount: ${equipmentDetails[4]}'),
                  if (equipmentDetails.length > 5)
                    const Text('Required Forms:'),

                  if (equipmentDetails.length > 5) Text(equipmentDetails[5]),

                  if (user.adminStatus == false) const StudentEquipmentDetails(),
                ])
            )
        )
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
            style: ElevatedButton.styleFrom(
              foregroundColor:
                  const Color(0xFFdedede), // changes color of the text
              backgroundColor:
                  const Color(0xFF963e3e), // changes the color of the button
            ),
            /*style: ButtonStyle( 0xFFdedede
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ))),
                                    */
            onPressed: () async {
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
                  invalidAmount = false;
                  invalidPermissions = false;
                });
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text('Generate Request', style: TextStyle(fontSize: 14)),
            ),
          ),
        ]),
      ]),
      const SizedBox(height: 16,),
      if(invalidPermissions)
        const Text('Invalid Permissions')
    ]);
  }
}
