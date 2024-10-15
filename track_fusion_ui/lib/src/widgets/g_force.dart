import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GForce extends StatefulWidget {
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
              image: AssetImage('assets/images/g_force_icon.png'),
            ),
          ),
          Positioned(
              // Position the top based on the z axis, ie. the back and face of the phone
              top: 120.5 + -(_userAccelerometerEvent!.z * 10),
              // Position the left based on the y axis, ie. the left and right of the phone when in landscape mode
              left: 120.5 + (_userAccelerometerEvent!.y * 10),
              child: const Icon(
                Icons.radio_button_checked,
                color: Colors.red,
              )),
        ],
      ),
    );
  }
}
