import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GForce extends StatefulWidget {

  final double width;
  final double height;

  final Offset defaultPosition;

  GForce({required this.width, required this.height, required this.defaultPosition});

  @override
  State<StatefulWidget> createState() {
    return _GForceState();
  }
}

class _GForceState extends State<GForce> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  late Offset _position;
  Offset _previousPosition = const Offset(100, 100);

  @override
  void initState() {
    super.initState();

    _position = widget.defaultPosition;

    userAccelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 32),
    ).listen(
      (UserAccelerometerEvent event) {
        setState(() {
          _userAccelerometerEvent = event;
        });
      },
    );
  }

  UserAccelerometerEvent? _userAccelerometerEvent;

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
              child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Image(
                      width: 300,
                      height: 300,
                      image: AssetImage('assets/images/g_force_icon.png'),
                    ),
                  ),
                  Positioned(
                      // Position the top based on the z axis, ie. the back and face of the phone
                        top: (widget.height / 2) + -(_userAccelerometerEvent!.z * 10) - 12.5, // 12.5 is half the height of the icon
                        left: (widget.width / 2) + (_userAccelerometerEvent!.y * 10) - 12.5, // 12.5 is half the width of the icon
                      child: const Icon(
                        Icons.radio_button_checked,
                        color: Colors.red,
                      )),
                ],
              ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
