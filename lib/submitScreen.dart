import 'dart:io';

import 'package:dotebook/summaryScreen.dart';
import 'package:flutter/material.dart';
import 'package:dotebook/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:camera/camera.dart';

class SubmitScreen extends StatefulWidget {
  final CameraDescription camera;

  const SubmitScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  SubmitScreenState createState() => SubmitScreenState();
}

class SubmitScreenState extends State<SubmitScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  final String pathPrefix = "_dotePhotos_";
  List<String> path = [null, null];
  int pidx = 0;

  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
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

  Widget _buildImageColumn() => Container(
    child: Column(
      children: [
        Container(
          height: 200,
          child: _buildImageRow(),
        ),
      ],
    ),
  );

  Widget _buildImageRow() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded (
        child:_buildButton(0),
      ),
      Expanded (
        child:_buildButton(1),
      )
    ],
  );

  Widget _buildButton(int picIdx) => FlatButton(
    child: path[picIdx] == null ? Icon(Icons.camera_alt) : Image.file(File(path[picIdx])),
    onPressed: () async {
      if (path[picIdx] != null) {
        return;
      }
      try {
        // Ensure that the camera is initialized.
        await _initializeControllerFuture;
        if (Global.path == null) {
          Global.path = join((await getTemporaryDirectory()).path,
                            pathPrefix+'${DateTime.now()}'.substring(20));
        }
        path[picIdx] = Global.getPath(pidx++, true);
        await _controller.takePicture(path[picIdx]);
        setState(() {});
      } catch (e) {
        print(e);
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
      ),
      body: ListView (
        children: <Widget>[
          Text('Title', style: Theme.of(context).textTheme.display1),
          TextField (
            controller: _titleController,
          ),
          Text('Price', style: Theme.of(context).textTheme.display1),
          TextField (
            controller: _priceController,
          ),
          Text('Description', style: Theme.of(context).textTheme.display1),
          TextField (
            controller: _descController,
            keyboardType: TextInputType.multiline,
          ),
          _buildImageColumn(),
          RaisedButton (
            onPressed: () {
              final param = DoteParam(_titleController.text,_priceController.text,_descController.text);
              Navigator.pop(context,
                  param);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}