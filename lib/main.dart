import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera/take_picture_screen.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TakePictureScreen(camera: cameras.last),
    );
  }
}
