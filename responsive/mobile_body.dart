import 'package:flutter/material.dart';

class MyMobileBody extends StatelessWidget {
  const MyMobileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(15.0),
          child: AspectRatio(
            aspectRatio: (16 / 9),
            child: Container(
              color: Colors.amber[400],
              child: Center(
                child: Text(
                  'Active Request List',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          ),
          ElevatedButton(
              onPressed: () {},
              child: Text('New Request'),
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Padding(padding: const EdgeInsets.all(15.0),
            child: AspectRatio(
              aspectRatio: (16 / 9),
              child: Container(
                color: Colors.amber[400],
                child: Center(
                  child: Text(
                    'Active Checkout List',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        ),
      );
  }
}

