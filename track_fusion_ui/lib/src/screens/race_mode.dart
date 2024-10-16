import 'package:flutter/material.dart';
import 'package:track_fusion_ui/globals.dart' as globals;
import '../widgets/custom_app_bar.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../widgets/g_force.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RaceMode extends StatefulWidget {
  static const routeName = '/racemode';

  @override
  State<StatefulWidget> createState() => _RaceState();
}

class _RaceState extends State<RaceMode> {
  double _speed = 0;

  @override
  void initState() {
    super.initState();
    //Enforce landscape mode while in this page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // Geolocator.getPositionStream().listen((position) {
    //   setState(() {
    //     _speed = position.speed;// This is your speed
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Race Mode",
      ),
      body: Center(
        child: Row(
          children: [
            Container(
              width: 300,
              height: 300,
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
                            child: const Text('90.0',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                        angle: 90,
                        positionFactor: 0.5)
                  ])
                ],
              ),
            ),
            GForce(),
          ],
        ),
      ),
    );
  }
}
