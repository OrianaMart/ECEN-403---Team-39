import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'forms_page.dart';

import 'internet_checker.dart';

class NewFormPage extends StatefulWidget {
  const NewFormPage({super.key});
  @override
  NewFormPageState createState() => NewFormPageState();
}

class NewFormPageState extends State<NewFormPage> {
  final TextEditingController formNameField = TextEditingController();
  final TextEditingController uinField = TextEditingController();

  //for drop down menus
  var formNames = List<String>.filled(0, '', growable: true);
  var usernames = List<String>.filled(0, '', growable: true);
  var uins = List<String>.filled(0, '', growable: true);

  bool invalidForm = false;
  bool invalidUin = false;

  String? currentUin;

  @override
  void initState() {
    super.initState();
    //gets information for dropdowns
    () async {
      var temp = await allFormIDs();

      usernames = await allStudentUsers();

      //iterates through all form IDs
      for (int i = 0; i < temp.length; i++) {
        //gets the form info
        var temp2 = await getFormInfo(temp[i]);

        //checks to see if the form name is already saved
        if (!formNames.contains(temp2[1])) {
          formNames.add(temp2[1]);
        }
      }

      //iterates through all student users
      for (int i = 0; i < usernames.length; i++) {
        //gets the user info
        var temp2 = await getUserInfo(usernames[i]);

        uins.add(temp2[1]);
      }

      setState(() {
        formNames;
        usernames;
        uins;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> formNameEntries =
        <DropdownMenuEntry<String>>[];
    final List<DropdownMenuEntry<String>> uinEntries =
        <DropdownMenuEntry<String>>[];

    if (formNames.isNotEmpty) {
      for (int i = 0; i < formNames.length; i++) {
        formNameEntries
            .add(DropdownMenuEntry(value: formNames[i], label: formNames[i]));
      }
    }

    if (usernames.isNotEmpty && usernames[0] != 'No Student Users') {
      for (int i = 0; i < uins.length; i++) {
        uinEntries.add(DropdownMenuEntry(value: uins[i], label: uins[i]));
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
              //Creates the text at the top of the form creation screen
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'New Form',
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
                  'Create a new form entry',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              DropdownMenu<String>(
                controller: formNameField,
                requestFocusOnTap: true,
                enableSearch: true,
                width: MediaQuery.of(context).size.width * .9,
                enableFilter: true,
                label: const Text('Form Name'),
                errorText: invalidForm ? 'Invalid Form Name' : null,
                inputDecorationTheme: const InputDecorationTheme(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder()),
                //makes the dropdown menu scrollable
                menuHeight: 300,
                //sets the entries to the dropdown menu
                dropdownMenuEntries: formNameEntries,
                onSelected: (String? unused) {},
              ),

              const SizedBox(height: 15),

              DropdownMenu<String>(
                  controller: uinField,
                  requestFocusOnTap: true,
                  enableSearch: true,
                  width: MediaQuery.of(context).size.width * .9,
                  label: const Text('UIN'),
                  hintText: currentUin,
                  errorText: invalidUin ? 'Select UIN' : null,
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
                    if (selectedUin != null && selectedUin != currentUin) {
                      currentUin = selectedUin;
                    } else {
                      currentUin = null;
                    }
                    setState(() {
                      uinField.text = '';
                      currentUin;
                    });
                  }),

              // Submits information to data base and returns user to form page
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  //checks to see if the app is still connected to the internet
                  connectionCheck(context);

                  invalidUin = false;
                  invalidForm = false;

                  if(formNameField.text == ''){
                    invalidForm = true;
                  }

                  if(currentUin == null){
                    invalidUin = true;
                  }

                  if (!invalidUin && !invalidForm) {
                    if (await newForm(
                                formNameField.text,
                                usernames[uins
                                    .indexWhere((uin) => uin == currentUin)]) ==
                            'Form Created' &&
                        formNameField.text != '') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FormsPage(),
                          ));
                    } else {
                      invalidForm = true;
                    }
                  }

                  setState(() {
                    invalidUin;
                    invalidForm;
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
