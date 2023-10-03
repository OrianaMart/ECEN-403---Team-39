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
                  if(user.adminStatus) Text('Username: ${historyDetails[1]}'),
                  Text('Checked Out Equipment: ${historyDetails[2]}'),
                  Text('Amount Checked Out: ${historyDetails[3]}'),
                  Text('Admin Approved Checkout: ${historyDetails[4]}'),
                  Text('Checkout Timestamp: ${historyDetails[5]}'),

                  if(historyDetails.length > 6)
                    Text('Amount Checked In: ${historyDetails[6]}'),
                  if(historyDetails.length > 6)
                    Text('Admin Approved Check-in: ${historyDetails[7]}'),
                  if(historyDetails.length > 6)
                    Text('Check-in Timestamp: ${historyDetails[8]}'),

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
      Text(user.adminStatus.toString())
    ]);
  }
}