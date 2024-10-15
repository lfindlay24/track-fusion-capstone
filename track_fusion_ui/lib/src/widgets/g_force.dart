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
    // userAccelerometerEvents.listen((UserAccelerometerEvent event) {
    //   setState(() {
    //     _userAccelerometerEvent = event;
    //   });
    // });
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
          Center(
            child: Image(
              image: AssetImage('assets/images/g_force_icon.png'),
            ),
          ),
          Positioned(
              top: 120.5 + _userAccelerometerEvent!.y * 100,
              left: 120.5 + _userAccelerometerEvent!.x * 100,
              child: Icon(
                Icons.radio_button_checked,
                color: Colors.red,
              )),
        ],
      ),
    );
  }
}
