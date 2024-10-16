import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:track_fusion_ui/globals.dart' as globals;
import '../widgets/custom_app_bar.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../widgets/g_force.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RaceMode extends StatefulWidget {
  static const routeName = '/racemode';

  @override
  State<StatefulWidget> createState() => _RaceState();
}

class _RaceState extends State<RaceMode> {
  // final GoogleMapController _controller =
  //     GoogleMapController();

  double _speed = 0;

  LocationPermission permission = LocationPermission.denied;

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
    Geolocator.getPositionStream(locationSettings: locationSettings).listen((position) {
      debugPrint("New Speed${position.speed}");
      setState(() {
        _speed = double.parse(
            (position.speed * 2.23694).toStringAsFixed(1)); // 2.23694 m/s to mph
      });
    });
  }

  void getGeolocatorPermission() async {
    permission = await Geolocator.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(
      //   title: "Race Mode",
      // ),rr
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: SfRadialGauge(
                    title: GaugeTitle(
                        text: 'Speedometer',
                        textStyle: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    axes: <RadialAxis>[
                      RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
                        GaugeRange(
                            startValue: 0,
                            endValue: 50,
                            color: Colors.green,
                            startWidth: 10,
                            endWidth: 10),
                        GaugeRange(
                            startValue: 50,
                            endValue: 100,
                            color: Colors.orange,
                            startWidth: 10,
                            endWidth: 10),
                        GaugeRange(
                            startValue: 100,
                            endValue: 150,
                            color: Colors.red,
                            startWidth: 10,
                            endWidth: 10)
                      ], pointers: <GaugePointer>[
                        NeedlePointer(value: _speed)
                      ], annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Container(
                                child: Text('MPH\n$_speed',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold))),
                            angle: 90,
                            positionFactor: 0.5)
                      ])
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: GForce(
                    width: 150,
                    height: 150,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10),
              margin: EdgeInsets.only(left: 10, right: 10),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.42796133580664, -122.085749655962),
                  zoom: 14.4746,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
