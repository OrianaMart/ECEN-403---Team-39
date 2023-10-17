import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ml_testapp_v2/controllers/scan_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    title: 'ML Nav',
    home: ModelPage(),
  ));
}


class ModelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => ScanPage()); // Navigate to ScanPage
            },
            child: Text('Open Scan Page'),
          ),
        ),
      ),
    );
  }
}


class ScanPage extends StatelessWidget {
  final ScanController scanController = Get.put(ScanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (scanController.isScanning) {
                  //Send an error snackbar when scanning is in progress
                  Get.snackbar(
                    'Error',
                    'Scan has not been reset. Please reset the scan first.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: Duration(seconds: 3),
                  );
                } else {
                  // Trigger camera capture or start image stream here
                  Get.to(CameraView());
                  scanController.startImageStream();
                }
              },
              child: Text('Scan Item'),
            ),
            ElevatedButton(
              onPressed: () {
                // Reinitialize the camera and model
                scanController.reinitializeCameraAndModel();
              },
              child: Text('Reset Scan'),
            ),
            Obx(
                  () => Text('Model Prediction: ${scanController.modelPred.value}'),
            )]
        ),
      ),
    );
  }
}

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ScanController>(builder: (controller) {
      if(!controller.isInitialized) {
        return Container();
      }
      return SizedBox(
          height: Get.height,
          width: Get.width,
          child: CameraPreview(controller.cameraController));
    }
    );
  }
}

/*class MLEquipmentCheck extends StatelessWidget {
  final ScanController scanController = Get.put(ScanController());

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Model Prediction: '),
          GetX<ScanController>(
              builder: (controller) => Text(
                controller.modelPred.value,
              )),
          TextField(
            onChanged: (value){
              scanController.modelPred(value);
            },
            readOnly: true,
          ),
          ElevatedButton(
          child: const Text('Item Scan'),
            onPressed: () {
            Get.to(ModelPage());
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ModelPage()),
                  );*/
            }
          )]
      ),
    );
  }
}*/

/*class ModelPage extends StatelessWidget {
  final ScanController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ScanController());
    return GetMaterialApp(
      title: 'Equipment Checker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const CameraView(),
    );
  }
}*/

  // This widget is the root of your application.
 /* @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ScanController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const CameraView(),
    );
  }
}*/
