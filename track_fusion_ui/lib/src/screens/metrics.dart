import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:track_fusion_ui/globals.dart' as globals;
import 'package:track_fusion_ui/src/models/race_data.dart';
import 'package:track_fusion_ui/src/models/recording_event.dart';
import 'dart:convert';

class MetricsPage extends StatefulWidget {
  static const routeName = '/metrics';

  @override
  State<StatefulWidget> createState() => _MetricsState();
}

class _MetricsState extends State<MetricsPage> {
  List<RaceData> raceData = [];
  RaceData? selectedData;

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
      body: Column(children: [
        DropdownButton<RaceData>(
          value: selectedData,
          onChanged: (RaceData? newValue) {
            setState(() {
              selectedData = newValue;
            });
          },
          items: raceData
              .map<DropdownMenuItem<RaceData>>((RaceData value) {
                return DropdownMenuItem<RaceData>(
                  value: value,
                  child: Text(value.raceTime.toString()),
                );
              })
              .toList(),
        ),
        SingleChildScrollView(
          child: AspectRatio(
            aspectRatio: 2.0,
            child: LineChart(
              LineChartData(lineBarsData: [
                LineChartBarData(
                  spots: [
                    if (selectedData != null)
                      for (var i = 0;
                          i < selectedData!.recordingEvents.length;
                          i++)
                        FlSpot(i.toDouble(),
                            selectedData!.recordingEvents[i].gForce.z),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

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
            raceTime: DateTime.parse(body[event]['raceTime']),
          );
          for (var recordingEvent in body[event]['recordingEvents']) {
            data.recordingEvents.add(RecordingEvent(
              speed: recordingEvent['speed'],
              gForce: UserAccelerometerEvent(
                recordingEvent['gForce']['x'],
                recordingEvent['gForce']['y'],
                recordingEvent['gForce']['z'],
                DateTime.parse(recordingEvent['time']),
              ),
              lat: recordingEvent['lat'],
              long: recordingEvent['long'],
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
