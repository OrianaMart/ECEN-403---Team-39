//Database inclusion and function definitions
//Michael Stallbaumer
//UIN: 428002868
//Importing all relevant firebase packages and the needed options file generated through the flutterfire_CLI
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/cupertino.dart';
import 'firebase_options.dart';

//Firebase Gmail account login information: Username: smartinventorytamu@gmail.com Password: EricTeam#39

FirebaseDatabase database = FirebaseDatabase.instance;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to initialize the database, must be called immediately and only once
initializeDatabase()
{
    Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );
    return;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function for creating an Admin user, only able to be accessed by admins
Future<String> createAdminUser(
    String username, String password, int uin,
    String firstName, String lastName, String email,
    int phoneNumber
    ) async
{
    //Sets database reference to the username, making it the primary key
    DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');

    //Checks to see if the primary key already exists (user exists)
    var dataTest = await usersRef.child(username).get();
    if (dataTest.exists){
        //ERROR CATCHING RESULT HERE!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        return 'Invalid Username';
    } else {
        //Writes the new Admins information to their new primary key with Admin status (No Team#)

        //checks if the UIN is used in a different account or if the UIN is the wrong number of digits
        Query uinQuery = usersRef.orderByChild('uin').equalTo(uin);
        DataSnapshot uinResult = await uinQuery.get();

        if(uinResult.exists || uin.toString().length != 9) {
            return 'Invalid UIN';
        } else {
            //checks if the email is used in a different account
            Query emailQuery = usersRef.orderByChild('email').equalTo(email);
            DataSnapshot emailResult = await emailQuery.get();

            if (emailResult.exists) {
                return 'Invalid Email';
            } else {
                //If the username does not yet exist
                //checks to see if the phone number is used in a different account or not 9 digits
                Query phoneQuery = usersRef.orderByChild('phoneNumber').equalTo(phoneNumber);
                DataSnapshot phoneResult = await phoneQuery.get();

                if(phoneResult.exists || phoneNumber.toString().length != 10) {
                    return 'Invalid Phone Number';
                } else {
                    //writes admin information
                    await usersRef.child(username).set({
                        'password': password,
                        'uin': uin,
                        'firstName': firstName,
                        'lastName': lastName,
                        "email": email,
                        "phoneNumber": phoneNumber,
                        'adminStatus': true
                    });
                    return 'Created';
                }
            }
        }
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function for creating a Student user, available on the create user page
Future<String> createStudentUser(
    String username, String password, int uin,
    String firstName, String lastName, String email,
    int phoneNumber, int teamNumber, int courseNumber) async
{
    //Sets database reference to the username, making it the primary key
    DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');

    //Checks to see if the primary key already exists (user exists)
    var dataTest = await usersRef.child(username).get();
    if (dataTest.exists){
        //ERROR CATCHING RESULT HERE!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        return 'Invalid Username';
    } else {
        //checks if the UIN is used in a different account or if the UIN is not the correct amount of digits
        Query uinQuery = usersRef.orderByChild('uin').equalTo(uin);
        DataSnapshot uinResult = await uinQuery.get();

        if (uinResult.exists || uin.toString().length != 9) {
            return 'Invalid UIN';

        } else {
            //If the username does not yet exist

            //checks if the email is used in a different account
            Query emailQuery = usersRef.orderByChild('email').equalTo(email);
            DataSnapshot emailResult = await emailQuery.get();

            if (emailResult.exists) {
                return 'Invalid Email';

            } else {
                //checks to see if the phone number is used in a different account or not 9 digits
                Query phoneQuery = usersRef.orderByChild('phoneNumber').equalTo(phoneNumber);
                DataSnapshot phoneResult = await phoneQuery.get();

                if(phoneResult.exists || phoneNumber.toString().length != 10) {
                    return 'Invalid Phone Number';
                } else {
                    //checks to see is the course number is valid
                    if(courseNumber != 403 && courseNumber != 404){
                        return 'Invalid Course Number';
                    } else {
                        //Writes the new Student information to their new primary key with no Admin status
                        await usersRef.child(username).set({
                            'password': password,
                            'uin': uin,
                            'firstName': firstName,
                            'lastName': lastName,
                            "email": email,
                            "phoneNumber": phoneNumber,
                            'adminStatus': false,
                            'teamNumber': teamNumber,
                            'courseNumber': courseNumber
                        });
                        return 'Created';
                    }
                }
            }
        }
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function for adding a new equipment item to the inventory, Admin only
Future<String> newEquipment(
    String name, int totalAmount,
    String category, String storageLocation) async
{
    //sets reference point to the inventory section
    DatabaseReference equipmentRef = FirebaseDatabase.instance.ref('inventory/$name');
    var dataTest = await equipmentRef.get();
    if (dataTest.exists){
        //ERROR CATCHING RESULT HERE!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        return 'Creation Failed';
    }else {
        if(totalAmount >= 1) {
            //Set all relevant equipment information other than the required forms to a unique primary key
            equipmentRef.set({
                'totalAmount': totalAmount,
                'amountAvailable': totalAmount,
                'category': category,
                'storageLocation': storageLocation,
            });
            return 'Created';
        } else {
            return 'Invalid Amount';
        }
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function for adding a new individual student form to the system
Future<String> newForm(
    String formName, String user, String info) async
{
    //Sets a database reference to the forms section
    DatabaseReference formsRef = FirebaseDatabase.instance.ref('forms');

    //Queries the forms to look for any forms the user may have made
    Query query = formsRef.orderByChild('user').equalTo(user);
    DataSnapshot event = await query.get();

    //Checks to see if any of the users forms have the same name as the form being created
    if(event.value.toString().contains(formName)){
        //ERROR CATCHING RESULT HERE!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        return 'User Already Has Form';
    } else {
        //If no form is made for the user with the dame name, pushes form information
        DatabaseReference formRef = formsRef.push();
        String formKey = formRef.key.toString();
        formRef.set({
            'formName': formName,
            'user': user,
            'info': info,
            'verification': false
        });
        DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$user/forms');
        userRef.update({formName: formKey});
        return 'Form Created';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function for Admins to verify form completion
Future<String> verifyForm(String user, String formName) async
{
    //sets user reference to the user being verified
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$user/forms/$formName');
    var dataTest = await userRef.get();
    if(dataTest.exists){
        DataSnapshot event = await userRef.get();
        String formID = event.value.toString();
        //Sets a database reference to the specific form id
        DatabaseReference formRef = FirebaseDatabase.instance.ref('forms/$formID');
        //Checks to see if the form exists
        dataTest = await formRef.get();
        if(dataTest.exists){
            //makes verification status true
            formRef.update({'verification': true});
            return 'Verified';
        }
    }
    return 'Not Verified';
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function for adding form requirements for an equipment, admin only function
Future<String> addFormRequirement(
    String formName, String equipmentName) async
{
    //Sets a database reference to the equipment
    DatabaseReference equipmentRef = FirebaseDatabase.instance.ref('inventory/$equipmentName');
    //creates a variable for data testing
    var dataTest = await equipmentRef.get();
    //checks to see if the equipment exists
    if(dataTest.exists) {
        //tests for the formName in the equipment
        dataTest = await equipmentRef.child('forms/$formName').get();
        if (dataTest.exists) {
            //ERROR CATCHING RESULT HERE!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            return 'Form Already Required';
        } else {
            //update requirements if the form isn't already required
            equipmentRef.child('forms').update({formName: true});
            return 'Form Required';
        }
    } else {
        return 'Invalid Equipment';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function for Student accounts to generate an equipment request
Future<String> generateNewRequest(String user, String equipment, int requestedAmount) async
{
    //Request verification:
    //Open references to user and inventory for checks
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$user');
    DatabaseReference equipmentRef = FirebaseDatabase.instance.ref('inventory/$equipment');

    //integers for tracking if all required forms are completed
    int completeForms = 0;
    int totalForms = 0;

    //tests to make sure that the username exists
    DataSnapshot userData = await userRef.get();
    if(userData.exists) {
        //tests to ensure that the equipment exists and there is an available amount before performing logic
        var dataTest = await equipmentRef.child('amountAvailable').get();
        if (dataTest.exists) {
            //Creates a data snapshot to read the available amount of equipment
            DataSnapshot event = await equipmentRef.child('amountAvailable').get();

            //creates an integer of the amount available minus the amount requested
            int amount = int.parse(event.value.toString()) - requestedAmount;

            //if the amount requested is available and that the amount is not negative
            if (amount >= 0 && requestedAmount > 0) {
                //creates a snapshot of the required forms for checking out a specific equipment
                DataSnapshot equipForms = await equipmentRef.child('forms').get();

                //creates a snapshot of the forms related to a specific user
                DataSnapshot userForms = await userRef.child('forms').get();

                //if there are form requirements for check out
                if (equipForms.exists) {
                    //Iterate through all children in equipForms(all of the forms required for checkout)
                    for (final i in equipForms.children) {
                        String formName = i.key.toString();
                        for (final j in userForms.children) {
                            String userForm = j.key.toString();
                            if (formName == userForm) {
                                String formReference = userForms.child(j.value.toString()).key.toString();
                                DatabaseReference formRef = FirebaseDatabase.instance.ref('forms/$formReference/verification');
                                DataSnapshot verified = await formRef.get();
                                if (verified.value == true) {
                                    completeForms++;
                                }
                            }
                        }
                        totalForms++;
                    }
                }
                if (totalForms == completeForms) {
                    //Request generation:
                    //Generates a timestamp for the generated request
                    String timestamp = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';

                    //Sets the database reference to be the requests section
                    DatabaseReference requestRef = FirebaseDatabase.instance.ref('requests');
                    //Pushes a new entry to requests with the desired data with unique primary key
                    requestRef.push().set({
                        'username': user,
                        'equipment': equipment,
                        'timestamp': timestamp,
                        'amount': requestedAmount
                    });
                    equipmentRef.update({'amountAvailable': amount});
                    //returns success
                    return 'Generated';
                } else {
                    //Throw Error (not correct permissions)
                    return 'Invalid Permissions';
                }
            } else {
                //The checkout amount is negative or more than available
                return 'Invalid Amount';
            }
        } else {
            //Equipment doesn't exist
            return 'Invalid Equipment';
        }
    } else {
        //User doesn't exist
        return 'Invalid Username';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to approve a request, admin only
Future<String> approveRequest(String requestID, int uin, String adminUser) async
{
    //creates database references for the specific request and parent history reference
    DatabaseReference requestRef = FirebaseDatabase.instance.ref('requests/$requestID');
    DatabaseReference historyRef = FirebaseDatabase.instance.ref('checkoutHistory');

    //Takes a snapshot of the data in the request for storing the username and equipment in the history
    DataSnapshot request = await requestRef.get();

    //creates a database reference and snapshot of the user associated with the request for uin verification
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${request.child('username').value.toString()}');
    DataSnapshot uinData = await userRef.child('uin').get();

    //check if the target request exists
    if(request.exists) {
        //verifies students uin to complete checkout
        if(int.parse(uinData.value.toString()) == uin) {
            //creates a timestamp for storing the check out date and time
            String timestamp = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';

            //pushes the information for the checkout to the history part of the database for equipment tracking
            historyRef.push().set({
                'equipment': request.child('equipment').value.toString(),
                'username': request.child('username').value.toString(),
                'timestampOut': timestamp,
                'adminOut': adminUser,
                'amountOut': int.parse(request.child('amount').value.toString())
            });

            //deletes the pending request
            requestRef.remove();

            //returns successful approval
            return 'Approved';
        } else{
            //Uin does not match what is in the database
            return 'Invalid UIN';
        }
    } else{
        //ERROR CATCHING RESULT HERE!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        return 'Invalid Request';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to deny a request, admin only
Future<String> denyRequest(String requestID) async
{
    //Create a database reference to the request in order to find equipment information
    DatabaseReference requestRef = FirebaseDatabase.instance.ref('requests/$requestID');
    DataSnapshot request = await requestRef.get();

    //checks to see if request exists
    if(request.exists) {
        //Sets equipmentID to be the ID stored in the request
        String equipmentID = request.child('equipment').value.toString();

        //Creates a database reference to the equipment that was being requested
        DatabaseReference equipment = FirebaseDatabase.instance.ref('inventory/$equipmentID');

        //Reads the equipment information for adding inventory back to the system
        DataSnapshot oldAmount = await equipment.child('amountAvailable').get();

        //checks to ensure that the equipment exists
        if(oldAmount.exists) {
            //Variable to hold add the values in before sending them to the data base
            int newAmount = int.parse(request.child('amount').value.toString()) + int.parse(oldAmount.value.toString());

            //updates the amount of equipment in the inventory to reflect the denied reservation
            equipment.update({'amountAvailable': newAmount});

            //deletes reservation entry
            requestRef.remove();

            //returns success
            return 'Denied';
        } else {
            //equipment doesn't exist
            return 'Invalid Equipment';
        }
    } else {
        //ERROR CATCHING~~~~~~~~~~~~~~~~~
        return 'Invalid Request';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to verify a check in of equipment
Future<String> verifyCheckIn(String historyID, int uin, int amountIn, String adminUser) async
{
    //makes a database reference to the associated checkout ID and takes a snapshot to use data
    DatabaseReference historyRef = FirebaseDatabase.instance.ref('checkoutHistory/$historyID');
    DataSnapshot oldHistory = await historyRef.get();

    //checks that the historyID is valid
    if(oldHistory.exists){
        //opens equipment reference and snapshot
        DatabaseReference equipmentRef = FirebaseDatabase.instance.ref('inventory/${oldHistory.child('equipment').value.toString()}');
        DataSnapshot equipment = await equipmentRef.get();

        //checks if the equipment is valid
        if(equipment.exists) {
            //creates database reference and snapshot to verify uin
            DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${oldHistory.child('username').value.toString()}');
            DataSnapshot userData = await userRef.get();

            //checks if the username is valid
            if(userData.exists) {
                //setting up timestamp
                String timestamp = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';

                //verifies uin from database
                if (int.parse(userData.child('uin').value.toString()) == uin) {
                    //checks to see if there is any already checked in
                    if (oldHistory.child('amountIn').exists) {
                        //checks that the amount being checked in wont cause checked in amount to be larger than checked out
                        if (int.parse(oldHistory.child('amountIn').value.toString()) + amountIn <= int.parse(oldHistory.child('amountOut').value.toString()) && amountIn > 0) {
                            //updates the history to have the correct amount marked as checked in
                            historyRef.update({
                                'amountIn': int.parse(oldHistory.child('amountIn').value.toString()) + amountIn,
                                'adminIn': adminUser,
                                'timestampIn': timestamp
                            });
                            //updates the equipment available amount to reflect the amount checked in
                            equipmentRef.update({'amountAvailable': int.parse(equipment.child('amountAvailable').value.toString()) + amountIn});
                            return 'Checked In';
                        } else {
                            //Cannot check in this amount to this checkout history (maybe split it somehow) or amount in is negative
                            return 'Invalid Amount';
                        }
                    } else {
                        //if amountIn is less than or equal the amount that was checked out and that the amountIn is positive
                        if (amountIn <= int.parse(oldHistory.child('amountOut').value.toString()) && amountIn > 0) {
                            //updates history with check-in info
                            historyRef.update({
                                'amountIn': amountIn,
                                'adminIn': adminUser,
                                'timestampIn': timestamp
                            });
                            //updates the equipment available amount to reflect the amount checked in
                            equipmentRef.update({'amountAvailable': int.parse(equipment.child('amountAvailable').value.toString()) + amountIn});
                            return 'Checked In';
                        } else {
                            //the amount is negative or too much
                            return 'Invalid Amount';
                        }
                    }
                } else {
                    //Uin is invalid
                    return 'Invalid UIN';
                }
            } else {
                //The username doesn't exist
                return 'Invalid Username';
            }
        } else {
            //equipment doesn't exist
            return 'Invalid Equipment';
        }
    } else {
        //Error Throw, historyID is invalid
        return 'Invalid Checkout History';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to find request based on usernames
Future<List<String>> findRequests(String user) async
{
    //sets up a list to return to the UI once it finds all request IDs for a given username
    var requests = List<String>.filled(0, '', growable: true);

    //Creates a database reference to the requests section of the database
    DatabaseReference requestsRef = FirebaseDatabase.instance.ref('requests');
    Query query = requestsRef.orderByChild('username').equalTo(user);

    //creates a snapshot of the queried data
    DataSnapshot event = await query.get();
    if(event.exists) {
        for (final child in event.children) {
            requests.add(child.key.toString());
        }
    } else{
        //ERROR Catching (no requests)~~~~~~~~~~~~
        requests.add('No Requests');
    }
    return requests;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to Authenticate login credentials
Future<String> authenticate(String username, String password) async
{
    //Opens database reference to the username
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$username');

    //Saves user information into userInfo as a data snapshot
    DataSnapshot userInfo = await userRef.get();

    //checks to see if that username is valid or not
    if(userInfo.exists)
    {
        //if the username exists
        if(password == userInfo.child('password').value.toString()){
            //if the username and password match
            if(userInfo.child('adminStatus').value == false){
                //if the admin status is false, returns that it is a valid student account
                return 'Valid Student';
            } else if(userInfo.child('adminStatus').value == true){
                //if the admin status is true, return that it is valid admin account
                return 'Valid Admin';
            }
            return 'Failed Login';
        } else{
            //if the password entered does not match the account password
            return 'Invalid Password';
        }
    } else{
        //the username does not exist!~~~~~~~~~~~~~~~~~~~~~~~~~~~
        return 'Invalid Username';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to get the login information for a forgot password
Future<List<String>> forgotPassword(String email) async
{
    //sets a database reference to the users directory
    DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');

    //creates the return list
    var loginInfo = List<String>.filled(0, '', growable: true);

    //queries the directory for the passed in email address and takes snapshot of query result
    Query query = usersRef.orderByChild('email').equalTo(email);
    DataSnapshot login = await query.get();

    //checks if the email is valid for an account
    if(login.exists){

        //Cleanest way I have found to return the string value of the key for an object
        for(final child in login.children){
            //adds the username to loginInfo
            loginInfo.add(child.key.toString());
            //adds the password to loginInfo
            loginInfo.add(child.child('password').value.toString());
        }
    } else{
        //ERROR catching (invalid email address for any account)~~~~~~~~~~~~~~~~~~~
        loginInfo.add('Invalid Email');
    }
    return loginInfo;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function for returning a users username from their UIN
Future<String> userByUIN(int uin) async
{
    //sets a database reference to the users directory and performs a query to locate user
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users');
    Query query = userRef.orderByChild('uin').equalTo(uin);

    //takes a data snapshot of the queried information
    DataSnapshot user = await query.get();

    //checks to see if there is a user with the given uin in the database
    if(user.exists){
        //if the user exists it returns the "key" which is the username for the account
        return user.children.first.key.toString();
    } else {
        //ERROR checking (no user associated with this UIN)~~~~~~~~~
        return 'Invalid UIN';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to find all equipment within a category
Future<List<String>> equipmentByCategory(String category) async
{
    //sets up a list to return to the UI once it finds all equipment for a given category
    var equipment = List<String>.filled(0, '', growable: true);

    //Creates a database reference to the equipment section of the database and queries for the category
    DatabaseReference equipmentRef = FirebaseDatabase.instance.ref('inventory');
    Query query = equipmentRef.orderByChild('category').equalTo(category);

    //creates a snapshot of the queried data
    DataSnapshot equipments = await query.get();

    if(equipments.exists) {
        for (final child in equipments.children) {
            equipment.add(child.key.toString());
        }
    } else{
        //ERROR Catching (no equipment)~~~~~~~~~~~~
        equipment.add('Invalid Category');
    }

    //return resulting equipments
    return equipment;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to find all equipment within a location
Future<List<String>> equipmentByLocation(String location) async
{
    //sets up a list to return to the UI once it finds all equipment for a given location
    var equipment = List<String>.filled(0, '', growable: true);

    //Creates a database reference to the equipment section of the database and queries for the location
    DatabaseReference equipmentRef = FirebaseDatabase.instance.ref('inventory');
    Query query = equipmentRef.orderByChild('storageLocation').equalTo(location);

    //creates a snapshot of the queried data
    DataSnapshot equipments = await query.get();

    if(equipments.exists) {
        for (final child in equipments.children) {
            equipment.add(child.key.toString());
        }
    } else{
        //ERROR Catching (no equipment)~~~~~~~~~~~~
        equipment.add('Invalid Location');
    }

    //return resulting equipments
    return equipment;
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return a users information
Future<List<String>> getUserInfo(String username) async
{
    //Sets a database reference to the username of the user
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$username');

    //Takes snapshot of userdata to test existence
    DataSnapshot userData = await userRef.get();

    //makes a list to fill with data and respond with
    var userInfo = List<String>.filled(0, '', growable: true);

    //if the username exists
    if(userData.exists){
        userInfo.add(username);
        userInfo.add(userData.child('uin').value.toString());
        userInfo.add(userData.child('firstName').value.toString());
        userInfo.add(userData.child('lastName').value.toString());
        userInfo.add(userData.child('email').value.toString());
        userInfo.add(userData.child('phoneNumber').value.toString());

        //if the user is an Admin skip course number and team number
        if(userData.child('adminStatus').value == 'true'){
            return userInfo;
        } else{
            userInfo.add(userData.child('courseNumber').value.toString());
            userInfo.add(userData.child('teamNumber').value.toString());

            //finds all forms that are tied to the user
            if(userData.child('forms').exists) {
                var forms = '';
                for (final child in userData.child('forms').children){
                    if(forms == ''){
                        forms = child.key.toString();
                    } else {
                        forms = '$forms, ${child.key.toString()}';
                    }
                }
                userInfo.add(forms);
            }
        }
    } else{
        //Error catching (username isn't valid)~~~~~~~~~~~~~~~~~~~~
        userInfo.add('Invalid Username');
    }

    //returns the userInfo
    return userInfo;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return equipment information
Future<List<String>> getEquipmentInfo(String equipment) async
{
    //Sets a database reference to the equipment
    DatabaseReference equipmentRef = FirebaseDatabase.instance.ref('inventory/$equipment');

    //Takes snapshot of the equipment data to test existence
    DataSnapshot equipmentData = await equipmentRef.get();

    //makes a list to fill with data and respond with
    var equipmentInfo = List<String>.filled(0, '', growable: true);

    //if the username exists
    if(equipmentData.exists){
        equipmentInfo.add(equipment);
        equipmentInfo.add(equipmentData.child('category').value.toString());
        equipmentInfo.add(equipmentData.child('storageLocation').value.toString());
        equipmentInfo.add(equipmentData.child('amountAvailable').value.toString());
        equipmentInfo.add(equipmentData.child('totalAmount').value.toString());

        //displays any and all form requirements
        if(equipmentData.child('forms').exists) {
            var forms = '';
            for (final child in equipmentData.child('forms').children) {
                if (forms == '') {
                    forms = child.key.toString();
                } else {
                    forms = '$forms, ${child.key.toString()}';
                }
            }
            equipmentInfo.add(forms);
        } else {
            equipmentInfo.add(equipmentData.child('forms').value.toString());
        }
    } else{
        //Error catching (equipment name isn't valid)~~~~~~~~~~~~~~~~~~~~
        equipmentInfo.add('Invalid Equipment');
    }

    //returns the userInfo
    return equipmentInfo;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return request information
Future<List<String>> getRequestInfo(String requestID) async
{
    //sets a database reference to the specified request
    DatabaseReference requestRef = FirebaseDatabase.instance.ref('requests/$requestID');

    //Takes snapshot of data for output
    DataSnapshot requestData = await requestRef.get();

    //makes a list to fill with data and respond with
    var requestInfo = List<String>.filled(0, '', growable: true);

    //checks if the request exists
    if(requestData.exists){
        //fills requestInfo with data to be displayed
        requestInfo.add(requestID);
        requestInfo.add(requestData.child('username').value.toString());
        requestInfo.add(requestData.child('equipment').value.toString());
        requestInfo.add(requestData.child('amount').value.toString());
        requestInfo.add(requestData.child('timestamp').value.toString());
    } else{
        //ERROR CATCHING (Request doesn't exist)~~~~~~~~
        requestInfo.add('Invalid Request');
    }

    //returns the found information
    return requestInfo;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to find formIDs by username
Future<List<String>> formIDbyUser(String username) async
{
    //creates the return list
    var formID = List<String>.filled(0, '', growable: true);

    //sets a database reference to the users associated forms directory and makes snapshot
    DatabaseReference formNameRef = FirebaseDatabase.instance.ref('users/$username/forms');
    DataSnapshot formNames = await formNameRef.get();

    //checks to see if there are any associated forms
    if(formNames.exists){
        for(final child in formNames.children){
            formID.add(child.value.toString());
        }
    } else{
        //ERROR checking (no forms)~~~~~~~~~
        formID.add('User Has No Forms');
    }
    //returns the list of found form IDs
    return formID;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to find formIDs by equipment name
Future<List<String>> formIDbyEquipment(String equipment) async
{
    //sets up a list to return to the UI once it finds all form IDs for a given username
    var formIDs = List<String>.filled(0, '', growable: true);

    //Creates a database reference to the forms section of the database and takes data snapshot
    DatabaseReference equipmentRef = FirebaseDatabase.instance.ref('inventory/$equipment/forms');
    DataSnapshot formNames = await equipmentRef.get();

    //checks to see if there are any associated forms
    if(formNames.exists){
        for(final child in formNames.children){
            //fills formID variable with a list of formIDs tied to the formName
            var formID = await formIDbyName(child.key.toString());

            //iterates over the amount of IDs valid for each form attached to the equipment
            for(int i = 0; i < formID.length; i++){
                //adds each individual form ID to the list as its own entry.
                formIDs.add(formID[i]);
            }
        }
    } else{
        //ERROR checking (no forms)~~~~~~~~~
        formIDs.add('Equipment Has No Forms');
    }
    //returns the found formIDs
    return formIDs;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to find formIDs by form name
Future<List<String>> formIDbyName(String formName) async
{
    //sets up a list to return to the UI once it finds all form IDs for a given username
    var formIDs = List<String>.filled(0, '', growable: true);

    //Creates a database reference to the forms section of the database
    DatabaseReference formsRef = FirebaseDatabase.instance.ref('forms');
    Query query = formsRef.orderByChild('formName').equalTo(formName);

    //creates a snapshot of the queried data
    DataSnapshot forms = await query.get();

    if(forms.exists) {
        for (final child in forms.children) {
            formIDs.add(child.key.toString());
        }
    } else{
        //ERROR Catching (no forms)~~~~~~~~~~~~
        formIDs.add('No Forms With This Name');
    }

    //return resulting IDs
    return formIDs;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return form information
Future<List<String>> getFormInfo(String formID) async
{
    //sets a database reference to the specified form
    DatabaseReference formRef = FirebaseDatabase.instance.ref('forms/$formID');

    //Takes snapshot of data for output
    DataSnapshot formData = await formRef.get();

    //makes a list to fill with data and respond with
    var formInfo = List<String>.filled(0, '', growable: true);
    //checks if the form exists
    if(formData.exists){
        //fills requestInfo with data to be displayed
        formInfo.add(formID);
        formInfo.add(formData.child('formName').value.toString());
        formInfo.add(formData.child('user').value.toString());
        formInfo.add(formData.child('info').value.toString());
        formInfo.add(formData.child('verification').value.toString());
    } else{
        //ERROR CATCHING (form doesn't exist)~~~~~~~~
        formInfo.add('Invalid Form');
    }

    //returns the found information
    return formInfo;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return checkout history for a specific user
Future<List<String>> historyIDbyUser(String username) async
{
    //creates the return list
    var historyIDs = List<String>.filled(0, '', growable: true);

    //sets a database reference to the history directory and performs a query
    DatabaseReference historyRef = FirebaseDatabase.instance.ref('checkoutHistory');
    Query query = historyRef.orderByChild('username').equalTo(username);

    //takes a data snapshot of the queried information
    DataSnapshot histories = await query.get();

    //checks to see if there are any associated histories found
    if(histories.exists){
        for(final child in histories.children){
            historyIDs.add(child.key.toString());
        }
    } else{
        //ERROR checking (no history)~~~~~~~~~
        historyIDs.add('No Checkout History');
    }
    //returns the list of found history IDs
    return historyIDs;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return checkout history for a specific equipment
Future<List<String>> historyIDbyEquipment(String equipment) async
{
    //creates the return list
    var historyIDs = List<String>.filled(0, '', growable: true);

    //sets a database reference to the history directory and performs a query
    DatabaseReference historyRef = FirebaseDatabase.instance.ref('checkoutHistory');
    Query query = historyRef.orderByChild('equipment').equalTo(equipment);

    //takes a data snapshot of the queried information
    DataSnapshot histories = await query.get();

    //checks to see if there are any associated histories found
    if(histories.exists){
        for(final child in histories.children){
            historyIDs.add(child.key.toString());
        }
    } else{
        //ERROR checking (no history)~~~~~~~~~
        historyIDs.add('No Checkout History');
    }
    //returns the list of found history IDs
    return historyIDs;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return the details of a specific checkout history.
Future<List<String>> getHistoryInfo(String historyID) async
{
    //sets a database reference to the specified history ID
    DatabaseReference historyRef = FirebaseDatabase.instance.ref('checkoutHistory/$historyID');

    //Takes snapshot of data for output
    DataSnapshot historyData = await historyRef.get();

    //makes a list to fill with data and respond with
    var historyInfo = List<String>.filled(0, '', growable: true);
    //checks if the historyID exists
    if(historyData.exists){
        //fills requestInfo with data to be displayed
        historyInfo.add(historyID);
        historyInfo.add(historyData.child('username').value.toString());
        historyInfo.add(historyData.child('equipment').value.toString());
        historyInfo.add(historyData.child('amountOut').value.toString());
        historyInfo.add(historyData.child('adminOut').value.toString());
        historyInfo.add(historyData.child('timestampOut').value.toString());

        //if any of the amount has been checked in from the checkout
        if(historyData.child('amountIn').exists){
            historyInfo.add(historyData.child('amountIn').value.toString());
            historyInfo.add(historyData.child('adminIn').value.toString());
            historyInfo.add(historyData.child('timestampIn').value.toString());
        }
    } else{
        //ERROR CATCHING (historyID doesn't exist)~~~~~~~~
        historyInfo.add('Invalid History ID');
    }

    //returns the found information
    return historyInfo;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return all Student usernames
Future<List<String>> allStudentUsers() async
{
    //makes the list to use when returning the usernames
    var usernames = List<String>.filled(0, '', growable: true);

    //opens a database reference to user directory and then queries the data
    DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
    Query query = usersRef.orderByChild('adminStatus').equalTo(false);

    //takes snapshot of the query for analyzing data
    DataSnapshot studentUsers = await query.get();

    //checks to see if any students are found
    if(studentUsers.exists){
        //adds all usernames to the username variable for display one at a time
        for(final child in studentUsers.children){
            usernames.add(child.key.toString());
        }
    } else{
        //NO STUDENTS WERE FOUND~~~~~~~~~~~~~
        usernames.add('No Student Users');
    }
    //returns all found usernames
    return usernames;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return all Admin usernames
Future<List<String>> allAdminUsers() async
{
    //makes the list to use when returning the usernames
    var usernames = List<String>.filled(0, '', growable: true);

    //opens a database reference to user directory and then queries the data
    DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
    Query query = usersRef.orderByChild('adminStatus').equalTo(true);

    //takes snapshot of the query for analyzing data
    DataSnapshot adminUsers = await query.get();

    //checks to see if any admins are found
    if(adminUsers.exists){
        //adds all usernames to the username variable for display one at a time
        for(final child in adminUsers.children){
            usernames.add(child.key.toString());
        }
    } else{
        //NO ADMINS WERE FOUND~~~~~~~~~~~~~
        usernames.add('No Admin Users');
    }
    //returns all found usernames
    return usernames;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return all equipment names
Future<List<String>> allEquipment() async
{
    //makes the list to use when returning the equipment names
    var equipment = List<String>.filled(0, '', growable: true);

    //sets database to the equipment and then takes a data snapshot
    DatabaseReference inventoryRef = FirebaseDatabase.instance.ref('inventory');
    DataSnapshot equipments = await inventoryRef.get();

    //checks that some equipment is found
    if(equipments.exists){
        for(final child in equipments.children){
            equipment.add(child.key.toString());
        }
    } else{
        //Error checking (no equipment found)
        equipment.add('No Equipment');
    }
    //returns all found equipment names
    return equipment;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return all categories
Future<List<String>> allCategories() async
{
    //makes the list to use when returning the category names
    var categories = List<String>.filled(0, '', growable: true);

    //sets database to the equipment and then takes a data snapshot
    DatabaseReference inventoryRef = FirebaseDatabase.instance.ref('inventory');
    DataSnapshot equipments = await inventoryRef.orderByChild('category').get();

    //checks that some equipment is found
    if(equipments.exists){
        categories.add(equipments.children.first.child('category').value.toString());

        for(final child in equipments.children){
            if(!categories.contains(child.child('category').value.toString())){
                categories.add(child.child('category').value.toString());
            }
        }
    } else{
        //Error checking (no equipment found)
        categories.add('No Categories');
    }
    //returns all found category names
    return categories;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return all locations
Future<List<String>> allLocations() async
{
    //makes the list to use when returning the storage location names
    var locations = List<String>.filled(0, '', growable: true);

    //sets database to the equipment and then takes a data snapshot
    DatabaseReference inventoryRef = FirebaseDatabase.instance.ref('inventory');
    DataSnapshot equipments = await inventoryRef.orderByChild('storageLocation').get();

    //checks that some equipment is found
    if(equipments.exists){
        locations.add(equipments.children.first.child('storageLocation').value.toString());

        for(final child in equipments.children){
            if(!locations.contains(child.child('storageLocation').value.toString())){
                locations.add(child.child('storageLocation').value.toString());
            }
        }
    } else{
        //Error checking (no equipment found)
        locations.add('No Storage Locations');
    }
    //returns all found storage locations names
    return locations;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return all active requests ids
Future<List<String>> allRequestIDs() async
{
    //makes the list to use when returning the request IDs
    var requestIDs = List<String>.filled(0, '', growable: true);

    //sets database to the requests and then takes a data snapshot
    DatabaseReference requestsRef = FirebaseDatabase.instance.ref('requests');
    DataSnapshot requests = await requestsRef.get();

    //checks that requests are found
    if(requests.exists){
        for(final child in requests.children){
            requestIDs.add(child.key.toString());
        }
    } else{
        //Error checking (no requests found)
        requestIDs.add('No Requests');
    }
    //returns all found request IDs
    return requestIDs;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return all forms ids
Future<List<String>> allFormIDs() async
{
    //makes the list to use when returning the form IDs
    var formIDs = List<String>.filled(0, '', growable: true);

    //sets database to the forms and then takes a data snapshot
    DatabaseReference formsRef = FirebaseDatabase.instance.ref('forms');
    DataSnapshot forms = await formsRef.get();

    //checks that requests are found
    if(forms.exists){
        for(final child in forms.children){
            formIDs.add(child.key.toString());
        }
    } else{
        //Error checking (no requests found)
        formIDs.add('No Forms');
    }
    //returns all found form IDs
    return formIDs;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to return all checkout history ids
Future<List<String>> allHistoryIDs() async
{
    //makes the list to use when returning the checkout history IDs
    var checkoutIDs = List<String>.filled(0, '', growable: true);

    //sets database to the history and then takes a data snapshot
    DatabaseReference historyRef = FirebaseDatabase.instance.ref('checkoutHistory');
    DataSnapshot history = await historyRef.get();

    //checks that some history is found
    if(history.exists){
        for(final child in history.children){
            checkoutIDs.add(child.key.toString());
        }
    } else{
        //Error checking (no history found)
        checkoutIDs.add('No Checkout History');
    }
    //returns all found checkout IDs
    return checkoutIDs;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to edit a user account
Future<String> editUserAccount(
    String username, int uin, String firstName,
    String lastName, String email, int phoneNumber,
    int teamNumber, int courseNumber) async
{
    //Sets database reference to the user being edited and checks that it does exist
    DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
    DataSnapshot oldData = await usersRef.child(username).get();
    if(oldData.exists){
        //if the data exists checks to see if there are any accounts with the email being used
        Query emailQuery = usersRef.orderByChild('email').equalTo(email);
        DataSnapshot emailResult = await emailQuery.get();

        //checks if the email is already on the database
        if (emailResult.exists) {

            //iterates through the accounts where the email matches
            for(final child in emailResult.children){

                //if there is a child with the same email and different username
                if(child.key.toString() != username){
                    //responds invalid email
                    return 'Invalid Email';
                }
            }
        }

        //checks if the UIN is used in a different account
        Query uinQuery = usersRef.orderByChild('uin').equalTo(uin);
        DataSnapshot uinResult = await uinQuery.get();

        //checks if the UIN is already in use
        if (uinResult.exists) {
            //iterates through the accounts where the uin matches
            for(final child in uinResult.children){
                //if there is a child with the same uin and different username
                if(child.key.toString() != username){
                    //responds invalid email
                    return 'Invalid UIN';
                }
            }
        }
        await usersRef.child(username).update({
            'uin': uin,
            'firstName': firstName,
            'lastName': lastName,
            "email": email,
            "phoneNumber": phoneNumber,
        });
        if(oldData.child('adminStatus').value == false){
            await usersRef.child(username).update({
                'courseNumber': courseNumber,
                'teamNumber': teamNumber,
            });
        }
        return 'Updated';

    } else {
        return 'Invalid Username';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function for editing an equipment item in the inventory, Admin only
Future<String> editEquipment(
    String name, int totalAmount,
    String category, String storageLocation) async
{
    //sets reference point to the inventory section
    DatabaseReference equipmentRef = FirebaseDatabase.instance.ref('inventory/$name');
    var oldData = await equipmentRef.get();
    if (oldData.exists){

        int amountAvailable = int.parse(oldData.child('amountAvailable').value.toString());
        int totalChange = int.parse(oldData.child('totalAmount').value.toString()) - totalAmount;
        amountAvailable = amountAvailable - totalChange;
        //checks to ensure no negative values are being passed in
        if(totalAmount > 0 && amountAvailable >= 0 &&
            totalAmount - amountAvailable >= 0) {
            equipmentRef.update({
                'totalAmount': totalAmount,
                'amountAvailable': amountAvailable,
                'category': category,
                'storageLocation': storageLocation,
            });
            return 'Updated';
        } else {
            return 'Invalid Amount';
        }
    } else {
        return 'Invalid Equipment';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to edit a form
Future<String> editForm(String formID, String formName, String info, bool verification) async
{
    //sets a database reference to the form and takes snapshot
    DatabaseReference formRef = FirebaseDatabase.instance.ref('forms/$formID');
    DataSnapshot form = await formRef.get();

    //checks that form exists
    if(form.exists) {
        //Gets the associated user and makes a reference
        DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${form.child('user').value.toString()}');

        //checks to see if the associated user exists
        var dataTest = await userRef.get();
        if(dataTest.exists){
            formRef.update({
                'formName': formName,
                'info': info,
                'verification': verification
            });
            //checks to see if the form name was changed and if so changes in user data
            String oldName = form.child('formName').value.toString();
            if(formName != oldName) {
                userRef.child('forms').child(oldName).remove();
                userRef.child('forms').update({formName: formID});
            }
            return 'Updated';
        } else {
            return 'Invalid User';
        }
    } else {
        return 'Invalid Form ID';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to edit a checkout history
Future<String> editHistory(
    String historyID, int amountOut,
    String adminOut, String timestampOut, int amountIn,
    String adminIn, String timestampIn) async
{
    //sets reference point to the inventory section
    DatabaseReference historyRef = FirebaseDatabase.instance.ref('checkoutHistory/$historyID');
    var oldData = await historyRef.get();
    if (oldData.exists){

        //different logic for if there has been any check-ins
        if(oldData.child('amountIn').exists) {

            //if the history exists it checks to see if the amountOut or amountIn is changed
            if (int.parse(oldData.child('amountOut').value.toString()) != amountOut ||
                int.parse(oldData.child('amountIn').value.toString()) != amountIn) {

                //creates Database reference to the checked out equipment to change amountAvailable also takes snapshot
                DatabaseReference equipmentRef = FirebaseDatabase.instance.ref('inventory/${oldData.child('equipment').value.toString()}');
                DataSnapshot equipment = await equipmentRef.get();

                //sets the original amountAvailable to a new variable
                int amountAvailable = int.parse(equipment.child('amountAvailable').value.toString());

                //the amount changed between old and new, out and in, is saved
                int oldOut = int.parse(oldData.child('amountOut').value.toString()) - int.parse(oldData.child('amountIn').value.toString());
                int newOut = amountOut - amountIn;
                int outChange = newOut - oldOut;

                amountAvailable = amountAvailable - outChange;

                if(amountAvailable < 0 || amountIn > amountOut || amountOut < 1 || amountIn < 0){
                    return 'Invalid Amounts';
                } else {
                    //sends change to the database
                    equipmentRef.update({'amountAvailable': amountAvailable});
                    historyRef.update({
                        'amountOut': amountOut,
                        'adminOut': adminOut,
                        'timestampOut': timestampOut,
                        'amountIn': amountIn,
                        'adminIn': adminIn,
                        'timestampIn': timestampIn,
                    });
                    return 'Updated';
                }
            } else {
                historyRef.update({
                    'adminOut': adminOut,
                    'timestampOut': timestampOut,
                    'adminIn': adminIn,
                    'timestampIn': timestampIn,
                });
                return 'Updated';
            }
        } else {
            //checks to see if the out amount is the same
            if(int.parse(oldData.child('amountOut').value.toString()) != amountOut){
                //creates Database reference to the checked out equipment to change amountAvailable also takes snapshot
                DatabaseReference equipmentRef = FirebaseDatabase.instance.ref('inventory/${oldData.child('equipment').value.toString()}');
                DataSnapshot equipment = await equipmentRef.get();

                //sets the original amountAvailable to a new variable
                int amountAvailable = int.parse(equipment.child('amountAvailable').value.toString());

                //the amount changed between old and new out amounts is saved
                int outChange = amountOut - int.parse(oldData.child('amountOut').value.toString());

                //sets new amount available
                amountAvailable = amountAvailable - outChange;

                //checks that amountAvailable is valid
                if(amountAvailable < 0 || amountOut < 1){
                    return 'Invalid Amounts';
                } else {
                    //sends change to the database
                    equipmentRef.update({'amountAvailable': amountAvailable});
                    historyRef.update({
                        'amountOut': amountOut,
                        'adminOut': adminOut,
                        'timestampOut': timestampOut,
                    });
                    return 'Updated';
                }
            } else {
                historyRef.update({
                    'adminOut': adminOut,
                    'timestampOut': timestampOut,
                });
                return 'Updated';
            }
        }
    } else {
        return 'Invalid History ID';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to remove a user
Future<String> removeUser(String user) async
{
    //Sets a database reference to the user
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$user');
    //creates a variable for data testing
    var dataTest = await userRef.get();
    //checks to see if the username exists
    if(dataTest.exists) {

        //deletes user
        userRef.remove();
        return 'Removed';
    } else {
        return 'Invalid Username';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to remove an equipment
Future<String> removeEquipment(String equipment) async
{
    //Sets a database reference to the equipment
    DatabaseReference equipmentRef = FirebaseDatabase.instance.ref('inventory/$equipment');
    //creates a variable for data testing
    var dataTest = await equipmentRef.get();
    //checks to see if the equipment exists
    if(dataTest.exists) {

        //deletes equipment
        equipmentRef.remove();
        return 'Removed';
    } else {
        return 'Invalid Equipment';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to edit a form
Future<String> removeForm(String formID) async
{
    //sets a database reference to the form and takes snapshot
    DatabaseReference formRef = FirebaseDatabase.instance.ref('forms/$formID');
    DataSnapshot form = await formRef.get();

    //checks that form exists
    if(form.exists) {
        //Gets the associated user and makes a reference
        DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${form.child('user').value.toString()}');

        //checks to see if the associated user exists
        var dataTest = await userRef.get();
        if(dataTest.exists){
            formRef.remove();
            userRef.child('forms').child(form.child('formName').value.toString()).remove();
            return 'Removed';
        } else {
            return 'Invalid User';
        }
    } else {
        return 'Invalid Form ID';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function to remove a checkout history
Future<String> removeHistory(String historyID) async
{
    //Sets a database reference to the history
    DatabaseReference historyRef = FirebaseDatabase.instance.ref('checkoutHistory/$historyID');
    //creates a variable for data testing
    var dataTest = await historyRef.get();
    //checks to see if the history exists
    if(dataTest.exists) {

        //deletes history
        historyRef.remove();
        return 'Removed';
    } else {
        return 'Invalid History ID';
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Function for removing form requirements for an equipment, admin only function
Future<String> removeFormRequirement(
    String formName, String equipmentName) async
{
    //Sets a database reference to the equipment
    DatabaseReference equipmentRef = FirebaseDatabase.instance.ref('inventory/$equipmentName');
    //creates a variable for data testing
    var dataTest = await equipmentRef.get();
    //checks to see if the equipment exists
    if(dataTest.exists) {
        //tests for the formName in the equipment
        dataTest = await equipmentRef.child('forms/$formName').get();
        if (dataTest.exists) {
            //removes the form from the equipment
            equipmentRef.child('forms/$formName').remove();
            return 'Form Removed';
        } else {
            //The equipment already doesn't require the form
            return 'Form Not Required';
        }
    } else {
        return 'Invalid Equipment';
    }
}