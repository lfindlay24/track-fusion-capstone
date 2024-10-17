import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:auto_size_widget/auto_size_widget.dart';
import 'package:track_fusion_ui/globals.dart' as globals;

class ScalableMap extends StatefulWidget {

  final double width;
  final double height;

  final Offset defaultPosition;

  double lat;
  double long;

  ScalableMap({required this.width, required this.height, required this.defaultPosition, this.lat = 0, this.long = 0});

  @override
  State<StatefulWidget> createState() {
    return _ScalableMapState();
  }
}

class _ScalableMapState extends State<ScalableMap> {
  late Offset _position;
  Offset _previousPosition = const Offset(100, 100);
  late bool _isLocked;

  double _lat = 0;
  double _long = 0;

  @override
  void initState() {
    super.initState();
    _position = widget.defaultPosition;
    _isLocked = globals.isRaceModeLocked;

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

    return Column(
      children: [
      ElevatedButton(
        onPressed: () {
        setState(() {
          _isLocked = !_isLocked;
          globals.isRaceModeLocked = _isLocked;
        });
        },
        child: Icon(
          _isLocked ? Icons.lock : Icons.lock_open,
        ),
      ),
      Expanded(
        child: GestureDetector(
        onScaleStart: _isLocked
          ? null
          : (details) {
            _previousPosition = details.focalPoint - _position;
            },
        onScaleUpdate: _isLocked
          ? null
          : (details) {
            setState(() {
              // Update the position to allow movement
              _position = details.focalPoint - _previousPosition;
            });
            },
        child: Stack(
          children: [
          Positioned(
            left: _position.dx,
            top: _position.dy,
            child: _lat != 0 && _long != 0
              ? AutoSizeWidget(
                initialHeight: widget.height,
                initialWidth: widget.width,
                showIcon: true,
                maxHeight: double.infinity,
                maxWidth: double.infinity,
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
          ],
        ),
        ),
      ),
      ],
    );
  }
}
