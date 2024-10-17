import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScalableMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScalableMapState();
  }
}

class _ScalableMapState extends State<ScalableMap> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _position = const Offset(100, 100);
  Offset _previousPosition = const Offset(100, 100);

  double _lat = 0;
  double _long = 0;

  @override
  void initState() {
    super.initState();

    initPosition().then((value) {
      setState(() {
        _lat = value.latitude;
        _long = value.longitude;
      });
    });
  }

  Future<Position> initPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _previousScale = _scale;
        _previousPosition = details.focalPoint - _position;
      },
      onScaleUpdate: (details) {
        setState(() {
          // Scale the widget
          _scale = _previousScale * details.scale;

          // Update the position to allow movement
          _position = details.focalPoint - _previousPosition;
        });
      },
      onScaleEnd: (details) {
        _previousScale = _scale;
      },
      child: Stack(
        children: [
          Positioned(
            left: _position.dx,
            top: _position.dy,
            child: Transform.scale(
              scale: _scale,
              child: _lat != 0 && _long != 0
                  ? Container(
                      padding: EdgeInsets.only(top: 10),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: GoogleMap(
                        mapType: MapType.satellite,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(_lat, _long),
                          zoom: 14.4746,
                        ),
                      ),
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
