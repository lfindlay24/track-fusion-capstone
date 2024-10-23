import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:track_fusion_ui/globals.dart' as globals;
import 'package:track_fusion_ui/src/models/race_data.dart';
import 'package:track_fusion_ui/src/models/recording_event.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:track_fusion_ui/src/widgets/g_force_graph.dart';
import 'package:track_fusion_ui/src/widgets/speed_graph.dart';

class MetricsPage extends StatefulWidget {
  static const routeName = '/metrics';

  @override
  State<StatefulWidget> createState() => _MetricsState();
}

class _MetricsState extends State<MetricsPage> {
  List<RaceData> raceData = [];
  RaceData? selectedData;

  bool isGForceChecked = false;

  @override
  void initState() {
    super.initState();

    //Enforce landscape mode while in this page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

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
          if (selectedData != null)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GForceGraph(
                          gForceData: selectedData!.recordingEvents,
                          isGForceChecked: isGForceChecked,
                          title: 'G-Force',
                        ),
                      ),
                    ),
                    Expanded(
                      child: GForceGraph(
                        gForceData: selectedData!.recordingEvents,
                        isGForceChecked: isGForceChecked,
                        title: 'G-Force',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: GForceGraph(
                        gForceData: selectedData!.recordingEvents,
                        isGForceChecked: isGForceChecked,
                        title: 'G-Force',
                      ),
                    ),
                    Expanded(
                      child: SpeedGraph(
                        speedData: selectedData!.recordingEvents,
                        title: 'Speed',
                      ),
                    ),
                  ],
                ),
              ],
            )
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
