//import 'dart:developer';
import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
//import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ml_testapp_v2/main.dart';

/*
*Author: Oriana V Martin
* UIN: 527008754
* Date: October 16,2023
*
* Description:
- Imported necessary packages for camera, image processing, and TensorFlow Lite.
- Created a `ScanController` class with properties and methods to manage camera, model, and object recognition.
- Initialize the camera and model when the controller is initiated.
- Periodically check for a model prediction and close the camera if a prediction is made.
- Define methods for camera initialization, model loading, camera/model reinitialization, object recognition, and image capture.
- Comments and documentation added to the code for clarity.
* */


class ScanController extends GetxController {

  //Declare variables and initialize them
  late List<CameraDescription> _cameras; //List of available camera descriptions
  late CameraController _cameraController; //Camera controller for camera management
  final RxBool _isInitialized = RxBool(false); //Reactive variable to track camera initialization
  CameraImage? _cameraImage; //Represents the current camera image
  final RxList<Uint8List> _imageList = RxList([]); //A list of Uint8List for images
  int _imageCount = 0; //Counter for tracking images
  final RxString modelPred = ''.obs; //Reactive variable to store model predictions
  Timer? conditionCheckTimer; //Timer for periodic checks
  final Duration _checkInterval = Duration(seconds: 2); //Adjust interval as needed
  bool isCameraClosed = false; //Flag to indicate if the camera is closed
  bool isScanning = false; //Flag to indicate if scanning is in progress

  //Getter methods
  CameraController get cameraController => _cameraController; //Retrieve the camera controller
  bool get isInitialized => _isInitialized.value; //Check if the camera is initialized
  List<Uint8List> get imageList => _imageList; //Retrieve the list of images

  @override
  //This method is used to dispose of resources
  void dispose() {
    _isInitialized.value = false; //Reset initialization flag
    conditionCheckTimer?.cancel(); //Cancel the condition check timer if it is still active
    if (_cameraController != null) {
      if (_cameraController.value.isInitialized) {
        //If the camera is initialized, stop the image stream
        _cameraController.stopImageStream().then((_) {
          //Dispose of the camera controller
          _cameraController.dispose().then((_) {
            //Close the Tflite model
            Tflite.close();
          });
        });
      }
    }
    super.dispose(); //Call the base class's dispose method
  }

  //A flag to check if the camera is initialized
  bool _cameraInitialized = false;

  // Separate method to start the image stream and set up object recognition callback
  void startImageStream() {
    if (_cameraController.value.isInitialized) {
      isScanning = true; //Set scanning flag to true
      _cameraController.startImageStream((image) {
        _imageCount++;

        //Process every 10th image to improve efficiency of the image stream
        if (_imageCount % 10 == 0) {
          _imageCount = 0;
          _objectRecognition(image); //Call the object recognition method
        }
      });
    }
  }

  //Initialize the camera for image capture
  Future<void> _initCamera() async {
    _cameras = await availableCameras(); //Get the available camera devices
    //Initialize the camera controller with the first available camera
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.bgra8888);
    try {
      await _cameraController.initialize(); //Attempt to initialize the camera

      //Set the camera initialization flags
      _cameraInitialized = true;
      _isInitialized.value = true;
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    }
  }

  //This method initializes the TensorFlow Lite model for inference
  Future<void> _initTFlite() async {
    //Load the TensorFlow Lite model from the assets folder
    String? res = await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
    //Note: In the parameters, 'model' specifies the model file,
    //'labels' specifies the labels file, 'isAsset' indicates that the model is stored as an asset,
    //'numThreads' sets the number of threads for model inference,
    //and 'useGpuDelegate' specifies whether to use GPU acceleration if it is available.
  }

  //This method reinitializes the camera and model for scanning
  Future<void> reinitializeCameraAndModel() async {
    try {
      //Stop the image stream and dispose of the camera controller
      await _cameraController.stopImageStream();
      await _cameraController.dispose();
      isScanning = false; //Set scanning flag to false
    } catch (e) {
      print('Error stopping and disposing the camera: $e');
      //Handle any errors that occur during camera shutdown
    }

    //Reset modelPred value
    modelPred.value = '';

    // Reinitialize the camera and model
    _initCamera().then((_) {
      isScanning = false;
      isCameraClosed = false;
      // Now that the camera is initialized, the model can be safely started
      _initTFlite();
    });
  }

  @override
  //This method is called when the controller is initialized
  void onInit() {
    startCameraAndModel(); //Initialize the camera and model

    //Start the periodic check for 'modelPred' condition
    conditionCheckTimer = Timer.periodic(_checkInterval, (Timer timer) {
      //Check the condition and close the camera if 'modelPred' has a value
      if(modelPred.value.isNotEmpty) {
        closeCamera(); //Close the camera if 'modelPred' has a value
      }
    });

    super.onInit(); //Call the superclass's initialization method
  }

  //This method starts the camera and model
  void startCameraAndModel() {
    if (!_cameraInitialized) {
      //If the camera is no initialized, initialize it and then start the model
      _initCamera().then((_){
        //Now that the camera is initialized, the model can be safely started
        _initTFlite();
      });
    } else {
      //Camera is already initialized, so just start the model
      _initTFlite();
    }
  }

  //This method performs object recognition using the TensorFlow Lit model
  Future<void> _objectRecognition(CameraImage cameraImage) async {
    try {
      //Check if the camera is not streaming images or if the camera is closed
      if (!_cameraController.value.isStreamingImages || isCameraClosed) {
        return;
      }

      //Run the model on the camera image
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: cameraImage.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          // required
          imageHeight: cameraImage.height,
          imageWidth: cameraImage.width,
          imageMean: 0.0,
          // defaults to 127.5
          //imageStd: 127.5,
          // defaults to 127.5
          rotation: 90,
          // defaults to 90, Android only
          numResults: 14,
          // defaults to 5
          threshold: 0.01,
          // defaults to 0.1
          asynch: true // defaults to true
      );
      if (!isCameraClosed && recognitions != null) {
        // Multiply the confidences by 10
        for (var prediction in recognitions) {
          prediction['confidence'] *= 10;
        }

        // Filter predictions based on confidence between 0.0 and 1.00
        var filteredPredictions = recognitions
            .where((prediction) => prediction['confidence'] >= 0.0 && prediction['confidence'] <= 1.00)
            .toList();

        // Sort the filtered predictions by confidence in descending order
        filteredPredictions.sort((a, b) =>
            b['confidence'].compareTo(a['confidence']));

        // Print the sorted list of predictions
        print('Sorted Predictions:');
        for (var prediction in filteredPredictions) {
          print('Label: ${prediction['label']}, Confidence: ${prediction['confidence']}');
        }

        // Extract the label with the highest confidence
        if (filteredPredictions.isNotEmpty) {
          modelPred.value = filteredPredictions[0]['label'];
          print('Model Prediction: ${modelPred.value}');
        } else {
          //Reset modelPred value
          modelPred.value = '';
        }
      }
    } catch (e) {
      print('Error running Tensorflow Lite Model: $e');
    }
  }

  //This method closes the camera and performs related actions
  void closeCamera() async {
    print('Closing camera: modelPred=${modelPred.value}');
    //Check if modelPred has a value
    if (modelPred.value.isNotEmpty) {
      isCameraClosed = true; //Set flag to indicate that the camera is closed
      //Attempt to stop the image stream
      try {
        await _cameraController!.stopImageStream();
      } catch (e) {
        print('Error stopping image stream: $e');
      }

      //Attempt to dispose of the camera
      try {
        await _cameraController!.dispose();
      } catch (e) {
        print('Error disposing camera: $e');
      }

      // Reinitialize the camera and model after closing
      //reinitializeCameraAndModel();

      //Navigate to ScanPage
      Get.off(() => ScanPage());
      print('Camera closed and navigated back to ScanPage');
    } else {
      print('Camera not closed because modelPred is empty');
    }
  }

  //This method captures an image from the camera and stores it in the image list
  void capture() {
    if(_cameraImage != null) {
      //Convert the CameraImage into an image
      img.Image image = img.Image.fromBytes(
          _cameraImage!.width,
          _cameraImage!.height,
          _cameraImage!.planes[0].bytes,
          format: img.Format.bgra,
      );
      //Encode the image as a JPEG and store it as a Uint8List
      Uint8List list = Uint8List.fromList(img.encodeJpg(image));

      //Add the captured image to the image list
      _imageList.add(list);
      _imageList.refresh();
    }
  }

}