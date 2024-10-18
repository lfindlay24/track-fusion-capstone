import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:track_fusion_ui/globals.dart' as globals;
import '../widgets/custom_app_bar.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
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

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      // distanceFilter: 100,
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

  void getGeolocatorPermission() async {
    permission = await Geolocator.requestPermission();
  }

  Future<Position> initPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<void> _goToRaceTrack(GoogleMapController controller) async {
    // final GoogleMapController controller = await controller.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: RaceTrackSelector(
        onTrackSelected: (track) {
          setState(() {
            selectedTrack = track;
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
              top: 0,
              left: 0,
              child: IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu),
              ),
            ),
          ),
          ScalableSpedo(),
          //Default Position sets around the top right corner of the screen no matter the screen size
          GForce(
              width: 150,
              height: 150,
              defaultPosition: Offset(MediaQuery.sizeOf(context).width * 4 / 5,
                  MediaQuery.sizeOf(context).height * 1 / 10)),
          ScalableMap(
            width: 150,
            height: 150,
            defaultPosition: Offset(MediaQuery.sizeOf(context).width * 1 / 10,
                MediaQuery.sizeOf(context).height * 1 / 10),
            lat: (selectedTrack != null) ? selectedTrack!.lat : 0.0,
            long: (selectedTrack != null) ? selectedTrack!.long : 0.0,
            controller: controller,
          ),
        ],
      ),
    );
  }
}
