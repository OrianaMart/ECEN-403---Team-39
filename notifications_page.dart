import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'navigator_drawer.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

//Input for the UIN of the account being emailed
final uinField = TextEditingController();

String name = '';
String email = '';

final subjectController = TextEditingController();
final messageController = TextEditingController();

Future sendEmail() async {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  const serviceId = "service_1nvn0iw";
  const templateId = "template_aibuyle";
  const userID = '_eHi_zHyN4JO0d5a8';
  const accessToken = 'XcBCfW-cbWcRy2_eW64l_';
  final response = await http.post(url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "service_id": serviceId,
        "template_id": templateId,
        "user_id": userID,
        "accessToken": accessToken,
        "template_params": {
          "name": name,
          "subject": subjectController.text,
          "message": messageController.text,
          "user_email": email,
        }
      }));

  return response.body;
}

class NotificationsPageState extends State<NotificationsPage> {
  var usernames = List<String>.filled(0, '', growable: true);
  var uins = List<String>.filled(0, '', growable: true);

  String? currentUin;

  bool invalidUin = false;
  bool invalidSubject = false;
  bool invalidMessage = false;

  @override
  void initState() {
    super.initState();
    () async {
      usernames = await allStudentUsers();

      for (int i = 0; i < usernames.length; i++) {
        var temp = await getUserInfo(usernames[i]);
        uins.add(temp[1]);
      }

      setState(() {
        usernames;
        uins;

        subjectController.text = '';
        messageController.text = '';
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> uinEntries =
        <DropdownMenuEntry<String>>[];

    if (usernames.contains('No Student Users')) {
      uinEntries.add(DropdownMenuEntry(value: '', label: usernames[0]));
    } else {
      for (int i = 0; i < uins.length; i++) {
        uinEntries.add(DropdownMenuEntry(value: uins[i], label: uins[i]));
      }
    }

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
        backgroundColor: const Color(
            0xFF500000), //Sets background color of top bar to maroon
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

      //Navigation drawer code is called here
      drawer: const NavigatorDrawer(),

      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Notifications',
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
                    'Send email notification to a student',
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
                    errorText: invalidUin ? 'Select UIN' : null,
                    //Prevents the hint text from going away
                    inputDecorationTheme: const InputDecorationTheme(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                    ),
                    //makes the dropdown menu scrollable
                    menuHeight: 300,
                    //sets the entries to the dropdown menu
                    dropdownMenuEntries: uinEntries,
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
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.subject_rounded,
                      color: Color(0xFF500000),
                    ),
                    labelText: 'Subject',
                    errorText: invalidSubject ? 'Enter Subject' : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 9),
                  ),
                  style: const TextStyle(fontSize: 20),
                  maxLines: 1,
                  minLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.message,
                      color: Color(0xFF500000),
                    ),
                    labelText: 'Message',
                    errorText: invalidMessage ? 'Enter Message' : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 9),
                  ),
                  style: const TextStyle(fontSize: 20),
                  maxLines: 6,
                  minLines: 2,
                ),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF963e3e),
                  ),
                  onPressed: () async {
                    invalidUin = false;
                    invalidMessage = false;
                    invalidSubject = false;

                    if (subjectController.text == '') {
                      invalidSubject = true;
                    }
                    if (messageController.text == '') {
                      invalidMessage = true;
                    }

                    if (currentUin != null) {
                      var temp = await getUserInfo(usernames[
                          uins.indexWhere((uin) => uin == currentUin)]);

                      if (!invalidSubject && !invalidMessage) {
                        email = temp[4];
                        name = '${temp[2]} ${temp[3]}';

                        if (await sendEmail() == 'OK') {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ));
                        }
                      }
                    } else {
                      invalidUin = true;
                    }

                    setState(() {
                      invalidUin;
                      invalidSubject;
                      invalidMessage;
                    });
                  },
                  child: const Text(
                    "Send",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
