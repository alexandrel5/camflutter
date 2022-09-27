import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera/take_picture_screen.dart';

void main() async {
  List<CameraDescription> cameras = await availableCameras();
  runApp(MyApp(camera: cameras));
}

class MyApp extends StatelessWidget {
  late List<CameraDescription> camera;
  MyApp({Key? key, required List<CameraDescription> camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TakePictureScreen(camera: camera.last),
    );
  }
}
