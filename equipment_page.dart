import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'navigator_drawer.dart';
import 'equipment_detail_page.dart';
import 'new_equipment.dart';
import 'Data.dart' as user;

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
  var searchIDs = List<String>.filled(0, '', growable: true);

  String? currentCategory;
  String? currentLocation;
  String? currentEquipment;

  String pageName = 'Equipment';
  String pageDescription = 'Search for or checkout equipment';
  String buttonText = 'Request';

  @override
  void initState() {
    super.initState();
    //if the users an admin
    if (user.adminStatus) {
      //change page description and buttonText
      pageDescription = 'Search for equipment';
      buttonText = 'Get Info';
    }

    //checks to see if it is in machine learning mode
    if (user.mlCategory != null) {
      pageName = 'Machine Learning';
      pageDescription = 'Search equipment within identified category';
      buttonText = 'Get Info';
      categories.add(user.mlCategory!);
      currentCategory = user.mlCategory;
    }

    () async {
      if (user.mlCategory != null) {
        //if the page is ml search

        categoryIDs = await equipmentByCategory(user.mlCategory!);

        //checks if the category has associated equipment
        if (categoryIDs[0] != 'Invalid Category') {
          //there is equipment in the category found
          allIDs = categoryIDs;
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
        } else {
          //there is no equipment for the category found by the ml
          allIDs.add('No Equipment');
          locations.add('No Locations');
        }
      } else {
        //if the page is equipment search
        categories = await allCategories();
        locations = await allLocations();
        allIDs = await allEquipment();
      }

      displayIDs = allIDs;

      setState(() {
        allIDs;
        categories;
        locations;
        displayIDs;
        searchIDs = displayIDs;
        locationIDs = [];
        categoryIDs = [];

        //change page settings
        pageName;
        pageDescription;
        buttonText;

        //Machine Learning
        currentCategory;
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

    for (int i = 0; i < searchIDs.length; i++) {
      equipmentEntries
          .add(DropdownMenuEntry(value: searchIDs[i], label: searchIDs[i]));
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                //Header for page
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '$pageName Search',
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 7),

                //Sub Header for page
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    pageDescription,
                    style: const TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                //Dropdown menu for selecting the category to search by
                DropdownMenu<String>(
                    controller: categoryField,
                    enabled: (pageName != 'Machine Learning'),
                    initialSelection: user.mlCategory,
                    requestFocusOnTap: true,
                    enableSearch: true,
                    width: MediaQuery.of(context).size.width * .9,
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
                      if (currentEquipment != null &&
                          !displayIDs.contains(currentEquipment)) {
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
                        searchIDs = displayIDs;
                        currentEquipment;
                        equipmentField.text;
                      });
                    }),

                const SizedBox(height: 15),
                DropdownMenu<String>(
                  controller: locationField,
                  requestFocusOnTap: true,
                  enableSearch: true,
                  width: MediaQuery.of(context).size.width * .9,
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
                      searchIDs = displayIDs;
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
                  width: MediaQuery.of(context).size.width * .9,
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

                //admin only new equipment button
                if (user.adminStatus && user.mlCategory == null)
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(
                            0xFFdedede), // changes color of the text
                        backgroundColor: const Color(
                            0xFF963e3e), // changes the color of the button
                      ),
                      onPressed: () {
                        user.equipment = '';
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewEquipmentPage(),
                            ));
                      },
                      child: const Text('Create New Equipment')),

                if (user.adminStatus && user.mlCategory == null)
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
                          for (int i = 0; i < displayIDs.length; i++)
                            Table(children: [
                              if (displayIDs[0] == 'No Equipment')
                              const TableRow(children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'No Equipment Found',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ]),
                              if (displayIDs[0] != 'No Equipment')
                                TableRow(children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(displayIDs[i],
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
                                        user.equipment = displayIDs[i];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const EquipmentDetailPage(),
                                            ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(buttonText,
                                            style:
                                                const TextStyle(fontSize: 15)),
                                      ),
                                    ),
                                  ),
                                ]),
                            ]),
                        ]))))
              ],
            ),
          ),
        ));
  }
}
