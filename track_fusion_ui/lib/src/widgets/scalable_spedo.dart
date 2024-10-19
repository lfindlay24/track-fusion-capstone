import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:track_fusion_ui/globals.dart' as globals;

class ScalableSpedo extends StatefulWidget {

  final Offset defaultPosition;

  const ScalableSpedo({super.key, required this.defaultPosition});

  @override
  State<StatefulWidget> createState() {
    return _ScalableSpedoState();
  }
}

class _ScalableSpedoState extends State<ScalableSpedo> {
  double _scale = 0.5;
  double _previousScale = 1.0;
  Offset _position = const Offset(100, 100);
  Offset _previousPosition = const Offset(100, 100);
  double _speed = 0;

  @override
  void initState() {
    super.initState();

    _position = widget.defaultPosition;

    const LocationSettings locationSettings = LocationSettings(
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: globals.isRaceModeLocked ? null : (details) {
        _previousScale = _scale;
        _previousPosition = details.focalPoint - _position;
      },
      onScaleUpdate: globals.isRaceModeLocked ? null : (details) {
        setState(() {
          // Scale the widget
          _scale = _previousScale * details.scale;

          // Update the position to allow movement
          _position = details.focalPoint - _previousPosition;
        });
      },
      onScaleEnd: globals.isRaceModeLocked ? null : (details) {
        _previousScale = _scale;
      },
      child: Stack(
        children: [
          Positioned(
            left: _position.dx,
            top: _position.dy,
            child: Transform.scale(
              scale: _scale,
              child: SfRadialGauge(
                title: GaugeTitle(
                    text: 'Speedometer',
                    textStyle:
                        const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
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
                                    fontSize: 25, fontWeight: FontWeight.bold))),
                        angle: 90,
                        positionFactor: 0.5)
                  ])
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
