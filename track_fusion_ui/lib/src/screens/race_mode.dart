import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/g_force.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/race_track_selector.dart';
import '../widgets/scalable_spedo.dart';
import '../widgets/scalable_map.dart';

class RaceMode extends StatefulWidget {
  static const routeName = '/racemode';

  @override
  State<StatefulWidget> createState() => _RaceState();
}

class _RaceState extends State<RaceMode> {
  // final GoogleMapController _controller =
  //     GoogleMapController();

  double _speed = 0;
  Offset position = Offset(100, 100);

  RaceTrack? selectedTrack;

  LocationPermission permission = LocationPermission.denied;

  GoogleMapController? controller;

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
          ScalableSpedo(
            defaultPosition: Offset(
              MediaQuery.sizeOf(context).width * 1 / 20,
              MediaQuery.sizeOf(context).height * 1 / 20,
            ),
          ),
          //Default Position sets around the top right corner of the screen no matter the screen size
          GForce(
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
}
