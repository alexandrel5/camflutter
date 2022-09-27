import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'painter_arc.dart';

import 'package:dio/dio.dart' as dio;

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.

            //return CameraPreview(_controller);
            return Stack(alignment: Alignment.center, children: <Widget>[
              Transform.scale(
                scale: 1,
                child: Center(
                  child: CameraPreview(_controller),
                ),
              ),
              Center(
                child: PainterArco(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.40,
                ),
              ),
            ]);

            /*
            //Inverter Imagens
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: CameraPreview(_controller),
            );
            */
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final XFile image = await _controller.takePicture();

            print(image.path);
            Uint8List bytes = await image.readAsBytes();
            String base64Image = base64.encode(bytes);

            print(base64Image);
            print(base64Image.length);
            print(base64Image.substring(base64Image.length - 4));

            if (!mounted) return;

            //var di = dio.Dio();

            //var response = await di.post('http://192.168.255.181:5000/json-base64', data: {'language': 'wendu'});
            //var response = await di.post('https://reqres.in/api/users',data: {'language': base64Image});

            //Get.toNamed(caminho);

          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void postDiob64() async {}
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    Uint8List image;
    String base64Image2;
    File(imagePath).readAsBytes().then((blob) {
      image = blob;
      base64Image2 = base64.encode(image);
      print(base64Image2);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
