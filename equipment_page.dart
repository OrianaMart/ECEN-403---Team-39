import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'Data.dart' as user;
import 'login_screen.dart';
import 'home_page.dart';
import 'equipment_detail_page.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({Key? key}) : super(key: key);
  @override
  EquipmentPageState createState() {
    return EquipmentPageState();
  }
}

class EquipmentPageState extends State<EquipmentPage> {
  final TextEditingController categoryField = TextEditingController();
  final TextEditingController locationField = TextEditingController();
  final TextEditingController equipmentField = TextEditingController();

  var allIDs = List<String>.filled(0, '', growable: true);
  var categories = List<String>.filled(0, '', growable: true);
  var categoryIDs = List<String>.filled(0, '', growable: true);
  var locations = List<String>.filled(0, '', growable: true);
  var locationIDs = List<String>.filled(0, '', growable: true);
  var displayIDs = List<String>.filled(0, '', growable: true);

  String? currentCategory;
  String? currentLocation;
  String? currentEquipment;

  @override
  void initState() {
    super.initState();
    () async {
      categories = await allCategories();
      locations = await allLocations();
      allIDs = await allEquipment();
      setState(() {
        allIDs;
        categories;
        locations;
        displayIDs = allIDs;
        locationIDs = [];
        categoryIDs = [];
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> categoryEntries =
        <DropdownMenuEntry<String>>[];
    final List<DropdownMenuEntry<String>> locationEntries =
        <DropdownMenuEntry<String>>[];
    final List<DropdownMenuEntry<String>> equipmentEntries =
        <DropdownMenuEntry<String>>[];

    for (int i = 0; i < categories.length; i++) {
      categoryEntries
          .add(DropdownMenuEntry(value: categories[i], label: categories[i]));
    }

    for (int i = 0; i < locations.length; i++) {
      locationEntries
          .add(DropdownMenuEntry(value: locations[i], label: locations[i]));
    }

    for (int i = 0; i < displayIDs.length; i++) {
      equipmentEntries
          .add(DropdownMenuEntry(value: displayIDs[i], label: displayIDs[i]));
    }

    return Scaffold(
        // Creates smart inventory app bar at top
        appBar: AppBar( //creates top bar of the app that includes navigation widget
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
        //Navigation drawer code starts here
        drawer: Drawer( //Creates navigation drawer
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const SizedBox(
                height: 115,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF500000),
                  ),
                  child: Text(
                    'Navigation',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),

              const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Hi,',
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Sends user back to home page when home button is pushed
              ListTile( //Home Drawer Option
                leading: const Icon(Icons.home),
                title: const Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF500000),
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
                },
              ),

              // Sends user to the profile page when this button is pushed
              ListTile( //Profile Drawer Option
                leading: const Icon(Icons.person),
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF500000),
                  ),
                ),
                onTap: () {
                  //add code here
                },
              ),

              // Sends users to equipment search page
              ListTile( //Equipment Drawer Option
                leading: const Icon(Icons.shopping_cart),
                title: const Text(
                  'Equipment',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF500000),
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => const EquipmentPage(),
                  ));
                },
              ),

              // Sends user to page to submit forms for equipment checkout
              ListTile( //Forms Drawer Option
                leading: const Icon(Icons.checklist),
                title: const Text(
                  'Forms',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF500000),
                  ),
                ),
                onTap: () {
                  // add more code here
                },
              ),

              // Sends users to
              ListTile( //Forms Drawer Option
                leading: const Icon(Icons.camera_alt_rounded),
                title: const Text(
                  'Scan',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF500000),
                  ),
                ),
                onTap: () {
                  // add more code here
                },
              ),

              //Sends user to logout confirmation pop up box
              ListTile( //Logout Drawer Option
                leading: const Icon(Icons.exit_to_app),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF500000),
                  ),
                ),
                onTap: () {
                  user.username = '';
                  user.adminStatus = false;
                  _logoutConfirmation(context);
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  // add more code here
                },
              ),
            ],
          ),
        ),

        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 15),
                //Dropdown menu for selecting the category to search by
                DropdownMenu<String>(
                    controller: categoryField,
                    requestFocusOnTap: true,
                    enableSearch: true,
                    width: 370,
                    label: const Text('Category'),
                    hintText: currentCategory,
                    //Prevents the hint text from going away
                    inputDecorationTheme: const InputDecorationTheme(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder()),
                    //makes the dropdown menu scrollable
                    menuHeight: 300,
                    //sets the entries to the dropdown menu
                    dropdownMenuEntries: categoryEntries,
                    enableFilter: true,
                    onSelected: (String? selectedCategory) async {
                      if (selectedCategory != null &&
                          selectedCategory != currentCategory) {
                        //If the category is a previously unselected category and is a valid category in the inventory

                        //sets the current category to the selected one
                        currentCategory = selectedCategory;

                        //Obtains all of the equipment within the searched category
                        categoryIDs =
                            await equipmentByCategory(selectedCategory);

                        //empties the selectable locations to be refilled by those that are valid
                        locations = [];

                        //iterates through the categoryIDs to locate all locations available for the selected category
                        for (int i = 0; i < categoryIDs.length; i++) {
                          //Obtains the location for each equipment in the category
                          var temp = await getEquipmentInfo(categoryIDs[i]);

                          //checks to see if the location has already been saved
                          if (!locations.contains(temp[2])) {
                            //if the location has yet to be saved, it is saved to the list of locations
                            locations.add(temp[2]);
                          }
                        }

                        //checks to see if the currently selected location has equipment within the selected category
                        if (locationIDs.isNotEmpty &&
                            locations.contains(currentLocation)) {
                          //empties the displayID list so that it can be refilled with the values in both selected category and location
                          displayIDs = [];

                          //iterates through the locationIDs
                          for (int i = 0; i < locationIDs.length; i++) {
                            //determines if the current locationID is within the list of categoryIDs
                            if (categoryIDs.contains(locationIDs[i])) {
                              //if there is equipment in the selected category and location that equipment is searchable
                              displayIDs.add(locationIDs[i]);
                            }
                          }
                        } else {
                          //When the selected location is empty or there is no equipment with both selected category and location

                          //sets displayIDs to categoryIDs
                          displayIDs = categoryIDs;

                          //resets the location selection by emptying locationIDs, setting the selected location to null, and emptying the associated text field.
                          locationIDs = [];
                          currentLocation = null;
                          locationField.text = '';
                        }
                      } else {
                        //When an invalid category is selected or the current category is selected (also used for removing selected value)

                        //resets the category dropdown menu by emptying categoryIDs, setting the selected category to null, and emptying the associated text field
                        categoryIDs = [];
                        currentCategory = null;

                        //resets the available locations by setting the locations list to be allLocations
                        locations = await allLocations();

                        //checks to see if there is a current location
                        if (locationIDs.isNotEmpty) {
                          //if there is a current location it sets displayIDs to be the locationIDs
                          displayIDs = locationIDs;

                        } else {
                          //If there is no selected location

                          //resets the location selection by emptying locationIDs, setting the current location to null, and emptying the associated text field.
                          locationIDs = [];
                          currentLocation = null;
                          locationField.text = '';

                          //resets displayed equipment to all equipment IDs
                          displayIDs = allIDs;
                        }
                      }
                      //checks to see if there is a selected equipment
                      if(currentEquipment != null && !displayIDs.contains(currentEquipment)) {
                        //updates the equipment selection by  setting the selected equipment to null and emptying the associated text field.
                        currentEquipment = null;
                        equipmentField.text = '';
                      }
                      //sets the state for all the variables that have been changed through the selection
                      setState(() {
                        //Updates all potentially changed category variables
                        categoryIDs;
                        currentCategory;
                        categoryField.text = '';

                        //Updates all potentially changed location variables
                        locationIDs;
                        locations;
                        currentLocation;
                        locationField.text;

                        //Updates all potentially changed equipment variables
                        displayIDs;
                        currentEquipment;
                        equipmentField.text;
                      });
                    }),

                const SizedBox(height: 15),
                DropdownMenu<String>(
                  controller: locationField,
                  requestFocusOnTap: true,
                  enableSearch: true,
                  width: 370,
                  label: const Text('Storage Location'),
                  enableFilter: true,
                  hintText: currentLocation,
                  //Prevents the hint text from going away
                  inputDecorationTheme: const InputDecorationTheme(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder()),
                  //makes the dropdown menu scrollable
                  menuHeight: 300,
                  //sets the entries to the dropdown menu
                  dropdownMenuEntries: locationEntries,
                  onSelected: (String? selectedLocation) async {
                    if (selectedLocation != null &&
                        selectedLocation != currentLocation) {
                      //checks to see if the selected location is from the list and ensures it isn't the currently selected location

                      //sets the current location to the selected location
                      currentLocation = selectedLocation;

                      //Obtains all of the equipmentIDs associated with the selected location
                      locationIDs = await equipmentByLocation(selectedLocation);

                      //checks to see if there is a selected category
                      if (categoryIDs.isNotEmpty) {
                        //there is a selected category

                        //clear display equipment IDs to be filled by for loop
                        displayIDs = [];

                        //iterates over the length of categoryIDs to determine if there are common equipments in locationIDs
                        for (int i = 0; i < categoryIDs.length; i++) {
                          //determines if the categoryID is common with locationID
                          if (locationIDs.contains(categoryIDs[i])) {
                            //makes displayIDs a list of all equipment common between both lists
                            displayIDs.add(categoryIDs[i]);
                          }
                        }
                        //checks to see if there were any found equipment for the category and location
                        if (displayIDs.isEmpty) {
                          //if there are no equipment with both category and location

                          //resets location selection
                          locationIDs = [];
                          displayIDs = categoryIDs;
                          currentLocation = null;
                        }
                      } else {
                        //there is no selected category

                        //sets displayIDs to be locationIDs
                        displayIDs = locationIDs;
                      }
                    } else {
                      //When the selected location is invalid, null, or the same as it previously was

                      //resets the location selection by emptying locationIDs, setting the current location to null, and emptying the associated text field.
                      locationIDs = [];
                      currentLocation = null;

                      //checks if there is a selected category
                      if (categoryIDs.isNotEmpty) {
                        //if there is a selected category

                        //the displayed equipment are those valid for the category
                        displayIDs = categoryIDs;
                      } else {
                        //if there is not a selected category

                        //all equipment can be displayed
                        displayIDs = allIDs;
                      }
                    }

                    //checks to see if the selected equipment is within the list of acceptable equipments
                    if (currentEquipment != null &&
                        !displayIDs.contains(currentEquipment)) {
                      //the current equipment is not valid for the selected location and or category

                      //resets the equipment dropdown
                      currentEquipment = null;
                      equipmentField.text = '';
                    }
                    //sets the state for all changed variables
                    setState(() {
                      //location dropdown menu variables
                      locationIDs;
                      currentLocation;
                      locationField.text = '';

                      //equipment dropdown menu variables
                      displayIDs;
                      currentEquipment;
                      equipmentField.text;
                    });
                  },
                ),
                const SizedBox(height: 15),
                DropdownMenu<String>(
                  controller: equipmentField,
                  requestFocusOnTap: true,
                  enableSearch: true,
                  width: 370,
                  enableFilter: true,
                  label: const Text('Equipment Name'),
                  hintText: currentEquipment,
                  //Prevents the hint text from going away
                  inputDecorationTheme: const InputDecorationTheme(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder()),
                  //makes the dropdown menu scrollable
                  menuHeight: 300,
                  //sets the entries to the dropdown menu
                  dropdownMenuEntries: equipmentEntries,
                  onSelected: (String? selectedEquipment) async {
                    bool reset = true;
                    if (selectedEquipment != null &&
                        selectedEquipment != currentEquipment) {
                      //checks to see if the selected equipment is a valid value and not the previously selected one

                      //sets the current equipment to be the selected equipment
                      currentEquipment = selectedEquipment;

                      //checks to see if the selected equipment is allowed within the displayIDs
                      if (displayIDs.contains(currentEquipment)) {
                        //if the equipment is valid

                        //clears then sets displayIDs to current equipment
                        displayIDs = [];
                        displayIDs.add(currentEquipment!);

                        //sets reset to false to prevent resetting the equipment list
                        reset = false;
                      }
                    }
                    //checks to see if the equipment list needs reset
                    if (reset) {
                      //clears current equipment list
                      displayIDs = [];
                      currentEquipment = null;

                      //checks to see if there is a selected location
                      if (locationIDs.isNotEmpty) {
                        //there is a selected location

                        //checks to see if there is a selected category as well
                        if (categoryIDs.isNotEmpty) {
                          //iterates over the length of categoryIDs to determine if there are common equipments in locationIDs
                          for (int i = 0; i < categoryIDs.length; i++) {
                            //determines if the categoryID is common with locationID
                            if (locationIDs.contains(categoryIDs[i])) {
                              //makes displayIDs a list of all equipment common between both lists
                              displayIDs.add(categoryIDs[i]);
                            }
                          }
                        } else {
                          //There is no selected category

                          //sets equipment list to the list of equipment in the location
                          displayIDs = locationIDs;
                        }
                      } else {
                        //there is no selected location

                        //checks for category
                        if (categoryIDs.isNotEmpty) {
                          displayIDs = categoryIDs;
                        } else {
                          //there is no category or location
                          displayIDs = allIDs;
                        }
                      }
                    }
                    //sets state for all changed variables
                    setState(() {
                      currentEquipment;
                      equipmentField.text = '';
                      displayIDs;
                    });
                  },
                ),
                const SizedBox(height: 15),
                Flexible(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        child: SingleChildScrollView(
                            child: Column(children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Search Results:',
                                style: TextStyle(fontSize: 20)),
                          ),
                          const Text('Equipment', textAlign: TextAlign.center),
                          for (int i = 0; i < displayIDs.length; i++)
                            Table(children: [
                              TableRow(children: <Widget>[
                                Text(displayIDs[i],
                                    textAlign: TextAlign.center),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: const Color(0xFFdedede), // changes color of the text
                                      backgroundColor: const Color(0xFF963e3e), // changes the color of the button
                                    ),
                                    /*style: ButtonStyle( 0xFFdedede
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ))),
                                    */
                                    onPressed: () {
                                      user.equipment = displayIDs[i];
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => const EquipmentDetailPage(),
                                      ));
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                          'Select',
                                          style: TextStyle(fontSize: 14)
                                      ),
                                    ),
                                  ),
                              ])
                            ]),
                        ]))))
              ],
            ),
          ),
        ));
  }
}

//Function to make a pop out dialogue box appear when logout button is pushed
Future<void> _logoutConfirmation(BuildContext context) async {
  return showDialog<void> (
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Signing Out'),
        content: const SingleChildScrollView(
          child:ListBody(
            children: <Widget>[
              Text('Are you sure you want to log out?')
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
              child: const Text('Cancel')
          ),
          TextButton(
              onPressed: () {
                _performLogout(context);
              },
              style: TextButton.styleFrom(
                  foregroundColor: Colors.blue
              ),
              child: const Text('Logout')
          ),
        ],
      );
    },
  );
}

//Function to perform the actions of logging out or not when either button is pushed on pop out dialogue box
void _performLogout(BuildContext context) {
  Navigator.of(context).pop();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}