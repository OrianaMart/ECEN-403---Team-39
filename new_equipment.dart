import 'package:database_demo_app/equipment_detail_page.dart';
import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'equipment_page.dart';
import 'Data.dart' as user;

class NewEquipmentPage extends StatefulWidget {
  const NewEquipmentPage({super.key});
  @override
  NewEquipmentPageState createState() => NewEquipmentPageState();
}

class NewEquipmentPageState extends State<NewEquipmentPage> {
  final TextEditingController categoryField = TextEditingController();
  final TextEditingController locationField = TextEditingController();
  final TextEditingController nameField = TextEditingController();
  final TextEditingController amountField = TextEditingController();

  //for drop down menus
  var categories = List<String>.filled(0, '', growable: true);
  var locations = List<String>.filled(0, '', growable: true);

  //saves the current use of the page as the page name
  String pageName = 'Create New';
  bool creating = true;

  //error checking for equipment name and amount
  bool invalidName = false;
  bool invalidAmount = false;

  //variables for initial values
  String? category;
  String? location;
  String name = '';
  String amount = '';

  @override
  void initState() {
    super.initState();
    //checks to see if this page is being used to edit equipment
    if (user.equipment != '') {
      //page is being used to edit equipment
      pageName = 'Edit';
      creating = false;

    }
    //gets information for dropdowns
    () async {
      categories = await allCategories();
      locations = await allLocations();

      if(!creating){
        var temp = await getEquipmentInfo(user.equipment);
        category = temp[1];
        name = temp[0];
        location = temp[2];
        amount = temp[4];

        nameField.text = name;
        amountField.text = amount;
      }

      setState(() {
        categories;
        locations;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> categoryEntries =
        <DropdownMenuEntry<String>>[];
    final List<DropdownMenuEntry<String>> locationEntries =
        <DropdownMenuEntry<String>>[];

    if (categories.isNotEmpty && categories[0] == 'No Categories') {
      categoryEntries.add(DropdownMenuEntry(value: '', label: categories[0]));
    } else {
      for (int i = 0; i < categories.length; i++) {
        categoryEntries
            .add(DropdownMenuEntry(value: categories[i], label: categories[i]));
      }
    }

    if (locations.isNotEmpty && locations[0] == 'No Storage Locations') {
      locationEntries.add(DropdownMenuEntry(value: '', label: locations[0]));
    } else {
      for (int i = 0; i < locations.length; i++) {
        locationEntries
            .add(DropdownMenuEntry(value: locations[i], label: locations[i]));
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
              //Creates the text at the top of the equipment creation screen
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '$pageName Equipment.',
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
                  'Enter Equipment Information',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              DropdownMenu<String>(
                controller: categoryField,
                requestFocusOnTap: true,
                enableSearch: true,
                width: MediaQuery.of(context).size.width * .9,
                enableFilter: true,
                initialSelection: category,
                label: const Text('Category'),
                //makes the dropdown menu scrollable
                menuHeight: 300,
                //sets the entries to the dropdown menu
                dropdownMenuEntries: categoryEntries,
                onSelected: (String? unused) {},
              ),

              const SizedBox(height: 15),

              DropdownMenu<String>(
                controller: locationField,
                requestFocusOnTap: true,
                enableSearch: true,
                width: MediaQuery.of(context).size.width * .9,
                enableFilter: true,
                initialSelection: location,
                label: const Text('Storage Location'),
                //makes the dropdown menu scrollable
                menuHeight: 300,
                //sets the entries to the dropdown menu
                dropdownMenuEntries: locationEntries,
                onSelected: (String? unused) {},
              ),

              TextFormField(
                controller: nameField,
                enabled: creating,
                decoration: InputDecoration(
                  labelText: 'Equipment Name',
                  errorText: invalidName ? 'Equipment Already Exists' : null,
                ),
              ),
              TextFormField(
                controller: amountField,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  errorText: invalidAmount ? 'Incorrect Amount' : null,
                ),
              ),

              // Submits information to data base and returns user to equipment page
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  if (nameField.text != '' &&
                      amountField.text != '' &&
                      categoryField.text != '' &&
                      locationField.text != '') {
                    //if no category is left empty
                    if (creating) {
                      //if in creation mode
                      switch (await newEquipment(
                          nameField.text,
                          int.parse(amountField.text),
                          categoryField.text,
                          locationField.text)) {
                        case 'Creation Failed':
                          {
                            setState(() {
                              invalidName = true;
                              invalidAmount = false;
                            });
                          }
                          break;

                        case 'Invalid Amount':
                          {
                            setState(() {
                              invalidName = false;
                              invalidAmount = true;
                            });
                          }
                          break;

                        case 'Created':
                          {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EquipmentPage(),
                                ));
                            setState(() {
                              invalidName = false;
                              invalidAmount = false;
                            });
                          }
                          break;
                      }
                    } else {
                      //if in editing mode
                      if(await editEquipment(nameField.text, int.parse(amountField.text), categoryField.text, locationField.text) == 'Updated') {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EquipmentDetailPage(),
                            ));
                        setState(() {
                          invalidName = false;
                          invalidAmount = false;
                        });
                      } else {

                        setState(() {
                          invalidName = false;
                          invalidAmount = true;
                        });
                      }
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
