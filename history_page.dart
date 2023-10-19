import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'navigator_drawer.dart';
import 'history_detail_page.dart';
import 'users_page.dart';
import 'Data.dart' as user;

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);
  @override
  HistoryPageState createState() {
    return HistoryPageState();
  }
}

class HistoryPageState extends State<HistoryPage> {
  final TextEditingController equipmentField = TextEditingController();
  final TextEditingController uinField = TextEditingController();

  var allCheckouts = List<List<String>>.filled(0, [], growable: true);
  var equipment = List<String>.filled(0, '', growable: true);
  var uins = List<String>.filled(0, '', growable: true);
  var usernames = List<String>.filled(0, '', growable: true);

  var equipmentCheckouts = List<String>.filled(0, '', growable: true);
  var uinCheckouts = List<String>.filled(0, '', growable: true);

  var results = List<List<String>>.filled(3, [], growable: true);

  String? currentEquipment;
  String? currentUin;

  @override
  void initState() {
    super.initState();

    () async {
      List<String> tempNames = [];
      List<String> tempEquipment = [];
      allCheckouts.add(await allHistoryIDs());
      for (int i = 0; i < allCheckouts[0].length; i++) {
        var temp = await getHistoryInfo(allCheckouts[0][i]);
        tempNames.add(temp[1]);
        if (!usernames.contains(temp[1])) {
          usernames.add(temp[1]);
        }
        if (!equipment.contains(temp[2])) {
          equipment.add(temp[2]);
        }
        tempEquipment.add(temp[2]);
      }
      allCheckouts.add(tempNames);
      allCheckouts.add(tempEquipment);

      results = [];
      results.add(allCheckouts[0]);
      results.add(allCheckouts[1]);
      results.add(allCheckouts[2]);

      for (int i = 0; i < usernames.length; i++) {
        var temp = await getUserInfo(usernames[i]);
        uins.add(temp[1]);
      }

      if (user.equipment != '') {
        currentEquipment = user.equipment;
        results = [];
        List<String> tempIDs = [];
        List<String> tempNames = [];
        List<String> tempEquipment = [];

        for (int i = 0; i < allCheckouts[0].length; i++) {
          if (allCheckouts[2][i] == currentEquipment) {
            tempIDs.add(allCheckouts[0][i]);
            tempNames.add(allCheckouts[1][i]);
            tempEquipment.add(allCheckouts[2][i]);
          }
        }
        results.add(tempIDs);
        results.add(tempNames);
        results.add(tempEquipment);
      }

      if (user.viewedUser != '') {
        var temp = await getUserInfo(user.viewedUser);
        currentUin = temp[1];

        results = [];
        List<String> tempIDs = [];
        List<String> tempNames = [];
        List<String> tempEquipment = [];

        for (int i = 0; i < allCheckouts[0].length; i++) {
          if (allCheckouts[1][i] == user.viewedUser) {
            tempIDs.add(allCheckouts[0][i]);
            tempNames.add(allCheckouts[1][i]);
            tempEquipment.add(allCheckouts[2][i]);
          }
        }
        results.add(tempIDs);
        results.add(tempNames);
        results.add(tempEquipment);
      }

      setState(() {
        equipment;
        currentEquipment;

        uins;
        currentUin;

        allCheckouts;

        results;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> equipmentEntries =
        <DropdownMenuEntry<String>>[];
    final List<DropdownMenuEntry<String>> uinEntries =
        <DropdownMenuEntry<String>>[];

    for (int i = 0; i < equipment.length; i++) {
      equipmentEntries
          .add(DropdownMenuEntry(value: equipment[i], label: equipment[i]));
    }

    for (int i = 0; i < uins.length; i++) {
      uinEntries.add(DropdownMenuEntry(value: uins[i], label: uins[i]));
    }

    return Scaffold(
        // Creates smart inventory app bar at top
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
              if (user.viewedUser == '' && user.equipment == '') {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UsersPage(),
                        ));
                  },
                );
              }
            },
          ),
        ),

        // Adds Navigation drawer to the Equipment page
        drawer: const NavigatorDrawer(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                //Header for page
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Checkout History Search',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 7),

                //Sub Header for page
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Search for checkout history',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                //Dropdown menu for selecting the equipment to search by
                DropdownMenu<String>(
                    controller: equipmentField,
                    initialSelection: user.equipment,
                    enabled: user.equipment == '',
                    requestFocusOnTap: true,
                    enableSearch: true,
                    width: MediaQuery.of(context).size.width * .9,
                    label: const Text('Equipment'),
                    hintText: currentEquipment,
                    //Prevents the hint text from going away
                    inputDecorationTheme: const InputDecorationTheme(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder()),
                    //makes the dropdown menu scrollable
                    menuHeight: 300,
                    //sets the entries to the dropdown menu
                    dropdownMenuEntries: equipmentEntries,
                    enableFilter: true,
                    onSelected: (String? selectedEquipment) async {
                      if (selectedEquipment != null &&
                          selectedEquipment != currentEquipment) {
                        currentEquipment = selectedEquipment;

                        results = [];
                        List<String> tempIDs = [];
                        List<String> tempNames = [];
                        List<String> tempEquipment = [];

                        if (currentUin == '' || currentUin == null) {
                          for (int i = 0; i < allCheckouts[0].length; i++) {
                            if (allCheckouts[2][i] == currentEquipment) {
                              tempIDs.add(allCheckouts[0][i]);
                              tempNames.add(allCheckouts[1][i]);
                              tempEquipment.add(allCheckouts[2][i]);
                            }
                          }
                        } else {
                          var name = await userByUIN(int.parse(currentUin!));

                          for (int i = 0; i < allCheckouts[0].length; i++) {
                            if (allCheckouts[2][i] == currentEquipment &&
                                allCheckouts[1][i] == name) {
                              tempIDs.add(allCheckouts[0][i]);
                              tempNames.add(allCheckouts[1][i]);
                              tempEquipment.add(allCheckouts[2][i]);
                            }
                          }
                        }

                        results.add(tempIDs);
                        results.add(tempNames);
                        results.add(tempEquipment);
                      } else {
                        results = [];
                        if (currentUin == '' || currentUin == null) {
                          results.add(allCheckouts[0]);
                          results.add(allCheckouts[1]);
                          results.add(allCheckouts[2]);
                        } else {
                          List<String> tempIDs = [];
                          List<String> tempNames = [];
                          List<String> tempEquipment = [];

                          var name = await userByUIN(int.parse(currentUin!));

                          for (int i = 0; i < allCheckouts[0].length; i++) {
                            if (allCheckouts[1][i] == name) {
                              tempIDs.add(allCheckouts[0][i]);
                              tempNames.add(allCheckouts[1][i]);
                              tempEquipment.add(allCheckouts[2][i]);
                            }
                          }
                          results.add(tempIDs);
                          results.add(tempNames);
                          results.add(tempEquipment);
                        }
                        currentEquipment = '';
                      }

                      setState(() {
                        equipmentField.text = '';
                        currentEquipment;
                        results;
                      });
                    }),

                const SizedBox(height: 15),
                DropdownMenu<String>(
                  controller: uinField,
                  initialSelection: user.viewedUser,
                  enabled: user.viewedUser == '',
                  requestFocusOnTap: true,
                  enableSearch: true,
                  width: MediaQuery.of(context).size.width * .9,
                  label: const Text('UIN'),
                  enableFilter: true,
                  hintText: currentUin,
                  //Prevents the hint text from going away
                  inputDecorationTheme: const InputDecorationTheme(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder()),
                  //makes the dropdown menu scrollable
                  menuHeight: 300,
                  //sets the entries to the dropdown menu
                  dropdownMenuEntries: uinEntries,
                  onSelected: (String? selectedUin) async {
                    if (selectedUin != null && selectedUin != currentUin) {
                      currentUin = selectedUin;

                      results = [];
                      List<String> tempIDs = [];
                      List<String> tempNames = [];
                      List<String> tempEquipment = [];

                      var name = await userByUIN(int.parse(currentUin!));
                      if (currentEquipment == '' || currentEquipment == null) {
                        for (int i = 0; i < allCheckouts[0].length; i++) {
                          if (allCheckouts[1][i] == name) {
                            tempIDs.add(allCheckouts[0][i]);
                            tempNames.add(allCheckouts[1][i]);
                            tempEquipment.add(allCheckouts[2][i]);
                          }
                        }
                      } else {
                        var name = await userByUIN(int.parse(currentUin!));

                        for (int i = 0; i < allCheckouts[0].length; i++) {
                          if (allCheckouts[2][i] == currentEquipment &&
                              allCheckouts[1][i] == name) {
                            tempIDs.add(allCheckouts[0][i]);
                            tempNames.add(allCheckouts[1][i]);
                            tempEquipment.add(allCheckouts[2][i]);
                          }
                        }
                      }
                      results.add(tempIDs);
                      results.add(tempNames);
                      results.add(tempEquipment);
                    } else {
                      results = [];
                      if (currentEquipment == '' || currentEquipment == null) {
                        results.add(allCheckouts[0]);
                        results.add(allCheckouts[1]);
                        results.add(allCheckouts[2]);
                      } else {
                        List<String> tempIDs = [];
                        List<String> tempNames = [];
                        List<String> tempEquipment = [];

                        for (int i = 0; i < allCheckouts[0].length; i++) {
                          if (allCheckouts[2][i] == currentEquipment) {
                            tempIDs.add(allCheckouts[0][i]);
                            tempNames.add(allCheckouts[1][i]);
                            tempEquipment.add(allCheckouts[2][i]);
                          }
                        }
                        results.add(tempIDs);
                        results.add(tempNames);
                        results.add(tempEquipment);
                      }
                      currentUin = '';
                    }

                    setState(() {
                      uinField.text = '';
                      currentUin;
                      results;
                    });
                  },
                ),
                const SizedBox(height: 15),

                Flexible(
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFF87352F),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset: const Offset(3, 4),
                            ),
                          ],
                          border: Border.all(
                            width: 3,
                            color: const Color(0xFF500000),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        child: SingleChildScrollView(
                            child: Column(children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Search Results:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          for (int i = 0; i < results[0].length; i++)
                            Table(children: [
                              TableRow(children: <Widget>[
                                if (user.viewedUser == '')
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(results[1][i],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        )),
                                  ),
                                if (user.equipment == '')
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(results[2][i],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        )),
                                  ),
                                SizedBox(
                                  width: 25,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty
                                          .all<Color>(const Color(
                                              0xFF500000)), // changes color of text
                                      backgroundColor: MaterialStateProperty
                                          .all<Color>(const Color(
                                              0xFFdedede)), // changes color of button
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          // makes edges of button round instead of square
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ), // changes the color of the button
                                    ),
                                    onPressed: () {
                                      user.checkoutID = results[0][i];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HistoryDetailPage(),
                                          ));
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text('Get Info',
                                          style: TextStyle(fontSize: 15)),
                                    ),
                                  ),
                                ),
                              ])
                            ]),
                              if(results[0].isEmpty)
                                const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'No Checkout History Found',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ]))))
              ],
            ),
          ),
        ));
  }
}
