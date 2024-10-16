import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GForce extends StatefulWidget {

  final double width;
  final double height;

  GForce({required this.width, required this.height});

  @override
  State<StatefulWidget> createState() {
    return _GForceState();
  }
}

class _GForceState extends State<GForce> {

  @override
  void initState() {
    super.initState();
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
    return Container(
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
    );
  }
}
