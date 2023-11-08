import 'package:flutter/material.dart';
import 'navigator_drawer.dart';
import 'database_functions.dart';
import 'new_form_page.dart';
import 'Data.dart' as user;

class FormsPage extends StatefulWidget {
  const FormsPage({Key? key}) : super(key: key);
  @override
  FormsPageState createState() {
    return FormsPageState();
  }
}

class FormsPageState extends State<FormsPage> {
  String pageDescription =
      'Follow the steps below to properly fill out the required forms for equipment checkout.';

  @override
  void initState() {
    super.initState();

    if (user.adminStatus) {
      pageDescription = 'Search for forms';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),

      // Adds Navigation drawer to the Equipment page
      drawer: const NavigatorDrawer(),

      //Creates body of the page
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              //Header for page
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Forms',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  pageDescription,
                  style: const TextStyle(
                    fontSize: 17.0,
                  ),
                ),
              ),
              if (!user.adminStatus) const SizedBox(height: 20),

              if (!user.adminStatus) const StudentFormsPage(),

              if (user.adminStatus) const AdminFormsPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentFormsPage extends StatelessWidget {
  const StudentFormsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF963e3e),
        borderRadius: BorderRadius.circular(12.0),
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
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Steps:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '1) Print required form',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              //fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2),
          Text(
            '2) Fill out required form',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              //fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2),
          Text(
            '3) Turn in form to your TA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              //fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2),
        ],
      ),
    );
  }
}

class AdminFormsPage extends StatefulWidget {
  const AdminFormsPage({Key? key}) : super(key: key);
  @override
  AdminFormsPageState createState() {
    return AdminFormsPageState();
  }
}

class AdminFormsPageState extends State<AdminFormsPage> {
  final TextEditingController formNameField = TextEditingController();
  final TextEditingController uinField = TextEditingController();

  var forms = List<String>.filled(0, '', growable: true);
  var usernames = List<String>.filled(0, '', growable: true);
  var uins = List<String>.filled(0, '', growable: true);

  var allInfo = List<List<String>>.filled(3, [], growable: true);
  var results = List<List<String>>.filled(3, [], growable: true);

  String? currentForm;
  String? currentUin;

  @override
  void initState() {
    super.initState();
    () async {
      var temp = await allFormIDs();

      allInfo = [];
      allInfo.add(temp);

      var tempUsers = List<String>.filled(0, '', growable: true);
      var tempFormNames = List<String>.filled(0, '', growable: true);

      //iterates through all form IDs
      for (int i = 0; i < temp.length; i++) {
        //gets the form info
        var temp2 = await getFormInfo(temp[i]);

        tempUsers.add(temp2[2]);
        tempFormNames.add(temp2[1]);

        //checks to see if the form name is already saved
        if (!forms.contains(temp2[1])) {
          forms.add(temp2[1]);
        }

        //checks to see if the username is already saved
        if (!usernames.contains(temp2[2])) {
          usernames.add(temp2[2]);
        }
      }

      allInfo.add(tempUsers);
      allInfo.add(tempFormNames);

      for (int i = 0; i < usernames.length; i++) {
        var temp = await getUserInfo(usernames[i]);

        uins.add(temp[1]);
      }

      results = [];
      results.add(List.from(allInfo[0]));
      results.add(List.from(allInfo[1]));
      results.add(List.from(allInfo[2]));

      setState(() {
        forms;
        usernames;
        uins;

        allInfo;
        results;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> formEntries =
        <DropdownMenuEntry<String>>[];
    final List<DropdownMenuEntry<String>> uinEntries =
        <DropdownMenuEntry<String>>[];

    if (forms.isNotEmpty) {
      for (int i = 0; i < forms.length; i++) {
        formEntries.add(DropdownMenuEntry(value: forms[i], label: forms[i]));
      }
    }

    if (uins.isNotEmpty) {
      for (int i = 0; i < uins.length; i++) {
        uinEntries.add(DropdownMenuEntry(value: uins[i], label: uins[i]));
      }
    }

    return Column(mainAxisSize: MainAxisSize.min, children: [
      const SizedBox(height: 15),
      DropdownMenu<String>(
          controller: formNameField,
          requestFocusOnTap: true,
          enableSearch: true,
          width: MediaQuery.of(context).size.width * .9,
          label: const Text('Form Name'),
          hintText: currentForm,
          //Prevents the hint text from going away
          inputDecorationTheme: const InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder()),
          //makes the dropdown menu scrollable
          menuHeight: 300,
          //sets the entries to the dropdown menu
          dropdownMenuEntries: formEntries,
          enableFilter: true,
          onSelected: (String? selectedForm) async {

            //reloads the results with all values
            results = [];
            results.add(List.from(allInfo[0]));
            results.add(List.from(allInfo[1]));
            results.add(List.from(allInfo[2]));

            if (selectedForm != null && selectedForm != currentForm) {
              currentForm = selectedForm;

              for (int i = 0; i < results[0].length; i++) {
                if (results[2][i] != currentForm) {
                  results[0].removeAt(i);
                  results[1].removeAt(i);
                  results[2].removeAt(i);
                  i--;
                }
              }
            } else {
              currentForm = null;
            }

            //checks to see if there is a selected uin
            if(currentUin != null) {
              for (int i = 0; i < results[0].length; i++) {
                if (results[1][i] != usernames[uins.indexWhere((uin) => uin == currentUin)]) {
                  results[0].removeAt(i);
                  results[1].removeAt(i);
                  results[2].removeAt(i);
                  i--;
                }
              }
            }

            setState(() {
              formNameField.text = '';
              currentForm;
              results;
            });
          }),
      const SizedBox(height: 15),
      DropdownMenu<String>(
          controller: uinField,
          requestFocusOnTap: true,
          enableSearch: true,
          width: MediaQuery.of(context).size.width * .9,
          label: const Text('UIN'),
          hintText: currentUin,
          //Prevents the hint text from going away
          inputDecorationTheme: const InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder()),
          //makes the dropdown menu scrollable
          menuHeight: 300,
          //sets the entries to the dropdown menu
          dropdownMenuEntries: uinEntries,
          enableFilter: true,
          onSelected: (String? selectedUin) async {

            //reloads the results with all values
            results = [];
            results.add(List.from(allInfo[0]));
            results.add(List.from(allInfo[1]));
            results.add(List.from(allInfo[2]));

            if (selectedUin != null && selectedUin != currentUin) {
              currentUin = selectedUin;

              for (int i = 0; i < results[0].length; i++) {
                if (results[1][i] != usernames[uins.indexWhere((uin) => uin == currentUin)]) {
                  results[0].removeAt(i);
                  results[1].removeAt(i);
                  results[2].removeAt(i);
                  i--;
                }
              }
            } else {
              currentUin = null;

            }

            //checks to see if there is a selected form name
            if(currentForm != null) {
              for (int i = 0; i < results[0].length; i++) {
                if (results[2][i] != currentForm) {
                  results[0].removeAt(i);
                  results[1].removeAt(i);
                  results[2].removeAt(i);
                  i--;
                }
              }
            }

            setState(() {
              uinField.text = '';
              currentUin;
              results;
            });
          }),
      const SizedBox(height: 15),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor:
                const Color(0xFFdedede), // changes color of the text
            backgroundColor:
                const Color(0xFF963e3e), // changes the color of the button
          ),
          onPressed: () {
            user.equipment = '';
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewFormPage(),
                ));
          },
          child: const Text('Create New Form')),
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
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                      if (uinField.text == '')
                        Align(
                          alignment: Alignment.center,
                          child: Text(results[1][i],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      if (formNameField.text == '')
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
                            foregroundColor: MaterialStateProperty.all<Color>(
                                const Color(
                                    0xFF500000)), // changes color of text
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(
                                    0xFFdedede)), // changes color of button
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                // makes edges of button round instead of square
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ), // changes the color of the button
                          ),
                          onPressed: () {
                            _deleteConfirmation(context, results[0][i]);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child:
                                Text('Delete', style: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),
                    ])
                  ]),
                if (results[0].isEmpty)
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'No Forms Found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ]))))
    ]);
  }
}

//Function to make a pop out dialogue box appear when delete button is pushed
Future<void> _deleteConfirmation(BuildContext context, String formID) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Form'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to permanently delete this form')
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text('Go Back')),
          TextButton(
              onPressed: () async {
                if (await removeForm(formID) == 'Removed') {
                  user.equipment = '';
                  user.checkoutID = '';
                  user.requestID = '';
                  user.mlCategory = null;
                  user.viewedUser = '';
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const FormsPage(),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('Delete')),
        ],
      );
    },
  );
}
