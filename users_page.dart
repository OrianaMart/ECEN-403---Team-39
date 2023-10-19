import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'navigator_drawer.dart';
import 'profile_page.dart';
import 'sign_up.dart';
import 'Data.dart' as user;

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  UsersPageState createState() {
    return UsersPageState();
  }
}

class UsersPageState extends State<UsersPage> {
  final TextEditingController uinField = TextEditingController();
  final TextEditingController usernameField = TextEditingController();

  var studentUsers = List<String>.filled(0, '', growable: true);
  var studentUins = List<String>.filled(0, '', growable: true);

  var adminUsers = List<String>.filled(0, '', growable: true);
  var adminUins = List<String>.filled(0, '', growable: true);

  var uins = List<String>.filled(0, '', growable: true);
  var displayUins = List<String>.filled(0, '', growable: true);

  var usernames = List<String>.filled(0, '', growable: true);
  var displayUsernames = List<String>.filled(0, '', growable: true);

  String? currentUin;
  String? currentUsername;

  bool admins = true;
  bool students = true;

  @override
  void initState() {
    super.initState();
    () async {
      studentUsers = await allStudentUsers();
      adminUsers = await allAdminUsers();

      for (int i = 0; i < studentUsers.length; i++) {
        var temp = await getUserInfo(studentUsers[i]);
        studentUins.add(temp[1]);
      }

      for (int i = 0; i < adminUsers.length; i++) {
        var temp = await getUserInfo(adminUsers[i]);
        adminUins.add(temp[1]);
      }

      setState(() {
        studentUsers;
        studentUins;

        adminUsers;
        adminUins;

        uins = studentUins + adminUins;
        displayUins = uins;

        usernames = studentUsers + adminUsers;
        displayUsernames = usernames;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> uinEntries =
        <DropdownMenuEntry<String>>[];

    final List<DropdownMenuEntry<String>> usernameEntries =
    <DropdownMenuEntry<String>>[];

    if (usernames.contains('No Student Users') || usernames.contains('No Admin Users')) {
      uinEntries.add(DropdownMenuEntry(value: '', label: usernames[0]));
      usernameEntries.add(DropdownMenuEntry(value: '', label: usernames[0]));
      if (usernames.contains('No Student Users') &&
          usernames.contains('No Admin Users')) {
        usernameEntries.add(DropdownMenuEntry(value: '', label: usernames[1]));
        uinEntries.add(DropdownMenuEntry(value: '', label: usernames[1]));
      }
    } else {
      for (int i = 0; i < uins.length; i++) {
        uinEntries.add(DropdownMenuEntry(value: uins[i], label: uins[i]));
        usernameEntries.add(DropdownMenuEntry(value: usernames[i], label: usernames[i]));
      }
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
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'User Search',
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
                    'Search for a user account',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                DropdownMenu<String>(
                    controller: uinField,
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
                      if(selectedUin != null && selectedUin != currentUin) {
                        currentUin = selectedUin;

                        var tempUsername = usernames[uins.indexWhere((uin) => uin == currentUin!)];
                        displayUsernames = [];
                        displayUsernames.add(tempUsername);

                        displayUins = [];
                        displayUins.add(currentUin!);

                      } else {
                        currentUin = null;
                        if (students) {
                          displayUins = studentUins;
                          displayUsernames = studentUsers;
                        } else {
                          displayUins = [];
                          displayUsernames = [];
                        }

                        if (admins) {
                          displayUins = displayUins + adminUins;
                          displayUsernames = displayUsernames + adminUsers;
                        }

                      }
                      setState(() {
                        uinField.text = '';
                        currentUin;

                        usernameField.text = '';
                        currentUsername = null;

                        displayUins;
                        displayUsernames;
                      });
                    }),

                const SizedBox(height: 15),
                DropdownMenu<String>(
                    controller: usernameField,
                    requestFocusOnTap: true,
                    enableSearch: true,
                    width: MediaQuery.of(context).size.width * .9,
                    label: const Text('Username'),
                    enableFilter: true,
                    hintText: currentUsername,
                    //Prevents the hint text from going away
                    inputDecorationTheme: const InputDecorationTheme(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder()),
                    //makes the dropdown menu scrollable
                    menuHeight: 300,
                    //sets the entries to the dropdown menu
                    dropdownMenuEntries: usernameEntries,
                    onSelected: (String? selectedUsername) async {
                      if(selectedUsername != null && selectedUsername != currentUsername) {
                        currentUsername = selectedUsername;

                        var tempUin = uins[usernames.indexWhere((username) => username == currentUsername!)];
                        displayUins = [];
                        displayUins.add(tempUin);

                        displayUsernames = [];
                        displayUsernames.add(currentUsername!);

                      } else {
                        currentUsername = null;
                        if (students) {
                          displayUins = studentUins;
                          displayUsernames = studentUsers;
                        } else {
                          displayUins = [];
                          displayUsernames = [];
                        }

                        if (admins) {
                          displayUins = displayUins + adminUins;
                          displayUsernames = displayUsernames + adminUsers;
                        }

                      }
                      setState(() {
                        usernameField.text = '';
                        currentUsername;

                        uinField.text = '';
                        currentUin = null;

                        displayUins;
                        displayUsernames;
                      });
                    }),

                const SizedBox(height: 15),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Text('Students'), Text('Admins')],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Checkbox(
                          value: students,
                          onChanged: (bool? value) {
                            students = value!;

                            if (students) {
                              uins = studentUins;
                              usernames = studentUsers;
                            } else {
                              uins = [];
                              usernames = [];
                            }

                            if (admins) {
                              uins = uins + adminUins;
                              usernames = usernames + adminUsers;
                            }

                            if(!students && !admins){
                              admins = true;
                              uins = adminUins;
                              usernames = adminUsers;
                            }

                            if(currentUin != null && !uins.contains(currentUin)){
                              currentUin = null;
                              uinField.text = '';
                            } else if(currentUin != null) {
                              var tempUsername = usernames[uins.indexWhere((uin) => uin == currentUin!)];
                              usernames = [];
                              usernames.add(tempUsername);

                              uins = [];
                              uins.add(currentUin!);
                            }

                            if(currentUsername != null && !usernames.contains(currentUsername)){
                              currentUsername = null;
                              usernameField.text = '';
                            } else if(currentUsername != null) {
                              var tempUin = uins[usernames.indexWhere((username) => username == currentUsername!)];
                              uins = [];
                              uins.add(tempUin);

                              usernames = [];
                              usernames.add(currentUsername!);
                            }

                            setState(() {
                              uinField.text;
                              usernameField.text;
                              students;

                              uins;
                              displayUins = uins;

                              usernames;
                              displayUsernames = usernames;
                            });
                          }),
                      Checkbox(
                          value: admins,
                          onChanged: (bool? value) {
                            admins = value!;

                            if (students) {
                              uins = studentUins;
                              usernames = studentUsers;
                            } else {
                              uins = [];
                              usernames = [];
                            }

                            if (admins) {
                              uins = uins + adminUins;
                              usernames = usernames + adminUsers;
                            }

                            if(!students && !admins){
                              students = true;
                              uins = studentUins;
                              usernames = studentUsers;
                            }

                            if(currentUin != null && !uins.contains(currentUin)){
                              currentUin = null;
                              uinField.text = '';
                            } else if(currentUin != null) {
                              var tempUsername = usernames[uins.indexWhere((uin) => uin == currentUin!)];
                              usernames = [];
                              usernames.add(tempUsername);

                              uins = [];
                              uins.add(currentUin!);
                            }

                            if(currentUsername != null && !usernames.contains(currentUsername)){
                              currentUsername = null;
                              usernameField.text = '';
                            } else if(currentUsername != null) {
                              var tempUin = uins[usernames.indexWhere((username) => username == currentUsername!)];
                              uins = [];
                              uins.add(tempUin);

                              usernames = [];
                              usernames.add(currentUsername!);
                            }

                            setState(() {
                              uinField.text;
                              usernameField.text;
                              admins;

                              uins;
                              displayUins = uins;

                              usernames;
                              displayUsernames = usernames;
                            });
                          }),
                    ]),

                const SizedBox(height: 5),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(
                          0xFFdedede), // changes color of the text
                      backgroundColor: const Color(
                          0xFF963e3e), // changes the color of the button
                    ),
                    onPressed: () {
                      user.viewedUser = '';
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ));
                    },
                    child: const Text('Create New Admin User')),
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
                          for (int i = 0; i < displayUins.length; i++)
                            Table(children: [
                              TableRow(children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(displayUins[i],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(displayUsernames[i],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      )),
                                ),
                                SizedBox(
                                  width: 25,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xFF500000)),
                                      // changes color of text
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xFFdedede)),
                                      // changes color of button
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
                                      user.viewedUser = displayUsernames[i];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            const ProfilePage(),
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
                          if (displayUins.isEmpty)
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'No Users Found',
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
