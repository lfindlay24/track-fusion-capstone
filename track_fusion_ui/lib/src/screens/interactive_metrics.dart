import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:track_fusion_ui/globals.dart' as globals;
import 'package:track_fusion_ui/src/models/race_data.dart';
import 'package:track_fusion_ui/src/models/recording_event.dart';
import 'dart:convert';

import 'package:track_fusion_ui/src/widgets/g_force_graph.dart';
import 'package:track_fusion_ui/src/widgets/speed_graph.dart';

class InteractiveMetrics extends StatefulWidget {
  static const routeName = '/interactiveMetrics';

  @override
  State<StatefulWidget> createState() => _InteractiveMetricsState();
}

class _InteractiveMetricsState extends State<InteractiveMetrics> {
  List<RaceData> raceData = [];
  RaceData? selectedData;

  bool isGForceChecked = false;

  @override
  void initState() {
    super.initState();
    getMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Metrics'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          DropdownButton<RaceData>(
            value: selectedData,
            onChanged: (RaceData? newValue) {
              setState(() {
                selectedData = newValue;
              });
            },
            items: raceData.map<DropdownMenuItem<RaceData>>((RaceData value) {
              return DropdownMenuItem<RaceData>(
                value: value,
                child: Text(value.raceTime.toString()),
              );
            }).toList(),
          ),
          //GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: itemBuilder)
        ]),
      ),
    );
  }

  // Get metrics from the databse and converts it to a list of RaceData objects
  // Will not set the state if it doesn't find any data
  void getMetrics() {
    http
        .get(Uri.parse("${globals.apiBasePath}/raceData/${globals.userId}"))
        .then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> body = Map.castFrom(json.decode(response.body));
        for (var event in body.keys) {
          RaceData data = RaceData(
            raceDistance: body[event]['raceDistance'],
            raceLocation: body[event]['raceLocation'],
            raceTime: body[event]['raceTime'],
          );
          for (var recordingEvent in body[event]['recordingEvents']) {
            data.recordingEvents.add(RecordingEvent(
              speed: recordingEvent['speed'],
              gForce: UserAccelerometerEvent(
                recordingEvent['gForce']['x'],
                recordingEvent['gForce']['y'],
                recordingEvent['gForce']['z'],
                DateTime.fromMillisecondsSinceEpoch(recordingEvent['time']),
              ),
              lat: recordingEvent['lat'],
              long: recordingEvent['long'],
              time: recordingEvent['time'],
            ));
          }
          raceData.add(data);
        }
        setState(() {
          print('Got metrics');
        });
      } else {
        print('Failed to get metrics');
      }
    });
  }
}
