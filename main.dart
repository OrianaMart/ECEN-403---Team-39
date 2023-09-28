import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'equipment_page.dart';
import 'Data.dart' as user;
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

//Runs database test app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Database Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage()
    );
  }
}

//Creates the Login page for the test app
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}
class LoginPageState extends State<LoginPage> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  bool invalidUser = false;
  bool invalidPassword = false;
  @override
  Widget build(BuildContext context) {
    initializeDatabase();
    return Scaffold(
        appBar: AppBar(
            title: const Text('Login Page')
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: ListView(
                    children: [
                      const SizedBox(height: 15),
                      TextField(
                          controller: myController1,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Username',
                            errorText: invalidUser ? 'Invalid Username': null,
                          )
                      ),
                      const SizedBox(height: 15),
                      TextField(
                          controller: myController2,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Password',
                            errorText: invalidPassword ? 'Invalid Password': null,
                          )
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                          style: ButtonStyle(
                            //backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue.shade100),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),

                                  )
                              )
                          ),
                          onPressed: () async{
                            switch(await authenticate(myController1.text,myController2.text)){
                              case 'Valid Student': {
                                user.username = myController1.text;
                                setState(() {
                                  invalidUser = false;
                                  invalidPassword = false;
                                });

                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentLandingPage(username: myController1.text)
                                ));
                                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                              }
                              break;
                              case 'Valid Admin': {
                                user.username = myController1.text;
                                user.adminStatus = true;
                                setState(() {
                                  invalidUser = false;
                                  invalidPassword = false;
                                });
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminLandingPage(username: myController1.text)
                                ));
                              }
                              break;
                              case 'Invalid Username': {
                                setState(() {
                                  invalidUser = true;
                                  invalidPassword = false;
                                });
                              }
                              break;
                              case 'Invalid Password': {
                                setState(() {
                                  invalidUser = false;
                                  invalidPassword = true;
                                });
                              }
                              break;
                              case 'Failed Login': {
                                setState(() {
                                  invalidUser = true;
                                  invalidPassword = true;
                                });
                              }
                              break;
                            }
                          },
                          child: const Text('Login')
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                          style: ButtonStyle(
                            //backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue.shade100),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),

                                  )
                              )
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword()
                            ));
                          },
                          child: const Text('Forgot Password')
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                          style: ButtonStyle(
                            //backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue.shade100),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),

                                  )
                              )
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateStudentPage()
                            ));
                          },
                          child: const Text('Create New Student Account')
                      ),
                    ]
                )
            )
        )
    );
  }
}

//Creates the forgot password page for the test app
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);
  @override
  ForgotPasswordState createState() {
    return ForgotPasswordState();
  }
}
class ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController myController1 = TextEditingController();
  bool invalid = false;
  bool display = false;
  var response = List<String>.filled(1, '', growable: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Forgot Password')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(), labelText: 'Email Address',
                    errorText: invalid ? 'Invalid Email' : null,
                  ),
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    response = (await forgotPassword(myController1.text));
                    switch(response[0]) {
                      case 'Invalid Email': {
                        setState(() {
                          invalid = true;
                          display = false;
                        });
                      }
                      break;
                      case '':{}
                      break;
                      default:{
                        setState(() {
                          invalid = false;
                          display = true;
                        });
                      }
                    }
                  },
                  child: const Text('Submit')
              ),
              if(display)
                const SizedBox(height: 40),
              if(display)
                Text('${response[0]}, ${response[1]}',
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )
            ],
          ),
        ),
      ),
    );
  }
}

//creates the student account creation page
class CreateStudentPage extends StatefulWidget {
  const CreateStudentPage({Key? key}) : super(key: key);
  @override
  CreateStudentPageState createState() {
    return CreateStudentPageState();
  }
}
class CreateStudentPageState extends State<CreateStudentPage> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  final TextEditingController myController3 = TextEditingController();
  final TextEditingController myController4 = TextEditingController();
  final TextEditingController myController5 = TextEditingController();
  final TextEditingController myController6 = TextEditingController();
  final TextEditingController myController7 = TextEditingController();
  final TextEditingController myController8 = TextEditingController();
  final TextEditingController myController9 = TextEditingController();
  bool invalidUser = false;
  bool invalidEmail = false;
  bool invalidUIN = false;
  bool invalidPhone = false;
  bool invalidCourse = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Create Student Account')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Username',
                  errorText: invalidUser ? 'Invalid Username': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Password')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController3,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'UIN',
                  errorText: invalidUIN ? 'Invalid UIN': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController4,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'First Name')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController5,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Last Name')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController6,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Email',
                  errorText: invalidEmail ? 'Invalid Email': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController7,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Phone Number',
                  errorText: invalidPhone ? 'Invalid Phone Number': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController8,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Team Number')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController9,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Course Number',
                  errorText: invalidCourse ? 'Invalid Course Number': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    var response = await createStudentUser( myController1.text, myController2.text , int.parse(myController3.text),
                        myController4.text, myController5.text, myController6.text,
                        int.parse(myController7.text), int.parse(myController8.text), int.parse(myController9.text));
                    switch(response){
                      case 'Invalid Username': {
                        setState(() {
                          invalidUser = true;
                          invalidEmail = false;
                          invalidUIN = false;
                          invalidPhone = false;
                          invalidCourse = false;
                        });
                      }
                      break;

                      case 'Invalid Email': {
                        setState(() {
                          invalidUser = false;
                          invalidEmail = true;
                          invalidUIN = false;
                          invalidPhone = false;
                          invalidCourse = false;
                        });
                      }
                      break;

                      case 'Invalid UIN': {
                        setState(() {
                          invalidUser = false;
                          invalidEmail = false;
                          invalidUIN = true;
                          invalidPhone = false;
                          invalidCourse = false;
                        });
                      }
                      break;

                      case 'Invalid Phone Number': {
                        setState(() {
                          invalidUser = false;
                          invalidEmail = false;
                          invalidUIN = false;
                          invalidPhone = true;
                          invalidCourse = false;
                        });
                      }
                      break;

                      case 'Invalid Course Number': {
                        setState(() {
                          invalidUser = false;
                          invalidEmail = false;
                          invalidUIN = false;
                          invalidPhone = false;
                          invalidCourse = true;
                        });
                      }
                      break;

                      case 'Created': {
                        setState(() {
                          invalidUser = false;
                          invalidEmail = false;
                          invalidUIN = false;
                          invalidPhone = false;
                          invalidCourse = false;
                          Navigator.pop(context);
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Submit')
              ),

            ],
          ),
        ),
      ),
    );
  }
}

//creates the landing page for the students
class StudentLandingPage extends StatefulWidget {
  const StudentLandingPage({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  StudentLandingPageState createState() {
    return StudentLandingPageState();
  }
}
class StudentLandingPageState extends State<StudentLandingPage> {
  var requestIDs = List<String>.filled(0, '', growable: true);
  var requests = List<String>.filled(0, '', growable: true);
  var historyIDs = List<String>.filled(0, '', growable: true);
  var checkouts = List<String>.filled(0, '', growable: true);
  String name = '';

  @override
  void initState() {
    super.initState();

    () async {
      var temp = await getUserInfo(widget.username);
      name = temp[2];
      requestIDs = await findRequests(widget.username);
      if(requestIDs[0] == 'No Requests'){
        requests.add(requestIDs[0]);
      } else {
        for(int i = 0; i < requestIDs.length; i++){
          var temp = await getRequestInfo(requestIDs[i]);
          requests.add(temp[2]);
        }
      }

      historyIDs = await historyIDbyUser(widget.username);
      if(historyIDs[0] == 'No Checkout History'){
        checkouts.add(historyIDs[0]);
      } else {
        for(int i = 0; i < historyIDs.length; i++){
          var temp = await getHistoryInfo(historyIDs[i]);
          if(temp.length < 7) {
            checkouts.add(temp[2]);
          } else if(int.parse(temp[6]) < int.parse(temp[3])){
            checkouts.add(temp[2]);
          } else {
            historyIDs.removeAt(i);
            i--;
          }
        }
      }
      setState(() {
        requestIDs;
        requests;
        historyIDs;
        checkouts;
        name;
      });
    } ();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Welcome $name')
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text ('Home'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentLandingPage(username: widget.username)
                ));

              },
            ),
            ListTile(
              title: const Text ('Equipment'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EquipmentPage()
                ));
              },
            ),
            ListTile(
              title: const Text ('Forms'),
              onTap: () {

              },
            ),
            ListTile(
              title: const Text ('Profile'),
              onTap: () {

              },
            ),
            ListTile(
              title: const Text ('Logout'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()
                ));
              },
            ),
          ]
        )
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all()
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Requests:', style: TextStyle(fontSize: 20)),
                        ),
                        for(int i = 0; i < requests.length; i++)
                          TextButton(onPressed: () async {
                            var temp = await getRequestInfo(requestIDs[i]);
                            showDialog(
                              context: context,
                              builder: (context) =>
                            AlertDialog(
                              title: Text(requests[i]),
                              content: Table(children: [
                                TableRow(children: <Widget>[
                                  const Text('Request ID', textAlign: TextAlign.center),
                                  Text(temp[0], textAlign: TextAlign.center),
                                ]),
                                TableRow(children: <Widget>[
                                  const Text('Requested Amount', textAlign: TextAlign.center),
                                  Text(temp[3], textAlign: TextAlign.center),
                                ]),
                                TableRow(children: <Widget>[
                                  const Text('Timestamp', textAlign: TextAlign.center),
                                  Text(temp[4], textAlign: TextAlign.center),
                                ])
                              ]),
                              actions: [TextButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: const Text('Return')),
                                TextButton(onPressed: (){
                                  denyRequest(temp[0]);
                                  setState(() {
                                    requestIDs.removeAt(i);
                                    requests.removeAt(i);
                                    checkouts;
                                    historyIDs;
                                  });
                                  Navigator.pop(context);
                              }, child: const Text('Cancel Request'))],
                            )).then;

                            }, child: Text(requests[i])),
                      ]
                  )
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  style: ButtonStyle(
                      //backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue.shade100),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),

                          )
                      )
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateRequest(username: widget.username)
                    ));
                  },
                  child: const Text('New Equipment Request')
              ),
              const SizedBox(height: 15),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all()
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Active Checkouts:', style: TextStyle(fontSize: 20)),
                        ),
                        for(int i = 0; i < checkouts.length; i++)
                          TextButton(onPressed: () async {
                            var temp = await getHistoryInfo(historyIDs[i]);
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      title: Text(checkouts[i]),
                                      content: Table(children: [
                                        TableRow(children: <Widget>[
                                          Text('History ID', textAlign: TextAlign.center),
                                          Text(temp[0], textAlign: TextAlign.center),
                                        ]),
                                        TableRow(children: <Widget>[
                                          Text('Amount Out', textAlign: TextAlign.center),
                                          Text(temp[3], textAlign: TextAlign.center),
                                        ]),
                                        TableRow(children: <Widget>[
                                          Text('Admin Out', textAlign: TextAlign.center),
                                          Text(temp[4], textAlign: TextAlign.center),
                                        ]),
                                        TableRow(children: <Widget>[
                                          Text('Timestamp Out', textAlign: TextAlign.center),
                                          Text(temp[5], textAlign: TextAlign.center),
                                        ]),
                                        TableRow(children: <Widget>[
                                          Text('Amount In', textAlign: TextAlign.center),
                                          if(temp.length > 7)
                                            Text(temp[6], textAlign: TextAlign.center),
                                          if(temp.length < 7)
                                            Text('-', textAlign: TextAlign.center),
                                        ]),
                                        TableRow(children: <Widget>[
                                          Text('Admin In', textAlign: TextAlign.center),
                                          if(temp.length > 7)
                                            Text(temp[7], textAlign: TextAlign.center),
                                          if(temp.length < 7)
                                            Text('-', textAlign: TextAlign.center),
                                        ]),
                                        TableRow(children: <Widget>[
                                          Text('Timestamp In', textAlign: TextAlign.center),
                                          if(temp.length > 7)
                                            Text(temp[8], textAlign: TextAlign.center),
                                          if(temp.length < 7)
                                            Text('-', textAlign: TextAlign.center),
                                        ]),
                                      ]),
                                      actions: [TextButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: const Text('Return'))],
                                    )).then;

                          }, child: Text(checkouts[i])),
                      ]
                  )
              ),


              /*const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewForm(username: widget.username)
                    ));
                  },
                  child: const Text('New Forms')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentForms(username: widget.username)
                    ));
                  },
                  child: const Text('View Forms')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentRequests(username: widget.username)
                    ));
                  },
                  child: const Text('View Active Requests')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentPersonalInfo(username: widget.username)
                    ));
                  },
                  child: const Text('View Personal Information')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentHistory(username: widget.username)
                    ));
                  },
                  child: const Text('View Check Out Information')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewEquipmentStudent())
                    );
                  },
                  child: const Text('View Equipment')
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

//creates the test app page for generating new equipment requests
class GenerateRequest extends StatefulWidget {
  const GenerateRequest({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  GenerateRequestState createState() {
    return GenerateRequestState();
  }
}
class GenerateRequestState extends State<GenerateRequest> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  bool invalidForms = false;
  bool invalidAmount = false;
  bool invalidEquipment = false;
  bool invalidUsername = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Generate Equipment Request')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              if(invalidForms)
                TextField(
                    controller: myController1,
                    decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Equipment Name',
                        errorText: invalidForms ? 'Invalid Forms': null)
                ),
              if(invalidUsername)
                TextField(
                    controller: myController1,
                    decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Equipment Name',
                        errorText: invalidUsername ? 'Invalid Username': null)
                ),
              if(!invalidUsername && !invalidForms)
                TextField(
                    controller: myController1,
                    decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Equipment Name',
                        errorText: invalidEquipment ? 'Invalid Equipment': null)
                ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Requested Amount', 
                      errorText: invalidAmount ? 'Invalid Amount': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    var response = await generateNewRequest(widget.username, myController1.text, int.parse(myController2.text));
                    switch(response){
                      case 'Invalid Permissions': {
                        setState(() {
                          invalidForms = true;
                          invalidAmount = false;
                          invalidEquipment = false;
                          invalidUsername = false;
                        });
                      }
                      break;

                      case 'Invalid Amount': {
                        setState(() {
                          invalidForms = false;
                          invalidAmount = true;
                          invalidEquipment = false;
                          invalidUsername = false;
                        });
                      }
                      break;

                      case 'Invalid Equipment': {
                        setState(() {
                          invalidForms = false;
                          invalidAmount = false;
                          invalidEquipment = true;
                          invalidUsername = false;
                        });
                      }
                      break;
                      
                      case 'Invalid Username': {
                        setState(() {
                          invalidForms = false;
                          invalidAmount = false;
                          invalidEquipment = false;
                          invalidUsername = true;
                        });
                      }
                      break;

                      case 'Generated': {
                        setState(() {
                          invalidForms = false;
                          invalidAmount = false;
                          invalidEquipment = false;
                          invalidUsername = false;
                          Navigator.pop(context);
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Submit')
              ),

            ],
          ),
        ),
      ),
    );
  }
}

//the page for creating new forms
class NewForm extends StatefulWidget {
  const NewForm({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  NewFormState createState() {
    return NewFormState();
  }
}
class NewFormState extends State<NewForm> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  bool invalidUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('New Form')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Form Name',
                      errorText: invalidUser ? 'User Already Has This Form': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Form Information')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    switch(await newForm(myController1.text, widget.username, myController2.text)){
                      case 'User Already Has Form':{
                        setState(() {
                          invalidUser = true;
                        });
                      }
                      break;
                      case 'Form Created':{
                        setState(() {
                          invalidUser = false;
                          Navigator.pop(context);
                        });
                      }
                    }
                  },
                  child: const Text('Submit')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//the page for students to view forms
class StudentForms extends StatefulWidget {
  const StudentForms({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  StudentFormsState createState() {
    return StudentFormsState();
  }
}
class StudentFormsState extends State<StudentForms> {
  var formIDs = List<String>.filled(0, '', growable: true);
  var formInfo =List<String>.filled(0, '', growable: true);
  var formInfoList = List<List<String>>.filled(0, [], growable: true);

  @override
  void initState(){
    formInfoList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View Forms')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    formInfoList = [];
                    formIDs = [];
                    formIDs = await formIDbyUser(widget.username);
                    if(formIDs[0] == 'User Has No Forms'){
                      setState(() {
                        formInfoList = [];
                        formInfo = [];
                        formIDs = [];
                      });
                    } else {
                      for(int i = 0; i < formIDs.length; i++){
                        formInfo = await getFormInfo(formIDs[i]);
                        formInfoList.add(formInfo);
                      }
                      setState(() {
                        formInfoList;
                      });
                    }
                  },
                  child: const Text('Load Forms')
              ),
              const SizedBox(height: 15),

              Table(border: TableBorder.all(),children: const [
                TableRow(children: <Widget>[
                  Text('Username', textAlign: TextAlign.center),
                  Text('Form Name', textAlign: TextAlign.center),
                  Text('Form Info', textAlign: TextAlign.center),
                  Text('Verification', textAlign: TextAlign.center),
                ])
              ]),

              for(int i = 0; i < formInfoList.length; i++)
                Table(border: TableBorder.all(),children: [
                  TableRow(children: <Widget>[
                    Text(formInfoList[i][2], textAlign: TextAlign.center),
                    Text(formInfoList[i][1], textAlign: TextAlign.center),
                    Text(formInfoList[i][3], textAlign: TextAlign.center),
                    Text(formInfoList[i][4], textAlign: TextAlign.center),
                  ])
                ])
            ],
          ),
        ),
      ),
    );
  }
}

//the page for students to view their own requests
class StudentRequests extends StatefulWidget {
  const StudentRequests({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  StudentRequestsState createState() {
    return StudentRequestsState();
  }
}
class StudentRequestsState extends State<StudentRequests> {
  var requestIDs = List<String>.filled(0, '', growable: true);
  var requestInfo =List<String>.filled(0, '', growable: true);
  var requestInfoList = List<List<String>>.filled(0, [], growable: true);

  @override
  void initState(){
    requestInfoList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View Active Requests')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    requestInfoList = [];
                    requestIDs = [];
                    requestIDs = await findRequests(widget.username);
                    for(int i = 0; i < requestIDs.length; i++){
                      requestInfo = await getRequestInfo(requestIDs[i]);
                      requestInfoList.add(requestInfo);
                    }
                    switch (requestIDs[0]){
                      case 'No Requests':{
                        setState(() {
                          requestInfoList = [];
                          requestIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Load Requests')
              ),
              const SizedBox(height: 15),

              Table(border: TableBorder.all(),children: const [
                TableRow(children: <Widget>[
                  Text('Equipment Name', textAlign: TextAlign.center),
                  Text('Requested Amount', textAlign: TextAlign.center),
                  Text('Timestamp', textAlign: TextAlign.center),
                  Text('Action', textAlign: TextAlign.center)
                ])
              ]),

              for(int i = 0; i < requestInfoList.length; i++)
                Table(border: TableBorder.all(),children: [
                  TableRow(children: <Widget>[
                    Text(requestInfoList[i][2], textAlign: TextAlign.center),
                    Text(requestInfoList[i][3], textAlign: TextAlign.center),
                    Text(requestInfoList[i][4], textAlign: TextAlign.center),
                    TextButton(onPressed: () async {
                      await denyRequest(requestIDs[i]);
                      setState(() async {
                        requestInfoList = [];
                        requestIDs = [];
                        requestIDs = await findRequests(widget.username);
                        for(int i = 0; i < requestIDs.length; i++){
                          requestInfo = await getRequestInfo(requestIDs[i]);
                          requestInfoList.add(requestInfo);
                        }
                        switch (requestIDs[0]){
                          case 'No Requests':{
                            setState(() {
                              requestInfoList = [];
                              requestIDs = [];
                            });

                          }
                          break;

                          default:{
                            setState(() {
                            });
                          }
                          break;
                        }
                      });
                    }, child: const Text('Cancel'))
                  ])
                ])
            ],
          ),
        ),
      ),
    );
  }
}

//the page for students to view their own information
class StudentPersonalInfo extends StatefulWidget {
  const StudentPersonalInfo({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  StudentPersonalInfoState createState() {
    return StudentPersonalInfoState();
  }
}
class StudentPersonalInfoState extends State<StudentPersonalInfo> {
  var studentInfo = List<String>.filled(0, '', growable: true);

  @override
  void initState(){
    studentInfo = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View Personal Info')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    studentInfo =[];
                    studentInfo = await getUserInfo(widget.username);
                    setState(() {
                      studentInfo;
                    });
                  },
                  child: const Text('Load Information')
              ),
              const SizedBox(height: 15),

              Table(border: TableBorder.all(),children: const [
                TableRow(children: <Widget>[
                  Text('UIN', textAlign: TextAlign.center),
                  Text('First Name', textAlign: TextAlign.center),
                  Text('Last Name', textAlign: TextAlign.center),
                  Text('Email', textAlign: TextAlign.center),
                  Text('Phone Number', textAlign: TextAlign.center),
                  Text('Course Number', textAlign: TextAlign.center),
                  Text('Team Number', textAlign: TextAlign.center)
                ])
              ]),

              if(studentInfo.length > 1)
                Table(border: TableBorder.all(),children: [
                  TableRow(children: <Widget>[
                    Text(studentInfo[1], textAlign: TextAlign.center),
                    Text(studentInfo[2], textAlign: TextAlign.center),
                    Text(studentInfo[3], textAlign: TextAlign.center),
                    Text(studentInfo[4], textAlign: TextAlign.center),
                    Text(studentInfo[5], textAlign: TextAlign.center),
                    Text(studentInfo[6], textAlign: TextAlign.center),
                    Text(studentInfo[7], textAlign: TextAlign.center),
                  ])
                ]),
              const SizedBox(height: 15),
              if(studentInfo.length > 1)
                OutlinedButton(onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          EditStudent(username: studentInfo[0], uin: studentInfo[1], firstName: studentInfo[2],
                              lastName: studentInfo[3],email: studentInfo[4], phoneNumber: studentInfo[5],
                              courseNumber: studentInfo[6], teamNumber: studentInfo[7])
                      ));
                  }, child: const Text('Edit Information'))
            ],
          ),
        ),
      ),
    );
  }
}

class EditStudent extends StatefulWidget {
  const EditStudent({Key? key, required this.username,
    required this.uin, required this.firstName,required this.lastName,
    required this.email, required this.phoneNumber, required this.courseNumber,
    required this.teamNumber}) : super(key: key);
  final String username;
  final String uin;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String courseNumber;
  final String teamNumber;
  @override
  EditStudentState createState() {
    return EditStudentState();
  }
}
class EditStudentState extends State<EditStudent> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  final TextEditingController myController3 = TextEditingController();
  final TextEditingController myController4 = TextEditingController();
  bool invalidEmail = false;
  bool invalidPhone = false;
  bool invalidCourseNumber = false;

  @override
  void initState(){
    myController1.text = widget.email;
    myController2.text = widget.phoneNumber;
    myController3.text = widget.courseNumber;
    myController4.text = widget.teamNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit Personal Information')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Email Address',
                      errorText: invalidEmail ? 'Email Already In Use': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Phone Number',
                      errorText: invalidPhone ? 'Invalid Phone Number': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController3,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Course Number',
                      errorText: invalidCourseNumber ? 'Invalid Course Number': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController4,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Team Number')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    if(myController2.text.length != 10){
                      setState(() {
                        invalidEmail = false;
                        invalidPhone = true;
                        invalidCourseNumber = false;
                      });
                    } else {
                      if(int.parse(myController3.text) != 403 && int.parse(myController3.text) != 404){
                        setState(() {
                          invalidEmail = false;
                          invalidPhone = false;
                          invalidCourseNumber = true;
                        });
                      } else {
                        String response = await editUserAccount(widget.username, int.parse(widget.uin), widget.firstName,
                            widget.lastName, myController1.text, int.parse(myController2.text),
                            int.parse(myController4.text), int.parse(myController3.text));
                        switch(response){
                          case 'Invalid Email':{
                            setState(() {
                              invalidEmail = true;
                              invalidPhone = false;
                              invalidCourseNumber = false;
                            });
                          }
                          break;

                          case 'Updated': {
                            setState(() {
                              invalidEmail = false;
                              invalidPhone = false;
                              invalidCourseNumber = false;
                              Navigator.pop(context);
                            });
                          }
                          break;

                          default:{
                            setState(() {

                            });
                          }
                          break;
                        }
                      }
                    }
                  },
                  child: const Text('Submit')
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class StudentHistory extends StatefulWidget {
  const StudentHistory({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  StudentHistoryState createState() {
    return StudentHistoryState();
  }
}
class StudentHistoryState extends State<StudentHistory> {
  var historyIDs = List<String>.filled(0, '', growable: true);
  var historyInfo =List<String>.filled(0, '', growable: true);
  var historyInfoList = List<List<String>>.filled(0, [], growable: true);

  @override
  void initState(){
    historyInfoList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Checkout History')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    historyInfoList =[];
                    historyIDs = await historyIDbyUser(widget.username);
                    if(historyIDs[0] == 'No Checkout History'){
                      setState(() {
                        historyInfoList = [];
                      });
                    } else {
                      for (int i = 0; i < historyIDs.length; i++) {
                        historyInfo = await getHistoryInfo(historyIDs[i]);
                        historyInfoList.add(historyInfo);
                      }
                      setState(() {
                        historyInfoList;
                      });
                    }
                  },
                  child: const Text('Load Checkout Histories')
              ),
              const SizedBox(height: 15),
              Table(border: TableBorder.all(),children: const [
                TableRow(children: <Widget>[
                  Text('Equipment Name', textAlign: TextAlign.center),
                  Text('Amount Out', textAlign: TextAlign.center),
                  Text('Admin Out', textAlign: TextAlign.center),
                  Text('Timestamp Out', textAlign: TextAlign.center),
                  Text('Amount In', textAlign: TextAlign.center),
                  Text('Admin In', textAlign: TextAlign.center),
                  Text('Timestamp In', textAlign: TextAlign.center),
                ])
              ]),

              for(int i = 0; i < historyInfoList.length; i++)
                Table(border: TableBorder.all(),children: [
                  TableRow(children: <Widget>[
                    Text(historyInfoList[i][2], textAlign: TextAlign.center),
                    Text(historyInfoList[i][3], textAlign: TextAlign.center),
                    Text(historyInfoList[i][4], textAlign: TextAlign.center),
                    Text(historyInfoList[i][5], textAlign: TextAlign.center),
                    if(historyInfoList[i].length < 7)
                      const Text('-', textAlign: TextAlign.center),
                    if(historyInfoList[i].length < 7)
                      const Text('-', textAlign: TextAlign.center),
                    if(historyInfoList[i].length < 7)
                      const Text('-', textAlign: TextAlign.center),
                    if(historyInfoList[i].length > 7)
                      Text(historyInfoList[i][6], textAlign: TextAlign.center),
                    if(historyInfoList[i].length > 7)
                      Text(historyInfoList[i][7], textAlign: TextAlign.center),
                    if(historyInfoList[i].length > 7)
                      Text(historyInfoList[i][8], textAlign: TextAlign.center),

                  ])
                ]),
            ]
          ),
        ),
      )
    );
  }
}

class ViewEquipmentStudent extends StatefulWidget {
  const ViewEquipmentStudent({Key? key}) : super(key: key);
  @override
  ViewEquipmentStudentState createState() {
    return ViewEquipmentStudentState();
  }
}
class ViewEquipmentStudentState extends State<ViewEquipmentStudent> {
  final TextEditingController myController1 = TextEditingController();
  bool invalidEquipment = false;
  var equipmentIDs = List<String>.filled(0, '', growable: true);
  var equipmentInfo =List<String>.filled(0, '', growable: true);
  var equipmentInfoList = List<List<String>>.filled(0, [], growable: true);

  @override
  void initState(){
    equipmentInfoList = [];
    equipmentIDs = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View Equipment')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Equipment Name',
                      errorText: invalidEquipment ? 'Invalid Equipment Name': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    equipmentInfoList = [];
                    equipmentIDs = [];
                    equipmentIDs.add(myController1.text);
                    equipmentInfo = await getEquipmentInfo(equipmentIDs[0]);
                    equipmentInfoList.add(equipmentInfo);
                    if(myController1.text == ''){
                      equipmentInfo[0] = 'Invalid Equipment';
                    }
                    if(equipmentInfo[0] == 'Invalid Equipment'){
                      setState(() {
                        invalidEquipment = true;
                        equipmentInfoList = [];
                        equipmentInfo = [];
                        equipmentIDs = [];
                      });
                    } else {
                      setState(() {
                        invalidEquipment = false;
                      });
                    }
                  },
                  child: const Text('Search For Equipment')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    equipmentInfoList = [];
                    equipmentIDs = [];
                    equipmentInfo = [];
                    equipmentIDs = await allEquipment();
                    if(equipmentIDs[0] == 'No Equipment'){
                      setState(() {
                        invalidEquipment = false;
                        equipmentInfoList = [];
                        equipmentIDs = [];
                      });
                    } else {
                      for(int i = 0; i < equipmentIDs.length; i++){
                        equipmentInfo = await getEquipmentInfo(equipmentIDs[i]);
                        equipmentInfoList.add(equipmentInfo);
                      }
                      setState(() {
                        invalidEquipment = false;
                      });
                    }
                  },
                  child: const Text('Load All Equipment')
              ),
              const SizedBox(height: 15),

              Table(border: TableBorder.all(),children: const [
                TableRow(children: <Widget>[
                  Text('Equipment Name', textAlign: TextAlign.center),
                  Text('Category', textAlign: TextAlign.center),
                  Text('Storage Location', textAlign: TextAlign.center),
                  Text('Amount Available', textAlign: TextAlign.center),
                  Text('Total Amount', textAlign: TextAlign.center),
                  Text('Required Forms', textAlign: TextAlign.center),
                ])
              ]),

              for(int i = 0; i < equipmentInfoList.length; i++)
                Table(border: TableBorder.all(),children: [
                  TableRow(children: <Widget>[
                    Text(equipmentInfoList[i][0], textAlign: TextAlign.center),
                    Text(equipmentInfoList[i][1], textAlign: TextAlign.center),
                    Text(equipmentInfoList[i][2], textAlign: TextAlign.center),
                    Text(equipmentInfoList[i][3], textAlign: TextAlign.center),
                    Text(equipmentInfoList[i][4], textAlign: TextAlign.center),
                    Text(equipmentInfoList[i][5], textAlign: TextAlign.center),
                  ])
                ])
            ],
          ),
        ),
      ),
    );
  }
}

class AdminLandingPage extends StatelessWidget {
  const AdminLandingPage({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  Widget build(BuildContext context) {
    initializeDatabase();
    return Scaffold(
      appBar: AppBar(
          title: const Text('Admin Landing Page')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Requests(username: username)
                    ));
                  },
                  child: const Text('Approve/Deny Request')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckInPage(username: username)
                    ));
                  },
                  child: const Text('Equipment Check-In')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminForms()
                    ));
                  },
                  child: const Text('Verify Forms')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NewEquipment()
                    ));
                  },
                  child: const Text('Add New Equipment')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddForm()
                    ));
                  },
                  child: const Text('Add Form Requirements')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RemoveForm()
                    ));
                  },
                  child: const Text('Remove Form Requirements')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewInfoPage(username: username)
                    ));
                  },
                  child: const Text('View/Edit Information')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAdminPage()
                    ));
                  },
                  child: const Text('Create New Admin User')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage()
                    ));
                  },
                  child: const Text('Notifications')
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class Requests extends StatefulWidget {
  const Requests({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  RequestsState createState() {
    return RequestsState();
  }
}
class RequestsState extends State<Requests> {
  final TextEditingController myController1 = TextEditingController();
  bool invalidUser = false;
  var requestIDs = List<String>.filled(0, '', growable: true);
  var requestInfo =List<String>.filled(0, '', growable: true);
  var requestInfoList = List<List<String>>.filled(0, [], growable: true);

  @override
  void initState(){
    invalidUser = false;
    requestInfoList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Request Approval')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Username',
                      errorText: invalidUser ? 'No Requests For This User': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    requestInfoList = [];
                    requestIDs = [];
                    requestIDs = await findRequests(myController1.text);
                    for(int i = 0; i < requestIDs.length; i++){
                      requestInfo = await getRequestInfo(requestIDs[i]);
                      requestInfoList.add(requestInfo);
                    }
                    switch (requestIDs[0]){
                      case 'No Requests':{
                        setState(() {
                          invalidUser = true;
                          requestInfoList = [];
                          requestIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Find Requests by User')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    requestInfoList = [];
                    requestIDs = [];
                    requestIDs = await allRequestIDs();
                    for(int i = 0; i < requestIDs.length; i++){
                      requestInfo = await getRequestInfo(requestIDs[i]);
                      requestInfoList.add(requestInfo);
                    }
                    switch (requestIDs[0]){
                      case 'No Requests':{
                        setState(() {
                          requestInfoList = [];
                          requestIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                        });
                      }
                    }
                  },
                  child: const Text('View All Requests')
              ),
              const SizedBox(height: 15),

              Table(border: TableBorder.all(),children: const [
                TableRow(children: <Widget>[
                  Text('Username', textAlign: TextAlign.center),
                  Text('Equipment Name', textAlign: TextAlign.center),
                  Text('Requested Amount', textAlign: TextAlign.center),
                  Text('Timestamp', textAlign: TextAlign.center),
                ])
              ]),

              for(int i = 0; i < requestInfoList.length; i++)
                Table(border: TableBorder.all(),children: [
                  TableRow(children: <Widget>[
                    TextButton(onPressed: () {
                      setState(() {
                        requestInfoList = [];
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ApproveRequests(requestID: requestIDs[i], username: widget.username)
                      ));
                    },
                        child: Text(requestInfoList[i][1], textAlign: TextAlign.center)),
                    Text(requestInfoList[i][2], textAlign: TextAlign.center),
                    Text(requestInfoList[i][3], textAlign: TextAlign.center),
                    Text(requestInfoList[i][4], textAlign: TextAlign.center),
                  ])
                ])
            ],
          ),
        ),
      ),
    );
  }
}

class ApproveRequests extends StatefulWidget {
  const ApproveRequests({Key? key, required this.username, required this.requestID}) : super(key: key);
  final String username;
  final String requestID;
  @override
  ApproveRequestsState createState() {
    return ApproveRequestsState();
  }
}
class ApproveRequestsState extends State<ApproveRequests> {
  final TextEditingController myController1 = TextEditingController();
  bool invalidUIN = false;
  var requestInfo = List<String>.filled(0, '', growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Request Approval')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Enter UIN',
                      errorText: invalidUIN ? 'Incorrect UIN': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    String approval = await approveRequest(widget.requestID, int.parse(myController1.text), widget.username);
                    switch (approval){
                      case 'Invalid UIN':{
                        setState(() {
                          invalidUIN = true;
                        });
                      }
                      break;

                      case 'Approved':{
                        setState(() {
                          invalidUIN = false;
                          Navigator.pop(context);
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Approve')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    String denial = await denyRequest(widget.requestID);
                    if(denial == 'Denied'){
                      setState(() {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text('Deny')
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class CheckInPage extends StatefulWidget {
  const CheckInPage({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  CheckInPageState createState() {
    return CheckInPageState();
  }
}
class CheckInPageState extends State<CheckInPage> {
  final TextEditingController myController1 = TextEditingController();
  bool invalidEquipment = false;
  var historyIDs = List<String>.filled(0, '', growable: true);
  var historyInfo =List<String>.filled(0, '', growable: true);
  var historyInfoList = List<List<String>>.filled(0, [], growable: true);

  @override
  void initState(){
    historyInfoList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Check-In Approval')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Equipment Name',
                      errorText: invalidEquipment ? 'No Check-In Available For This Equipment': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    historyInfoList = [];
                    historyIDs = await historyIDbyEquipment(myController1.text);
                    if(historyIDs[0] == 'No Checkout History'){
                      setState(() {
                        invalidEquipment = true;
                      });
                    } else {
                      for (int i = 0; i < historyIDs.length; i++) {
                        historyInfo = await getHistoryInfo(historyIDs[i]);
                        if (historyInfo.length > 7) {
                          if (int.parse(historyInfo[3]) - int.parse(historyInfo[6]) > 0) {
                            historyInfoList.add(historyInfo);
                            setState(() {
                              invalidEquipment = false;
                              historyInfoList;
                            });
                          } else {
                            setState(() {
                              invalidEquipment = true;
                            });
                          }
                        } else {
                          historyInfoList.add(historyInfo);
                          setState(() {
                            invalidEquipment = false;
                            historyInfoList;
                          });
                        }
                      }
                    }
                  },
                  child: const Text('Find Checkout')
              ),
              const SizedBox(height: 15),

              Table(border: TableBorder.all(),children: const [
                TableRow(children: <Widget>[
                  Text('Username', textAlign: TextAlign.center),
                  Text('Equipment Name', textAlign: TextAlign.center),
                  Text('Out Amount', textAlign: TextAlign.center),
                  Text('Out Admin', textAlign: TextAlign.center),
                  Text('Out Timestamp', textAlign: TextAlign.center),
                  Text('In Amount', textAlign: TextAlign.center),
                  Text('In Admin', textAlign: TextAlign.center),
                  Text('In Timestamp', textAlign: TextAlign.center),
                ])
              ]),

              for(int i = 0; i < historyInfoList.length; i++)
                Table(border: TableBorder.all(),children: [
                  TableRow(children: <Widget>[
                    TextButton(onPressed: () {
                      setState(() {
                        historyInfoList = [];
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CheckIn(historyID: historyIDs[i], username: widget.username)
                      ));
                    },
                        child: Text(historyInfoList[i][1], textAlign: TextAlign.center)),
                    Text(historyInfoList[i][2], textAlign: TextAlign.center),
                    Text(historyInfoList[i][3], textAlign: TextAlign.center),
                    Text(historyInfoList[i][4], textAlign: TextAlign.center),
                    Text(historyInfoList[i][5], textAlign: TextAlign.center),
                    if(historyInfoList[i].length < 7)
                      const Text('-', textAlign: TextAlign.center),
                    if(historyInfoList[i].length < 7)
                      const Text('-', textAlign: TextAlign.center),
                    if(historyInfoList[i].length < 7)
                      const Text('-', textAlign: TextAlign.center),
                    if(historyInfoList[i].length > 7)
                      Text(historyInfoList[i][6], textAlign: TextAlign.center),
                    if(historyInfoList[i].length > 7)
                      Text(historyInfoList[i][7], textAlign: TextAlign.center),
                    if(historyInfoList[i].length > 7)
                      Text(historyInfoList[i][8], textAlign: TextAlign.center),

                  ])
                ]),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckIn extends StatefulWidget {
  const CheckIn({Key? key, required this.username, required this.historyID}) : super(key: key);
  final String username;
  final String historyID;
  @override
  CheckInState createState() {
    return CheckInState();
  }
}
class CheckInState extends State<CheckIn> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  bool invalidUIN = false;
  bool invalidAmount = false;
  var requestInfo = List<String>.filled(0, '', growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Request Approval')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Enter UIN',
                      errorText: invalidUIN ? 'Incorrect UIN': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Enter Check-In Amount',
                      errorText: invalidAmount ? 'Invalid Amount': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    String verify = await verifyCheckIn(widget.historyID, int.parse(myController1.text), int.parse(myController2.text), widget.username);
                    switch (verify){
                      case 'Invalid UIN':{
                        setState(() {
                          invalidUIN = true;
                          invalidAmount = false;
                        });
                      }
                      break;

                      case 'Invalid Amount':{
                        setState(() {
                          invalidUIN = false;
                          invalidAmount = true;
                        });
                      }
                      break;

                      case 'Checked In':{
                        setState(() {
                          invalidUIN = false;
                          invalidAmount = false;
                          Navigator.pop(context);
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Verify')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminForms extends StatefulWidget {
  const AdminForms({Key? key}) : super(key: key);
  @override
  AdminFormsState createState() {
    return AdminFormsState();
  }
}
class AdminFormsState extends State<AdminForms> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  final TextEditingController myController3 = TextEditingController();
  bool invalidUser = false;
  bool invalidEquipment = false;
  bool invalidForm = false;
  var formIDs = List<String>.filled(0, '', growable: true);
  var formInfo =List<String>.filled(0, '', growable: true);
  var formInfoList = List<List<String>>.filled(0, [], growable: true);

  @override
  void initState(){
    formInfoList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Verify Forms')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Username',
                      errorText: invalidUser ? 'User Has No Forms': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Equipment Name',
                      errorText: invalidEquipment ? 'Equipment Has No Forms': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController3,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Form Name',
                      errorText: invalidForm ? 'Equipment Has No Forms': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    formInfoList = [];
                    formIDs = [];
                    formIDs = await formIDbyUser(myController1.text);
                    for(int i = 0; i < formIDs.length; i++){
                      formInfo = await getFormInfo(formIDs[i]);
                      formInfoList.add(formInfo);
                    }
                    switch (formIDs[0]){
                      case 'User Has No Forms':{
                        setState(() {
                          invalidUser = true;
                          invalidEquipment = false;
                          invalidForm = false;
                          formInfoList = [];
                          formIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                          invalidForm = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Search By User')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    formInfoList = [];
                    formIDs = [];
                    formIDs = await formIDbyEquipment(myController2.text);
                    for(int i = 0; i < formIDs.length; i++){
                      formInfo = await getFormInfo(formIDs[i]);
                      formInfoList.add(formInfo);
                    }
                    switch (formIDs[0]){
                      case 'Equipment Has No Forms':{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = true;
                          invalidForm = false;
                          formInfoList = [];
                          formIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                          invalidForm = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Search By Equipment')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    formInfoList = [];
                    formIDs = [];
                    formIDs = await formIDbyName(myController3.text);
                    for(int i = 0; i < formIDs.length; i++){
                      formInfo = await getFormInfo(formIDs[i]);
                      formInfoList.add(formInfo);
                    }
                    switch (formIDs[0]){
                      case 'No Forms With This Name':{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                          invalidForm = true;
                          formInfoList = [];
                          formIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                          invalidForm = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Search By Form Name')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    formInfoList = [];
                    formIDs = [];
                    formIDs = await allFormIDs();
                    for(int i = 0; i < formIDs.length; i++){
                      formInfo = await getFormInfo(formIDs[i]);
                      formInfoList.add(formInfo);
                    }
                    switch (formIDs[0]){
                      case 'No Forms':{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                          invalidForm = false;
                          formInfoList = [];
                          formIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                          invalidForm = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Load All Forms')
              ),
              const SizedBox(height: 15),

              Table(border: TableBorder.all(),children: const [
                TableRow(children: <Widget>[
                  Text('Username', textAlign: TextAlign.center),
                  Text('Form Name', textAlign: TextAlign.center),
                  Text('Form Info', textAlign: TextAlign.center),
                  Text('Verification', textAlign: TextAlign.center),
                ])
              ]),

              for(int i = 0; i < formInfoList.length; i++)
                Table(border: TableBorder.all(),children: [
                  TableRow(children: <Widget>[
                    Text(formInfoList[i][2], textAlign: TextAlign.center),
                    Text(formInfoList[i][1], textAlign: TextAlign.center),
                    Text(formInfoList[i][3], textAlign: TextAlign.center),
                    if(formInfoList[i][4] == 'false')
                      TextButton(onPressed: () async {
                        String result = await verifyForm(
                            formInfoList[i][2], formInfoList[i][1]);
                        if (result == 'Verified') {
                          setState(() {
                            invalidUser = false;
                            invalidEquipment = false;
                            formInfoList = [];
                          });
                        }
                      }, child: Text(formInfoList[i][4],
                          textAlign: TextAlign.center)),
                    if(formInfoList[i][4] == 'true')
                      Text(formInfoList[i][4], textAlign: TextAlign.center)
                  ])
                ])
            ],
          ),
        ),
      ),
    );
  }
}

class NewEquipment extends StatefulWidget {
  const NewEquipment({Key? key}) : super(key: key);
  @override
  NewEquipmentState createState() {
    return NewEquipmentState();
  }
}
class NewEquipmentState extends State<NewEquipment> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  final TextEditingController myController3 = TextEditingController();
  final TextEditingController myController4 = TextEditingController();
  bool invalidName = false;
  bool invalidAmount = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Generate New Equipment')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Equipment Name',
                      errorText: invalidName ? 'Equipment Already Exists': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Amount',
                      errorText: invalidAmount ? 'Invalid Amount': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController3,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Equipment Category')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController4,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Storage Location')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    var response = await newEquipment(myController1.text, int.parse(myController2.text), myController3.text, myController4.text);
                    switch(response){
                      case 'Creation Failed': {
                        setState(() {
                          invalidName = true;
                          invalidAmount = false;
                        });
                      }
                      break;

                      case 'Invalid Amount': {
                        setState(() {
                          invalidName = false;
                          invalidAmount = true;
                        });
                      }
                      break;

                      case 'Created': {
                        setState(() {
                          invalidName = false;
                          invalidAmount = false;
                          Navigator.pop(context);
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Submit')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddForm extends StatefulWidget {
  const AddForm({Key? key}) : super(key: key);
  @override
  AddFormState createState() {
    return AddFormState();
  }
}
class AddFormState extends State<AddForm> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  bool invalidName = false;
  bool invalidEquipment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Add Form Requirement')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Enter Form Name',
                      errorText: invalidName ? 'Equipment Already Requires This Form': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Enter Equipment',
                      errorText: invalidEquipment ? 'Invalid Equipment': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    var response = await addFormRequirement(myController1.text, myController2.text);
                    switch(response){
                      case 'Form Already Required': {
                        setState(() {
                          invalidName = true;
                          invalidEquipment = false;
                        });
                      }
                      break;

                      case 'Invalid Equipment': {
                        setState(() {
                          invalidName = false;
                          invalidEquipment = true;
                        });
                      }
                      break;

                      case 'Form Required': {
                        setState(() {
                          invalidName = false;
                          invalidEquipment = false;
                          Navigator.pop(context);
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Submit')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RemoveForm extends StatefulWidget {
  const RemoveForm({Key? key}) : super(key: key);
  @override
  RemoveFormState createState() {
    return RemoveFormState();
  }
}
class RemoveFormState extends State<RemoveForm> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  bool invalidName = false;
  bool invalidEquipment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Remove Form Requirement')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Enter Form Name',
                      errorText: invalidName ? 'Equipment Does not Require This Form': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Enter Equipment',
                      errorText: invalidEquipment ? 'Invalid Equipment': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    var response = await removeFormRequirement(myController1.text, myController2.text);
                    switch(response){
                      case 'Form Not Required': {
                        setState(() {
                          invalidName = true;
                          invalidEquipment = false;
                        });
                      }
                      break;

                      case 'Invalid Equipment': {
                        setState(() {
                          invalidName = false;
                          invalidEquipment = true;
                        });
                      }
                      break;

                      case 'Form Removed': {
                        setState(() {
                          invalidName = false;
                          invalidEquipment = false;
                          Navigator.pop(context);
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Submit')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewInfoPage extends StatelessWidget {
  const ViewInfoPage({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  Widget build(BuildContext context) {
    initializeDatabase();
    return Scaffold(
      appBar: AppBar(
          title: const Text('Select Information')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewUsers()
                    ));
                  },
                  child: const Text('User Accounts')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EquipmentPage()
                    ));
                  },
                  child: const Text('Equipment')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewForms()
                    ));
                  },
                  child: const Text('Forms')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewRequests()
                    ));
                  },
                  child: const Text('Requests')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewHistory()
                    ));
                  },
                  child: const Text('Checkout History')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewUsers extends StatefulWidget {
  const ViewUsers({Key? key}) : super(key: key);
  @override
  ViewUsersState createState() {
    return ViewUsersState();
  }
}
class ViewUsersState extends State<ViewUsers> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  bool invalidUser = false;
  bool invalidUIN = false;
  var userIDs = List<String>.filled(0, '', growable: true);
  var userInfo =List<String>.filled(0, '', growable: true);
  var userInfoList = List<List<String>>.filled(0, [], growable: true);

  @override
  void initState(){
    userInfoList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View/Edit User Accounts')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Username',
                      errorText: invalidUser ? 'Invalid Username': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'UIN',
                      errorText: invalidUIN ? 'Invalid UIN': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    userInfoList = [];
                    userIDs = [];
                    userInfo = [];
                    userIDs.add(myController1.text);
                    userInfo = await getUserInfo(userIDs[0]);
                    if(userInfo[0] == 'Invalid Username'){
                      setState(() {
                        invalidUIN = false;
                        invalidUser = true;
                        userInfo = [];
                        userIDs = [];
                      });
                    } else {
                      userInfoList.add(userInfo);
                      setState(() {
                        invalidUIN = false;
                        invalidUser = false;
                      });
                    }
                  },
                  child: const Text('Search By Username')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    userInfoList = [];
                    userIDs = [];
                    userInfo = [];
                    if(double.tryParse(myController2.text) != null) {
                      userIDs.add(
                          await userByUIN(int.parse(myController2.text)));
                      userInfo = await getUserInfo(userIDs[0]);
                      userInfoList.add(userInfo);
                      if (userIDs[0] == 'Invalid UIN') {
                        setState(() {
                          invalidUIN = true;
                          invalidUser = false;
                          userInfoList = [];
                          userInfo = [];
                          userIDs = [];
                        });
                      } else {
                        setState(() {
                          invalidUIN = false;
                          invalidUser = false;
                        });
                      }
                    } else {
                      setState(() {
                        invalidUIN = true;
                        invalidUser = false;
                        userInfoList = [];
                        userInfo = [];
                        userIDs = [];
                      });
                    }
                  },
                  child: const Text('Search By UIN')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    userInfoList = [];
                    userIDs = [];
                    userIDs = await allStudentUsers();
                    for(int i = 0; i < userIDs.length; i++){
                      userInfo = await getUserInfo(userIDs[i]);
                      userInfoList.add(userInfo);
                    }
                    switch (userIDs[0]){
                      case 'No Student Users':{
                        setState(() {
                          invalidUser = false;
                          userInfoList = [];
                          userIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Load All Students')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    userInfoList = [];
                    userIDs = [];
                    userIDs = await allAdminUsers();
                    for(int i = 0; i < userIDs.length; i++){
                      userInfo = await getUserInfo(userIDs[i]);
                      userInfoList.add(userInfo);
                    }
                    switch (userIDs[0]){
                      case 'No Student Users':{
                        setState(() {
                          invalidUser = false;
                          userInfoList = [];
                          userIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Load All Admins')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    userInfoList = [];
                    userIDs = [];
                    userIDs = await allStudentUsers();
                    var tempUserIDs = await allAdminUsers();
                    userIDs = userIDs + tempUserIDs;
                    for(int i = 0; i < userIDs.length; i++){
                      userInfo = await getUserInfo(userIDs[i]);
                      userInfoList.add(userInfo);
                    }
                    switch (userIDs[0]) {
                      case 'No Student Users':
                        {
                          setState(() {
                            invalidUser = false;
                            userInfoList = [];
                            userIDs = [];
                          });
                        }
                        break;

                      case 'No Admin Users':
                        {
                          setState(() {
                            invalidUser = false;
                            userInfoList = [];
                            userIDs = [];
                          });
                        }
                        break;

                      default:
                        {
                          setState(() {
                            invalidUser = false;
                          });
                        }
                        break;
                    }},
                  child: const Text('Load All Accounts')
              ),
              const SizedBox(height: 15),

              Table(border: TableBorder.all(),children: const [
                TableRow(children: <Widget>[
                  Text('Username', textAlign: TextAlign.center),
                  Text('UIN', textAlign: TextAlign.center),
                  Text('First Name', textAlign: TextAlign.center),
                  Text('Last Name', textAlign: TextAlign.center),
                  Text('Email', textAlign: TextAlign.center),
                  Text('Phone Number', textAlign: TextAlign.center),
                  Text('Course Number', textAlign: TextAlign.center),
                  Text('Team Number', textAlign: TextAlign.center),
                ])
              ]),

              for(int i = 0; i < userInfoList.length; i++)
                Table(border: TableBorder.all(),children: [
                  TableRow(children: <Widget>[
                    if(userInfo.length > 1)
                      TextButton(onPressed: () {
                        bool adminStatus = false;
                        if(userInfoList[i][7] == 'null'){
                          adminStatus = true;
                          userInfoList[i].add('0');
                          userInfoList[i].add('403');
                        }
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                EditAdmin(username: userInfoList[i][0], uin: userInfoList[i][1], firstName: userInfoList[i][2],
                                    lastName: userInfoList[i][3],email: userInfoList[i][4], phoneNumber: userInfoList[i][5],
                                    courseNumber: userInfoList[i][6], teamNumber: userInfoList[i][7], adminStatus: adminStatus)
                            ));
                      }, child: Text(userInfoList[i][0], textAlign: TextAlign.center)),
                    Text(userInfoList[i][1], textAlign: TextAlign.center),
                    Text(userInfoList[i][2], textAlign: TextAlign.center),
                    Text(userInfoList[i][3], textAlign: TextAlign.center),
                    Text(userInfoList[i][4], textAlign: TextAlign.center),
                    Text(userInfoList[i][5], textAlign: TextAlign.center),
                    Text(userInfoList[i][6], textAlign: TextAlign.center),
                    Text(userInfoList[i][7], textAlign: TextAlign.center),
                  ])
                ])
            ],
          ),
        ),
      ),
    );
  }
}

class EditAdmin extends StatefulWidget {
  const EditAdmin({Key? key, required this.username,
    required this.uin, required this.firstName,required this.lastName,
    required this.email, required this.phoneNumber, required this.courseNumber,
    required this.teamNumber, required this.adminStatus}) : super(key: key);
  final String username;
  final String uin;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String courseNumber;
  final String teamNumber;
  final bool adminStatus;
  @override
  EditAdminState createState() {
    return EditAdminState();
  }
}
class EditAdminState extends State<EditAdmin> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  final TextEditingController myController3 = TextEditingController();
  final TextEditingController myController4 = TextEditingController();
  final TextEditingController myController5 = TextEditingController();
  final TextEditingController myController6 = TextEditingController();
  final TextEditingController myController7 = TextEditingController();
  bool invalidUIN = false;
  bool invalidEmail = false;
  bool invalidPhone = false;
  bool invalidCourseNumber = false;

  @override
  void initState(){
    myController1.text = widget.uin;
    myController2.text = widget.firstName;
    myController3.text = widget.lastName;
    myController4.text = widget.email;
    myController5.text = widget.phoneNumber;
    myController6.text = widget.courseNumber;
    myController7.text = widget.teamNumber;
    if(widget.adminStatus){
      myController6.text = 403.toString();
      myController7.text = 0.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit User Information')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'UIN',
                      errorText: invalidUIN ? 'UIN Already In Use': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'First Name')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController3,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Last Name')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController4,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Email Address',
                      errorText: invalidEmail ? 'Email Already In Use': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController5,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Phone Number',
                      errorText: invalidPhone ? 'Invalid Phone Number': null)
              ),
              if(widget.adminStatus == false)
                const SizedBox(height: 15),
              if(widget.adminStatus == false)
                TextField(
                    controller: myController6,
                    decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Course Number',
                        errorText: invalidCourseNumber ? 'Invalid Course Number': null)
                ),
              if(widget.adminStatus == false)
                const SizedBox(height: 15),
              if(widget.adminStatus == false)
                TextField(
                    controller: myController7,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Team Number')
                ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    if(myController5.text.length != 10){
                      setState(() {
                        invalidEmail = false;
                        invalidPhone = true;
                        invalidCourseNumber = false;
                      });
                    } else {
                      if(int.parse(myController6.text) != 403 && int.parse(myController6.text) != 404){
                        setState(() {
                          invalidEmail = false;
                          invalidPhone = false;
                          invalidCourseNumber = true;
                        });
                      } else {
                        String response = await editUserAccount(widget.username, int.parse(myController1.text), myController2.text,
                            myController3.text, myController4.text, int.parse(myController5.text),
                            int.parse(myController7.text), int.parse(myController6.text));
                        switch(response){
                          case 'Invalid Email':{
                            setState(() {
                              invalidEmail = true;
                              invalidPhone = false;
                              invalidCourseNumber = false;
                            });
                          }
                          break;

                          case 'Updated': {
                            setState(() {
                              invalidEmail = false;
                              invalidPhone = false;
                              invalidCourseNumber = false;
                              Navigator.pop(context);
                            });
                          }
                          break;

                          default:{
                            setState(() {

                            });
                          }
                          break;
                        }
                      }
                    }
                  },
                  child: const Text('Submit')
              ),
              OutlinedButton(onPressed: () async {
                var response = await removeUser(widget.username);
                if(response == 'Removed'){
                  setState(() {
                    invalidEmail = false;
                    invalidPhone = false;
                    invalidCourseNumber = false;
                    Navigator.pop(context);
                  });
                }
              }, child: const Text('Remove User'))

            ],
          ),
        ),
      ),
    );
  }
}

class ViewEquipment extends StatefulWidget {
  const ViewEquipment({Key? key}) : super(key: key);
  @override
  ViewEquipmentState createState() {
    return ViewEquipmentState();
  }
}
class ViewEquipmentState extends State<ViewEquipment> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  final TextEditingController myController3 = TextEditingController();
  bool invalidEquipment = false;
  bool invalidCategory = false;
  bool invalidLocation = false;
  var equipmentIDs = List<String>.filled(0, '', growable: true);
  var equipmentInfo =List<String>.filled(0, '', growable: true);
  var equipmentInfoList = List<List<String>>.filled(0, [], growable: true);

  @override
  void initState(){
    equipmentInfoList = [];
    equipmentIDs = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View/Edit Equipment')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Equipment Name',
                      errorText: invalidEquipment ? 'Invalid Equipment Name': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Category',
                      errorText: invalidCategory ? 'Invalid Category': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController3,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Storage Location',
                      errorText: invalidLocation ? 'Invalid Storage Location': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    equipmentInfoList = [];
                    equipmentIDs = [];
                    equipmentIDs.add(myController1.text);
                    equipmentInfo = await getEquipmentInfo(equipmentIDs[0]);
                    equipmentInfoList.add(equipmentInfo);
                    if(myController1.text == ''){
                      equipmentInfo[0] = 'Invalid Equipment';
                    }
                    if(equipmentInfo[0] == 'Invalid Equipment'){
                      setState(() {
                        invalidEquipment = true;
                        invalidCategory = false;
                        invalidLocation = false;
                        equipmentInfoList = [];
                        equipmentInfo = [];
                        equipmentIDs = [];
                      });
                    } else {
                      setState(() {
                        invalidEquipment = false;
                        invalidCategory = false;
                        invalidLocation = false;
                      });
                    }
                  },
                  child: const Text('Search By Equipment Name')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    equipmentInfoList = [];

                    if(myController2.text == ''){
                      equipmentIDs.add('Invalid Category');
                    } else {
                      equipmentIDs = await equipmentByCategory(myController2.text);
                    }

                    if(equipmentIDs[0] == 'Invalid Category'){
                      setState(() {
                        invalidEquipment = false;
                        invalidCategory = true;
                        invalidLocation = false;
                        equipmentInfoList = [];
                        equipmentInfo = [];
                        equipmentIDs = [];
                      });
                    } else {
                      for(int i = 0; i < equipmentIDs.length; i++){
                        equipmentInfo = await getEquipmentInfo(equipmentIDs[i]);
                        equipmentInfoList.add(equipmentInfo);
                      }
                      setState(() {
                        invalidEquipment = false;
                        invalidCategory = false;
                        invalidLocation = false;
                      });
                    }
                  },
                  child: const Text('Search By Category')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    equipmentInfoList = [];

                    if(myController2.text == ''){
                      equipmentIDs.add('Invalid Location');
                    } else {
                      equipmentIDs = await equipmentByLocation(myController3.text);
                    }

                    if(equipmentIDs[0] == 'Invalid Location'){
                      setState(() {
                        invalidEquipment = false;
                        invalidCategory = false;
                        invalidLocation = true;
                        equipmentInfoList = [];
                        equipmentInfo = [];
                        equipmentIDs = [];
                      });
                    } else {
                      for(int i = 0; i < equipmentIDs.length; i++){
                        equipmentInfo = await getEquipmentInfo(equipmentIDs[i]);
                        equipmentInfoList.add(equipmentInfo);
                      }
                      setState(() {
                        invalidEquipment = false;
                        invalidCategory = false;
                        invalidLocation = false;
                      });
                    }
                  },
                  child: const Text('Search By Location')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    equipmentInfoList = [];
                    equipmentIDs = [];
                    equipmentInfo = [];
                    equipmentIDs = await allEquipment();
                    if(equipmentIDs[0] == 'No Equipment'){
                      setState(() {
                        invalidEquipment = false;
                        invalidCategory = false;
                        invalidLocation = false;
                        equipmentInfoList = [];
                        equipmentIDs = [];
                      });
                    } else {
                      for(int i = 0; i < equipmentIDs.length; i++){
                        equipmentInfo = await getEquipmentInfo(equipmentIDs[i]);
                        equipmentInfoList.add(equipmentInfo);
                      }
                      setState(() {
                        invalidEquipment = false;
                        invalidCategory = false;
                        invalidLocation = false;
                      });
                    }
                  },
                  child: const Text('Load All Equipment')
              ),
              const SizedBox(height: 15),

              Table(border: TableBorder.all(),children: const [
                TableRow(children: <Widget>[
                  Text('Equipment Name', textAlign: TextAlign.center),
                  Text('Category', textAlign: TextAlign.center),
                  Text('Storage Location', textAlign: TextAlign.center),
                  Text('Amount Available', textAlign: TextAlign.center),
                  Text('Total Amount', textAlign: TextAlign.center),
                  Text('Required Forms', textAlign: TextAlign.center),
                ])
              ]),

              for(int i = 0; i < equipmentInfoList.length; i++)
                Table(border: TableBorder.all(),children: [
                  TableRow(children: <Widget>[
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              EditEquipment(name: equipmentInfoList[i][0], category: equipmentInfoList[i][1],
                                storageLocation: equipmentInfoList[i][2], totalAmount: int.parse(equipmentInfoList[i][4]),))
                          );
                    }, child: Text(equipmentInfoList[i][0], textAlign: TextAlign.center)),
                    Text(equipmentInfoList[i][1], textAlign: TextAlign.center),
                    Text(equipmentInfoList[i][2], textAlign: TextAlign.center),
                    Text(equipmentInfoList[i][3], textAlign: TextAlign.center),
                    Text(equipmentInfoList[i][4], textAlign: TextAlign.center),
                    Text(equipmentInfoList[i][5], textAlign: TextAlign.center),
                  ])
                ])
            ],
          ),
        ),
      ),
    );
  }
}

class EditEquipment extends StatefulWidget {
  const EditEquipment({Key? key, required this.name,
    required this.totalAmount, required this.category,
    required this.storageLocation}) : super(key: key);
  final String name;
  final int totalAmount;
  final String category;
  final String storageLocation;
  @override
  EditEquipmentState createState() {
    return EditEquipmentState();
  }
}
class EditEquipmentState extends State<EditEquipment> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  final TextEditingController myController3 = TextEditingController();
  bool invalidAmount = false;

  @override
  void initState(){
    myController1.text = widget.totalAmount.toString();
    myController2.text = widget.category;
    myController3.text = widget.storageLocation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View/Edit Equipment Information')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              Text(widget.name, style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center),
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Total Amount',
                      errorText: invalidAmount ? 'Invalid Amount': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Category')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController3,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Storage Location')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    if(myController1.text != '' && myController2.text != '' && myController3.text != ''){
                      var response = await editEquipment(widget.name, int.parse(myController1.text),
                          myController2.text, myController3.text);
                      if(response == 'Invalid Amount'){
                        setState(() {
                          invalidAmount = true;
                        });
                      } else {
                        setState(() {
                          invalidAmount = false;
                          Navigator.pop(context);
                        });
                      }
                    }
                  },
                  child: const Text('Submit')
              ),
              OutlinedButton(onPressed: () async {
                var response = await removeEquipment(widget.name);
                if(response == 'Removed'){
                  setState(() {
                    invalidAmount = false;
                    Navigator.pop(context);
                  });
                }
              }, child: const Text('Remove Equipment'))

            ],
          ),
        ),
      ),
    );
  }
}

class ViewForms extends StatefulWidget {
  const ViewForms({Key? key}) : super(key: key);
  @override
  ViewFormsState createState() {
    return ViewFormsState();
  }
}
class ViewFormsState extends State<ViewForms> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  final TextEditingController myController3 = TextEditingController();
  bool invalidUser = false;
  bool invalidEquipment = false;
  bool invalidForm = false;
  var formIDs = List<String>.filled(0, '', growable: true);
  var formInfo =List<String>.filled(0, '', growable: true);
  var formInfoList = List<List<String>>.filled(0, [], growable: true);

  @override
  void initState(){
    formInfoList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View/Edit Forms')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Username',
                      errorText: invalidUser ? 'User Has No Forms': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Equipment Name',
                      errorText: invalidEquipment ? 'Equipment Has No Forms': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController3,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Form Name',
                      errorText: invalidForm ? 'Equipment Has No Forms': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    formInfoList = [];
                    formIDs = [];
                    formIDs = await formIDbyUser(myController1.text);
                    for(int i = 0; i < formIDs.length; i++){
                      formInfo = await getFormInfo(formIDs[i]);
                      formInfoList.add(formInfo);
                    }
                    switch (formIDs[0]){
                      case 'User Has No Forms':{
                        setState(() {
                          invalidUser = true;
                          invalidEquipment = false;
                          invalidForm = false;
                          formInfoList = [];
                          formIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                          invalidForm = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Search By User')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    formInfoList = [];
                    formIDs = [];
                    formIDs = await formIDbyEquipment(myController2.text);
                    for(int i = 0; i < formIDs.length; i++){
                      formInfo = await getFormInfo(formIDs[i]);
                      formInfoList.add(formInfo);
                    }
                    switch (formIDs[0]){
                      case 'Equipment Has No Forms':{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = true;
                          invalidForm = false;
                          formInfoList = [];
                          formIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                          invalidForm = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Search By Equipment')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    formInfoList = [];
                    formIDs = [];
                    formIDs = await formIDbyName(myController3.text);
                    for(int i = 0; i < formIDs.length; i++){
                      formInfo = await getFormInfo(formIDs[i]);
                      formInfoList.add(formInfo);
                    }
                    switch (formIDs[0]){
                      case 'No Forms With This Name':{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                          invalidForm = true;
                          formInfoList = [];
                          formIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                          invalidForm = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Search By Form Name')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    formInfoList = [];
                    formIDs = [];
                    formIDs = await allFormIDs();
                    for(int i = 0; i < formIDs.length; i++){
                      formInfo = await getFormInfo(formIDs[i]);
                      formInfoList.add(formInfo);
                    }
                    switch (formIDs[0]){
                      case 'No Forms':{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                          invalidForm = false;
                          formInfoList = [];
                          formIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                          invalidForm = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Load All Forms')
              ),
              const SizedBox(height: 15),

              Table(border: TableBorder.all(),children: const [
                TableRow(children: <Widget>[
                  Text('Username', textAlign: TextAlign.center),
                  Text('Form Name', textAlign: TextAlign.center),
                  Text('Form Info', textAlign: TextAlign.center),
                  Text('Verification', textAlign: TextAlign.center),
                ])
              ]),

              for(int i = 0; i < formInfoList.length; i++)
                Table(border: TableBorder.all(),children: [
                  TableRow(children: <Widget>[
                    TextButton(onPressed: () {
                      setState(() {
                        invalidUser = false;
                        invalidEquipment = false;
                        invalidForm = false;
                      });
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              EditForm(username: formInfoList[i][2], formID: formInfoList[i][0],
                                formName: formInfoList[i][1], verification: formInfoList[i][4],
                                info: formInfoList[i][3])
                          ));
                    }, child: Text(formInfoList[i][2], textAlign: TextAlign.center)),
                    Text(formInfoList[i][1], textAlign: TextAlign.center),
                    Text(formInfoList[i][3], textAlign: TextAlign.center),
                    Text(formInfoList[i][4], textAlign: TextAlign.center),
                  ])
                ])
            ],
          ),
        ),
      ),
    );
  }
}

class EditForm extends StatefulWidget {
  const EditForm({Key? key, required this.username,
    required this.formID, required this.formName,
    required this.verification, required this.info}) : super(key: key);
  final String username;
  final String formID;
  final String formName;
  final String info;
  final String verification;
  @override
  EditFormState createState() {
    return EditFormState();
  }
}
class EditFormState extends State<EditForm> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  bool verification = false;

  @override
  void initState(){
    myController1.text = widget.formName;
    myController2.text = widget.info;
    if(widget.verification == 'true'){
      verification = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View/Edit Form Information')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              Text(widget.username, style: const TextStyle(fontSize: 25),
                  textAlign: TextAlign.center),
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Form Name')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Form Info')
              ),
              const SizedBox(height: 15),
              CheckboxListTile(title: const Text('Verification'), value: verification, onChanged: (bool? value) {
                setState(() {
                  verification = value!;
                });
              }),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    var response = await editForm(widget.formID, myController1.text, myController2.text, verification);
                    if(response == 'Updated'){
                      setState(() {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text('Submit')
              ),
              OutlinedButton(onPressed: () async {
                var response = await removeForm(widget.formID);
                if(response == 'Removed'){
                  setState(() {
                    Navigator.pop(context);
                  });
                }
              }, child: const Text('Remove Form'))
            ],
          ),
        ),
      ),
    );
  }
}

class ViewRequests extends StatefulWidget {
  const ViewRequests({Key? key}) : super(key: key);
  @override
  ViewRequestsState createState() {
    return ViewRequestsState();
  }
}
class ViewRequestsState extends State<ViewRequests> {
  final TextEditingController myController1 = TextEditingController();
  bool invalidUser = false;
  var requestIDs = List<String>.filled(0, '', growable: true);
  var requestInfo =List<String>.filled(0, '', growable: true);
  var requestInfoList = List<List<String>>.filled(0, [], growable: true);

  @override
  void initState(){
    requestInfoList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View Requests')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Username',
                      errorText: invalidUser ? 'This User Has No Requests': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    requestInfoList = [];
                    requestIDs = await findRequests(myController1.text);
                    for(int i = 0; i < requestIDs.length; i++){
                      requestInfo = await getRequestInfo(requestIDs[i]);
                      requestInfoList.add(requestInfo);
                    }
                    switch (requestIDs[0]){
                      case 'No Requests':{
                        setState(() {
                          invalidUser = true;
                          requestInfoList = [];
                          requestInfo = [];
                          requestIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Search By User')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    requestInfoList = [];
                    requestIDs = [];
                    requestIDs = await allRequestIDs();
                    for(int i = 0; i < requestIDs.length; i++){
                      requestInfo = await getRequestInfo(requestIDs[i]);
                      requestInfoList.add(requestInfo);
                    }
                    switch (requestIDs[0]){
                      case 'No Requests':{
                        setState(() {
                          invalidUser = false;
                          requestInfoList = [];
                          requestIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Load All Requests')
              ),
              const SizedBox(height: 15),

              Table(border: TableBorder.all(),children: const [
                TableRow(children: <Widget>[
                  Text('Username', textAlign: TextAlign.center),
                  Text('Equipment Name', textAlign: TextAlign.center),
                  Text('Requested Amount', textAlign: TextAlign.center),
                  Text('Timestamp', textAlign: TextAlign.center),
                ])
              ]),

              for(int i = 0; i < requestInfoList.length; i++)
                Table(border: TableBorder.all(),children: [
                  TableRow(children: <Widget>[
                    Text(requestInfoList[i][1], textAlign: TextAlign.center),
                    Text(requestInfoList[i][2], textAlign: TextAlign.center),
                    Text(requestInfoList[i][3], textAlign: TextAlign.center),
                    Text(requestInfoList[i][4], textAlign: TextAlign.center),
                  ])
                ])
            ],
          ),
        ),
      ),
    );
  }
}

class ViewHistory extends StatefulWidget {
  const ViewHistory({Key? key}) : super(key: key);
  @override
  ViewHistoryState createState() {
    return ViewHistoryState();
  }
}
class ViewHistoryState extends State<ViewHistory> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  bool invalidUser = false;
  bool invalidEquipment = false;
  var historyIDs = List<String>.filled(0, '', growable: true);
  var historyInfo =List<String>.filled(0, '', growable: true);
  var historyInfoList = List<List<String>>.filled(0, [], growable: true);

  @override
  void initState(){
    historyInfoList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View/Edit Checkout History')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Username',
                      errorText: invalidUser ? 'User Has No Checkout History': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Equipment Name',
                      errorText: invalidEquipment ? 'Equipment Has No Checkout History': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    historyInfoList = [];
                    historyIDs = await historyIDbyUser(myController1.text);
                    for(int i = 0; i < historyIDs.length; i++){
                      historyInfo = await getHistoryInfo(historyIDs[i]);
                      historyInfoList.add(historyInfo);
                    }
                    switch (historyIDs[0]){
                      case 'No Checkout History':{
                        setState(() {
                          invalidUser = true;
                          invalidEquipment = false;
                          historyInfoList = [];
                          historyInfo = [];
                          historyIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Search By User')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    historyInfoList = [];
                    historyIDs = await historyIDbyEquipment(myController2.text);
                    for(int i = 0; i < historyIDs.length; i++){
                      historyInfo = await getHistoryInfo(historyIDs[i]);
                      historyInfoList.add(historyInfo);
                    }
                    switch (historyIDs[0]){
                      case 'No Checkout History':{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = true;
                          historyInfoList = [];
                          historyInfo = [];
                          historyIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Search By Equipment')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async{
                    historyInfoList = [];
                    historyIDs = [];
                    historyIDs = await allHistoryIDs();
                    for(int i = 0; i < historyIDs.length; i++){
                      historyInfo = await getHistoryInfo(historyIDs[i]);
                      historyInfoList.add(historyInfo);
                    }
                    switch (historyIDs[0]){
                      case 'No Checkout History':{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                          historyInfoList = [];
                          historyIDs = [];
                        });

                      }
                      break;

                      default:{
                        setState(() {
                          invalidUser = false;
                          invalidEquipment = false;
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Load All Checkout Histories')
              ),
              const SizedBox(height: 15),
              Table(border: TableBorder.all(),children: const [
                TableRow(children: <Widget>[
                  Text('Username', textAlign: TextAlign.center),
                  Text('Equipment Name', textAlign: TextAlign.center),
                  Text('Amount Out', textAlign: TextAlign.center),
                  Text('Admin Out', textAlign: TextAlign.center),
                  Text('Timestamp Out', textAlign: TextAlign.center),
                  Text('Amount In', textAlign: TextAlign.center),
                  Text('Admin In', textAlign: TextAlign.center),
                  Text('Timestamp In', textAlign: TextAlign.center),
                ])
              ]),

              for(int i = 0; i < historyInfoList.length; i++)
                Table(border: TableBorder.all(),children: [
                  TableRow(children: <Widget>[
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                      if(historyInfoList[i].length > 7) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                EditHistory(historyID: historyInfoList[i][0],
                                  user: historyInfoList[i][1],
                                  equipment: historyInfoList[i][2],
                                  amountOut: int.parse(
                                      historyInfoList[i][3].toString()),
                                  adminOut: historyInfoList[i][4],
                                  timestampOut: historyInfoList[i][5],
                                  amountIn: int.parse(
                                      historyInfoList[i][6].toString()),
                                  adminIn: historyInfoList[i][7],
                                  timestampIn: historyInfoList[i][8],
                                )
                            ));
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                EditHistory(historyID: historyInfoList[i][0],
                                  user: historyInfoList[i][1],
                                  equipment: historyInfoList[i][2],
                                  amountOut: int.parse(
                                      historyInfoList[i][3].toString()),
                                  adminOut: historyInfoList[i][4],
                                  timestampOut: historyInfoList[i][5],
                                  amountIn: 0, adminIn: '', timestampIn: '',
                                )
                            ));
                      }                      }, child: Text(historyInfoList[i][1], textAlign: TextAlign.center)),
                    Text(historyInfoList[i][2], textAlign: TextAlign.center),
                    Text(historyInfoList[i][3], textAlign: TextAlign.center),
                    Text(historyInfoList[i][4], textAlign: TextAlign.center),
                    Text(historyInfoList[i][5], textAlign: TextAlign.center),
                    if(historyInfoList[i].length < 7)
                      const Text('-', textAlign: TextAlign.center),
                    if(historyInfoList[i].length < 7)
                      const Text('-', textAlign: TextAlign.center),
                    if(historyInfoList[i].length < 7)
                      const Text('-', textAlign: TextAlign.center),
                    if(historyInfoList[i].length > 7)
                      Text(historyInfoList[i][6], textAlign: TextAlign.center),
                    if(historyInfoList[i].length > 7)
                      Text(historyInfoList[i][7], textAlign: TextAlign.center),
                    if(historyInfoList[i].length > 7)
                      Text(historyInfoList[i][8], textAlign: TextAlign.center),
                  ])
                ])
            ],
          ),
        ),
      ),
    );
  }
}

class EditHistory extends StatefulWidget {
  const EditHistory({Key? key, required this.historyID,
    required this.user, required this.equipment, required this.amountOut,
    required this.adminOut, required this.timestampOut, required this.amountIn,
    required this.adminIn, required this.timestampIn}) : super(key: key);
  final String historyID;
  final String user;
  final String equipment;
  final int amountOut;
  final String adminOut;
  final String timestampOut;
  final int amountIn;
  final String adminIn;
  final String timestampIn;
  @override
  EditHistoryState createState() {
    return EditHistoryState();
  }
}
class EditHistoryState extends State<EditHistory> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  final TextEditingController myController3 = TextEditingController();
  final TextEditingController myController4 = TextEditingController();
  final TextEditingController myController5 = TextEditingController();
  final TextEditingController myController6 = TextEditingController();
  bool invalidAmount = false;

  @override
  void initState(){
    myController1.text = widget.amountOut.toString();
    myController2.text = widget.adminOut;
    myController3.text = widget.timestampOut;
    myController4.text = widget.amountIn.toString();
    myController5.text = widget.adminIn;
    myController6.text = widget.timestampIn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View/Edit Equipment Information')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              Text('${widget.user}, ${widget.equipment}', style: const TextStyle(fontSize: 25),
                  textAlign: TextAlign.center),
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Amount Checked Out',
                      errorText: invalidAmount ? 'Invalid Amount': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Admin That Verified Checkout')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController3,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Checkout Timestamp')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController4,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Amount Checked In',
                      errorText: invalidAmount ? 'Invalid Amount': null)
                ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController5,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Admin That Verified Check In')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController6,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Check In Timestamp')
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    var response = await editHistory(widget.historyID, int.parse(myController1.text), myController2.text,
                        myController3.text, int.parse(myController4.text), myController5.text, myController6.text);
                    if(response == 'Invalid Amounts'){
                      setState(() {
                        invalidAmount = true;
                      });
                    } else {
                      if(response == 'Updated'){
                        setState(() {
                          invalidAmount = false;
                          Navigator.pop(context);
                        });
                      }
                    }
                  },
                  child: const Text('Submit')
              ),
              OutlinedButton(
                  onPressed: () async {
                    var response = await removeHistory(widget.historyID);
                    if(response == 'Removed'){
                      setState(() {
                        invalidAmount = false;
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text('Remove History')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateAdminPage extends StatefulWidget {
  const CreateAdminPage({Key? key}) : super(key: key);
  @override
  CreateAdminPageState createState() {
    return CreateAdminPageState();
  }
}
class CreateAdminPageState extends State<CreateAdminPage> {
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  final TextEditingController myController3 = TextEditingController();
  final TextEditingController myController4 = TextEditingController();
  final TextEditingController myController5 = TextEditingController();
  final TextEditingController myController6 = TextEditingController();
  final TextEditingController myController7 = TextEditingController();
  bool invalidUser = false;
  bool invalidEmail = false;
  bool invalidUIN = false;
  bool invalidPhone = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Create Admin Account')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Username',
                      errorText: invalidUser ? 'Invalid Username': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController2,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Password')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController3,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'UIN',
                      errorText: invalidUIN ? 'Invalid UIN': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController4,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'First Name')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController5,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Last Name')
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController6,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Email',
                      errorText: invalidEmail ? 'Invalid Email': null)
              ),
              const SizedBox(height: 15),
              TextField(
                  controller: myController7,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Phone Number',
                    errorText: invalidPhone ? 'Invalid Phone Number': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    var response = await createAdminUser( myController1.text, myController2.text , int.parse(myController3.text),
                        myController4.text, myController5.text, myController6.text, int.parse(myController7.text));
                    switch(response){
                      case 'Invalid Username': {
                        setState(() {
                          invalidUser = true;
                          invalidEmail = false;
                          invalidUIN = false;
                          invalidPhone = false;
                        });
                      }
                      break;

                      case 'Invalid Email': {
                        setState(() {
                          invalidUser = false;
                          invalidEmail = true;
                          invalidUIN = false;
                          invalidPhone = false;
                        });
                      }
                      break;

                      case 'Invalid UIN': {
                        setState(() {
                          invalidUser = false;
                          invalidEmail = false;
                          invalidUIN = true;
                          invalidPhone = false;
                        });
                      }
                      break;

                      case 'Invalid Phone Number': {
                        setState(() {
                          invalidUser = false;
                          invalidEmail = false;
                          invalidUIN = false;
                          invalidPhone = true;
                        });
                      }
                      break;

                      case 'Created': {
                        setState(() {
                          invalidUser = false;
                          invalidEmail = false;
                          invalidUIN = false;
                          invalidPhone = false;
                          Navigator.pop(context);
                        });
                      }
                      break;
                    }
                  },
                  child: const Text('Submit')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);
  @override
  NotificationsPageState createState() {
    return NotificationsPageState();
  }
}
class NotificationsPageState extends State<NotificationsPage> {
  final TextEditingController myController1 = TextEditingController();
  bool invalidUIN = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Notifications')
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              TextField(
                  controller: myController1,
                  decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'UIN',
                      errorText: invalidUIN ? 'Invalid UIN': null)
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    var response = await userByUIN(int.parse(myController1.text));
                    if(response == 'Invalid UIN'){
                      setState(() {
                        invalidUIN = true;
                      });
                    } else {
                      setState(() {
                        invalidUIN = false;
                      });
                    }
                  },
                  child: const Text('Submit')
              ),
            ],
          ),
        ),
      ),
    );
  }
}