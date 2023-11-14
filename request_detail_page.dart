import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'home_page.dart';
import 'Data.dart' as user;

import 'internet_checker.dart';

class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({Key? key}) : super(key: key);
  @override
  RequestDetailPageState createState() {
    return RequestDetailPageState();
  }
}

class RequestDetailPageState extends State<RequestDetailPage> {
  //variables to be filled by the equipment details
  var requestDetails = List<String>.filled(5, '', growable: true);

  @override
  void initState() {
    super.initState();
    () async {
      requestDetails = await getRequestInfo(user.requestID);
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Request Details',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  //Displays the information for the equipment
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Request ID: ",
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.requestID,
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
                          requestDetails[1],
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
                        "Requested Equipment: ",
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        requestDetails[2],
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
                        "Requested Amount: ",
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        requestDetails[3],
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
                        "Request Timestamp: ",
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        requestDetails[4],
                        style: const TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  if (!user.adminStatus) const StudentRequestDetails(),

                  if (user.adminStatus) const AdminRequestDetails(),
                ]))));
  }
}

class StudentRequestDetails extends StatefulWidget {
  const StudentRequestDetails({Key? key}) : super(key: key);
  @override
  StudentRequestDetailsState createState() {
    return StudentRequestDetailsState();
  }
}

class StudentRequestDetailsState extends State<StudentRequestDetails> {
  //variables for error checking
  bool invalidRequest = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
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
            //checks to see if the app is still connected to the internet
            connectionCheck(context);

            switch (await denyRequest(user.requestID)) {
              case 'Invalid Request':
                {
                  setState(() {
                    invalidRequest = true;
                  });
                }
                break;

              case 'Denied':
                {
                  setState(() {
                    invalidRequest = false;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
                }
                break;
            }
          },
          child: const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text('Cancel Request', style: TextStyle(fontSize: 14)),
          ),
        ),
      ),
      const SizedBox(
        height: 16,
      ),
      if (invalidRequest) const Text('Invalid Request')
    ]);
  }
}

class AdminRequestDetails extends StatefulWidget {
  const AdminRequestDetails({Key? key}) : super(key: key);
  @override
  AdminRequestDetailsState createState(){
    return AdminRequestDetailsState();
  }
}

class AdminRequestDetailsState extends State<AdminRequestDetails>{
  final uinField = TextEditingController();

  bool invalidUin = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(controller: uinField,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'UIN',
              helperText: 'Verify Students UIN for Approval',
              errorText: invalidUin ? 'Incorrect UIN': null),
        ),

        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor:
              const Color(0xFFdedede), // changes color of the text
              backgroundColor: const Color(
                  0xFF963e3e), // changes the color of the button
            ),
            onPressed: () async {
              //checks to see if the app is still connected to the internet
              connectionCheck(context);

              if(uinField.text.toString() != '') {
                if (await approveRequest(
                    user.requestID, int.parse(uinField.text.toString()),
                    user.username) == 'Approved') {
                  setState(() {
                    invalidUin = false;
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                } else {
                  setState(() {
                    invalidUin = true;
                  });
                }
              }
            },
            child: const Text('Approve Request')),

        ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor:
              const Color(0xFFdedede), // changes color of the text
              backgroundColor: const Color(
                  0xFF963e3e), // changes the color of the button
            ),
            onPressed: () async {
              //checks to see if the app is still connected to the internet
              connectionCheck(context);

              if (await denyRequest(user.requestID) == 'Denied') {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePage()));
              }
            },
            child: const Text('Deny Request')),
      ],
    );
  }
}