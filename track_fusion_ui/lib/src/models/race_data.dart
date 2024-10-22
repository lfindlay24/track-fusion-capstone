

import 'package:track_fusion_ui/src/models/recording_event.dart';

class RaceData {
  final double raceDistance;
  final String raceLocation;
  final int raceTime;
  List<RecordingEvent> recordingEvents = [];

  RaceData({
    required this.raceDistance,
    required this.raceLocation,
    required this.raceTime,
  });
}