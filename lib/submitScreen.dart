import 'dart:io';
import 'package:dotebook/summaryScreen.dart';
import 'package:flutter/material.dart';
import 'package:dotebook/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:camera/camera.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class SubmitScreen extends StatefulWidget {
  final CameraDescription camera;
  final LocationData location;

  const SubmitScreen({
    Key key,
    @required this.camera,
    @required this.location,
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

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final Map<String, Marker> _markers = {};

  // GoogleMap Start
  GoogleMapController mapController;
  //37.399757, -122.043515
  LatLng _center = LatLng(37.399757, -122.043515);
  LatLng _userLocation;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  // GoogleMap End

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

    // Location Service
    _getLocation();
    _getMarker();

    // NOTIFICATION
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: mySelectNotification);
  }

  void _getLocation() async {
    try {
      _userLocation = LatLng(widget.location.latitude, widget.location.longitude);
    } catch (e) {
      _userLocation = null;
    }
  }

  void _getMarker() {
    _markers.clear();
    final marker = Marker(
      markerId: MarkerId("curr_loc"),
      position: _userLocation == null ? _center : LatLng(_userLocation.latitude, _userLocation.longitude),
      infoWindow: InfoWindow(title: 'Your Location'),
    );
    _markers["Current Location"] = marker;
  }

  Future _showNotificationWithoutSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        playSound: false, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Post',
      'Entry added to dotebook.',
      platformChannelSpecifics,
      payload: 'No_Sound',
    );
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
          SizedBox (
            width: 200,
            height: 160,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _userLocation == null ? _center : _userLocation,
                zoom: 15.0,
              ),
              markers: _markers.values.toSet(),
            ),
          ),
          RaisedButton (
            onPressed: () {
              _showNotificationWithoutSound();
              final param = DoteParam(_titleController.text,
                                      _priceController.text,
                                      _descController.text,
                                      _userLocation.latitude,
                                      _userLocation.longitude);
              Navigator.pop(context,
                  param);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }


  Future mySelectNotification(String payload) async {
    showDialog(
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
}