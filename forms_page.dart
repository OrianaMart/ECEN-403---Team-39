import 'package:flutter/material.dart';
import 'database_functions.dart';
import 'navigator_drawer.dart';
import 'equipment_page.dart';
import 'request_detail_page.dart';
import 'history_detail_page.dart';
import 'home_page.dart';
import 'Data.dart' as user;

class FormsPage extends StatefulWidget {
  const FormsPage({Key? key}) : super(key: key);
  @override
  FormsPageState createState() {
    return FormsPageState();
  }
}

class FormsPageState extends State<FormsPage> {
  String pageName = 'Smart Inventory';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Creates smart inventory app bar at top
        appBar: AppBar( //creates top bar of the app that includes navigation widget
          title: Text(
            pageName,
            style: const TextStyle(
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

        //Creates body of the page
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                //Header for page
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Forms',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Follow the steps below to properly fill out the required forms for equipment checkout.',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF963e3e),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Steps:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),

                      Text(
                        '1) Print required form',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),

                      Text(
                        '2) Fill out required form',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),

                      Text(
                        '3) Turn in form to your TA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
