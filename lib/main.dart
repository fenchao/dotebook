import 'package:flutter/material.dart';
import 'package:dotebook/homeScreen.dart';
import 'package:dotebook/submitScreen.dart';
import 'package:dotebook/summaryScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:camera/camera.dart';
import 'package:location/location.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  final location = await new Location().getLocation();

  runApp(
      MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/submit': (context) => SubmitScreen(camera: firstCamera, location: location),
          '/summary': (context) => SummaryScreen(),
        },
      )
  );
}

