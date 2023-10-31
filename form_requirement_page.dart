import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'equipment_detail_page.dart';
import 'Data.dart' as user;

class AddFormRequirementPage extends StatefulWidget {
  const AddFormRequirementPage({super.key});
  @override
  AddFormRequirementPageState createState() => AddFormRequirementPageState();
}

class AddFormRequirementPageState extends State<AddFormRequirementPage> {
  final TextEditingController nameField = TextEditingController();

  //for drop down menu
  var forms = List<String>.filled(0, '', growable: true);
  bool invalidForm = false;

  @override
  void initState() {
    super.initState();
    () async {
      var temp = await allFormIDs();

      //iterates through all form IDs
      for(int i = 0; i < temp.length; i++) {
        //gets the form info
        var temp2 = await getFormInfo(temp[i]);

        //checks to see if the form name is already saved
        if(!forms.contains(temp2[1])){
          forms.add(temp2[1]);
        }
      }
      setState(() {
        forms;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> formEntries =
        <DropdownMenuEntry<String>>[];

    if (forms.isNotEmpty) {
      for (int i = 0; i < forms.length; i++) {
        formEntries
            .add(DropdownMenuEntry(value: forms[i], label: forms[i]));
      }
    }

    // Creates the app bar at the top of the screen
    return Scaffold(
      appBar: AppBar(
        //creates top bar of the app
        title: const Text('Smart Inventory',
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
              //Creates the text at the top of the equipment creation screen
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  user.equipment,
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Add form requirement for selected equipment.',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              DropdownMenu<String>(
                controller: nameField,
                requestFocusOnTap: true,
                enableSearch: true,
                width: MediaQuery.of(context).size.width * .9,
                enableFilter: true,
                label: const Text('Form Name'),
                //makes the dropdown menu scrollable
                menuHeight: 300,
                errorText: invalidForm ? 'Form already required for equipment': null,
                //sets the entries to the dropdown menu
                dropdownMenuEntries: formEntries,
                onSelected: (String? unused) {},
              ),

              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  if(nameField.text != '') {
                    if(await addFormRequirement(nameField.text, user.equipment) == 'Form Required') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EquipmentDetailPage(),
                          ));
                      setState(() {
                        invalidForm = false;
                      });
                    } else {
                      invalidForm = true;
                    }
                  }
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


class RemoveFormRequirementPage extends StatefulWidget {
  const RemoveFormRequirementPage({super.key});
  @override
  RemoveFormRequirementPageState createState() => RemoveFormRequirementPageState();
}

class RemoveFormRequirementPageState extends State<RemoveFormRequirementPage> {
  final TextEditingController nameField = TextEditingController();

  //for drop down menu
  var forms = List<String>.filled(0, '', growable: true);

  @override
  void initState() {
    super.initState();
    () async {
      //temp for equipment information
      var temp = await getEquipmentInfo(user.equipment);

      forms = temp[5].split(', ');
      setState(() {
        forms;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> formEntries =
    <DropdownMenuEntry<String>>[];

    if (forms.isNotEmpty) {
      for (int i = 0; i < forms.length; i++) {
        formEntries
            .add(DropdownMenuEntry(value: forms[i], label: forms[i]));
      }
    }

    // Creates the app bar at the top of the screen
    return Scaffold(
      appBar: AppBar(
        //creates top bar of the app
        title: const Text('Smart Inventory',
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
              //Creates the text at the top of the equipment creation screen
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  user.equipment,
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Remove form requirement for selected equipment.',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              DropdownMenu<String>(
                controller: nameField,
                requestFocusOnTap: true,
                enableSearch: true,
                width: MediaQuery.of(context).size.width * .9,
                enableFilter: true,
                label: const Text('Form Name'),
                //makes the dropdown menu scrollable
                menuHeight: 300,
                //sets the entries to the dropdown menu
                dropdownMenuEntries: formEntries,
                onSelected: (String? unused) {},
              ),

              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  if(nameField.text != '') {
                    if(await removeFormRequirement(nameField.text, user.equipment) == 'Form Removed') {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EquipmentDetailPage(),
                          ));
                    }
                  }
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
