import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

//function to check if there is connection or not
Future<void> connectionCheck(BuildContext context) async {
  if(await InternetConnectionChecker().hasConnection) {
    return;
  } else {
    internetPopUp(context);
  }
}

//Function to make a pop out dialogue box appear when internet connection is lost
Future<void> internetPopUp(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Internet Connection Lost'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[Text('Please reconnect to the iternet and then retry the connection.')],
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                if(await InternetConnectionChecker().hasConnection) {
                 Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('Retry')),
        ],
      );
    },
  );
}