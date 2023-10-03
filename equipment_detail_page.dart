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
                  'Equipment Details',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              //Displays information for the equipment
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Equipment Name: ",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.equipment,
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
                    "Equipment Category: ",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    equipmentDetails[1],
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
                    "Storage Location: ",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    equipmentDetails[2],
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
                    "Amount Available: ",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    equipmentDetails[3],
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
                    "Total Amount: ",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    equipmentDetails[4],
                    style: const TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ],
              ),

              //Displays the information for the equipment if forms are required
              if (equipmentDetails.length > 5)
                const Text(
                  'Required Forms: ',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              if (equipmentDetails.length > 5)
                Text(
                    equipmentDetails[5],
                    style: const TextStyle(
                      fontSize: 17.0,
                    )
                ),

              if (!user.adminStatus) const StudentEquipmentDetails(),
            ],
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
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF963e3e)), // changes color of text
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFdedede)), // changes color of button
              shape: MaterialStateProperty.all<
                  RoundedRectangleBorder>(
                RoundedRectangleBorder( // makes edges of button round instead of square
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ), // changes the color of the button
            ),

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
      const SizedBox(height: 16,),
      if(invalidPermissions)
        const Text('Invalid Permissions')
    ]);
  }
}
