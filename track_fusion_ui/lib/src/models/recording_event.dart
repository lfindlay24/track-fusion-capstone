import 'package:sensors_plus/sensors_plus.dart';

class RecordingEvent {
  final double speed;
  final UserAccelerometerEvent gForce;
  final double lat;
  final double long;
  final int time;

  RecordingEvent({
    required this.speed,
    required this.gForce,
    required this.lat,
    required this.long,
    required this.time,
  });
}