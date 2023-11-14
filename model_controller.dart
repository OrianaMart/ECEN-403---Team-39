//Import the needed libraries
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'navigator_drawer.dart';
import 'equipment_page.dart';
import 'Data.dart' as user;

import 'internet_checker.dart';

/*
*Author: Oriana V Martin
* UIN: 527008754
* Date: October 30,2023
*
* Description:
* This code creates a flutter page for image classification,
* where users can capture photos or select images from their gallery.
* The selected image is then processed using a pre-trained machine learning model,
* and the results are displayed on the screen.
* */

//Define a StatefulWidget for the scanning page
class ScanningPage extends StatefulWidget {
  const ScanningPage({Key? key}) : super(key: key);
  @override
  State<ScanningPage> createState() => _ScanningPage();
}

//Define the _ScanningPage class which extends the StatefulWidget
class _ScanningPage extends State<ScanningPage> {
  //Define the state variables
  bool loading = true; //A flag to check if the app is loading
  File? _image; //The selected image file
  List<dynamic>? _output; //List to store the model predictions
  final imagepicker = ImagePicker(); //Image picker instance from the model
  String modelPred = ''; //The prediction label from the model
  String modelConf = ''; //The confidence of the prediction

  @override
  void initState() {
    super.initState();
    //Load the machine learning model when the page is initialized
    loadmodel().then((value) {
      setState(() {});
    });
  }

  //Function to perform image detection using the loaded model
  detectimage(File image) async {
    var prediction = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _output = prediction;
      modelPred = (_output![0]['label']).toString().substring(2);
      modelConf = ((_output![0]['confidence']).toString());
      loading = false;
    });
  }

  //Function to load the machine learning model from the assets folder
  loadmodel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  //Function for instance disposal
  @override
  void dispose() {
    super.dispose();
  }

  //Function to capture an image using the device's camera
  pickImageCamera() async {
    var image = await imagepicker.pickImage(source: ImageSource.camera, imageQuality: 25);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectimage(_image!);
  }

  //Function to select an image from the device's gallery
  pickImageGallery() async {
    var image = await imagepicker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectimage(_image!);
  }

  @override
  Widget build(BuildContext context) {
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
                  //checks to see if the app is still connected to the internet
                  connectionCheck(context);

                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),

        //Navigation drawer code is called here
        drawer: const NavigatorDrawer(),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              // Use SizedBox to add spacing
              const SizedBox(
                height: 15,
                width: 150,
              ),
              Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Machine Learning',
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
                      'Upload image or scan Equipment',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(
                              0xFFdedede), // changes color of the text
                          backgroundColor: const Color(
                              0xFF963e3e),
                      ),
                        child: Text('Capture',
                            style: GoogleFonts.roboto(fontSize: 18)),

                        onPressed: () {
                          pickImageCamera(); //Trigger image capture from camera
                        }),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(
                              0xFFdedede), // changes color of the text
                          backgroundColor: const Color(
                              0xFF963e3e),
                        ),
                        child: Text('Gallery',
                            style: GoogleFonts.roboto(fontSize: 18)),
                        onPressed: () {
                          pickImageGallery(); //Trigger image selection from the gallery
                        }),
                  ),
                  //Instructions for image capture
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Tip: For accurate classification, capture an image with only one item in frame'),
                  ),
                ],
              ),
              loading != true
                  ? Column(
                      children: [
                        Container(
                          height: 220,
                          padding: const EdgeInsets.all(15),
                          child: Image.file(_image!),
                        ),
                        _output != null
                            ? Text(
                                'Category: $modelPred', //Display predicted category
                                style: GoogleFonts.roboto(fontSize: 18))
                            : const SizedBox
                                .shrink(), //Use SizedBox.shrink() to create an empty space
                        _output != null
                            ? Text(
                                'Confidence: $modelConf', //Display prediction confidence
                                style: GoogleFonts.roboto(fontSize: 18))
                            : const SizedBox.shrink(),

                        _output != null
                            ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(
                                  0xFFdedede), // changes color of the text
                              backgroundColor: const Color(
                                  0xFF963e3e),
                            ),
                                onPressed: () {
                                  //checks to see if the app is still connected to the internet
                                  connectionCheck(context);

                                  user.mlCategory = modelPred;

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EquipmentPage(),
                                      ));
                                },
                                child: const Text('Next'))
                            : const SizedBox.shrink(),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        )));
  }
}
