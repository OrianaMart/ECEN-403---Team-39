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
      Text(user.adminStatus.toString())
    ]);
  }
}