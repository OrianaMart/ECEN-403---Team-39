import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'home_page.dart';
import 'Data.dart' as user;

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
                  Text('Request ID: ${user.requestID}'),
                  if (user.adminStatus) Text('Username: ${requestDetails[1]}'),
                  Text('Requested Equipment: ${requestDetails[2]}'),
                  Text('Requested Amount: ${requestDetails[3]}'),
                  Text('Request Timestamp: ${requestDetails[4]}'),

                  if (!user.adminStatus) const StudentRequestDetails(),
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
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));;
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
