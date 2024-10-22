import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/g_force.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/race_track_selector.dart';
import '../widgets/scalable_spedo.dart';
import '../widgets/scalable_map.dart';
import 'package:track_fusion_ui/globals.dart' as globals;
import '../models/recording_event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RaceMode extends StatefulWidget {
  static const routeName = '/racemode';

  @override
  State<StatefulWidget> createState() => _RaceState();
}

class _RaceState extends State<RaceMode> {
  // final GoogleMapController _controller =
  //     GoogleMapController();

  double _speed = 0;
  Position? userPostion;
  Offset position = Offset(100, 100);

  RaceTrack? selectedTrack;

  LocationPermission permission = LocationPermission.denied;

  GoogleMapController? controller;

  bool isRecording = false;

  int eventCount = 0;

  @override
  void initState() {
    super.initState();

    //Enforce landscape mode while in this page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
      timeLimit: Duration(seconds: 10),
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((position) {
      debugPrint("New Speed${position.speed}");

      setState(() {
        userPostion = position;
        _speed = double.parse((position.speed * 2.23694)
            .toStringAsFixed(1)); // 2.23694 m/s to mph
      });
    });
  }

  @override
  void dispose() {
    // Unlock and allow free rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void getGeolocatorPermission() async {
    permission = await Geolocator.requestPermission();
  }

  Future<Position> initPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<void> _goToRaceTrack(GoogleMapController controller) async {
    if (selectedTrack != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(selectedTrack!.lat, selectedTrack!.long),
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: RaceTrackSelector(
        onTrackSelected: (track) {
          setState(() {
            selectedTrack = track;
            _goToRaceTrack(controller!);
            debugPrint("New Track: ${selectedTrack.toString()}");
          });
        },
      ),
      // appBar: CustomAppBar(
      //   title: "Race Mode",
      // ),rr
      body: Stack(
        children: [
          Builder(
            builder: (context) => Positioned(
              top: 15,
              left: 15,
              child: IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu),
              ),
            ),
          ),
          Builder(
            builder: (context) => Positioned(
              top: 15,
              right: 15,
              child: IconButton(
                onPressed: () {
                  if (globals.userId == '') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please sign in to record'),
                      ),
                    );
                    return;
                  }
                  if (isRecording) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Recording Stopped'),
                      ),
                    );

                    saveRecording();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Recording Started'),
                      ),
                    );
                  }

                  setState(() {
                    isRecording = !isRecording;
                  });
                },
                icon: isRecording
                    ? const Icon(Icons.stop)
                    : const Icon(Icons.circle, color: Colors.red),
              ),
            ),
          ),
          ScalableSpedo(
            defaultPosition: Offset(
              MediaQuery.sizeOf(context).width * 1 / 20,
              MediaQuery.sizeOf(context).height * 1 / 20,
            ),
          ),
          //Default Position sets around the top right corner of the screen no matter the screen size
          GForce(
              onGForceChange: (event) {
                if (isRecording) {
                  eventCount++;
                  // Save the event every 8 events or about 4 times a second
                  if (eventCount == 8) {
                    globals.recordingEvents.add(RecordingEvent(
                      speed: _speed,
                      gForce: event,
                      lat: (userPostion != null) ? userPostion!.latitude : 0.0,
                      long:
                          (userPostion != null) ? userPostion!.longitude : 0.0,
                    ));
                    eventCount = 0;
                  }
                  // Save the event
                }
              },
              width: 150,
              height: 150,
              defaultPosition: Offset(MediaQuery.sizeOf(context).width * 4 / 5,
                  MediaQuery.sizeOf(context).height * 1 / 10)),
          ScalableMap(
            width: 150,
            height: 150,
            defaultPosition: const Offset(100, 100),
            lat: (selectedTrack != null) ? selectedTrack!.lat : 0.0,
            long: (selectedTrack != null) ? selectedTrack!.long : 0.0,
            controller: controller,
          ),
        ],
      ),
    );
  }

  void saveRecording() async {
    var postBody = {
      "userId": globals.userId,
      "raceTime": DateTime.now().toIso8601String(),
      "raceDistance": 15.5,
      "raceLocation": "new Location",
      "recordingEvents": [
        for (var event in globals.recordingEvents)
          {
            "speed": event.speed,
            "gForce": {
              "x": event.gForce.x,
              "y": event.gForce.y,
              "z": event.gForce.z,
            },
            "lat": event.lat,
            "long": event.long,
            "time": event.time.toIso8601String(),
          }
      ]
    };

    final response = await http.post(
      Uri.parse('${globals.apiBasePath}/raceData'),
      body: json.encode(postBody),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }
}
