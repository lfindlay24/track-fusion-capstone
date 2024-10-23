import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:track_fusion_ui/src/models/recording_event.dart';

class SpeedGraph extends StatefulWidget {
  //List of G-Force data for the user to switch between
  final List<RecordingEvent> speedData;

  //Title of the graph
  String title = 'Acceleration G-Force';

  SpeedGraph({
    required this.speedData,
    required this.title,
  });

  @override
  State<StatefulWidget> createState() => _SpeeedGraphState();
}

class _SpeeedGraphState extends State<SpeedGraph> {
  bool smoothSpeed = false;

  //Used to determine the start time of the graph
  late int startEpoch;

  @override
  void initState() {
    super.initState();
    startEpoch = widget.speedData[0].time;
    debugPrint('Number of G-Force Data: ${widget.speedData.length}');
    for (var i = 0; i < widget.speedData.length; i++) {
      if (widget.speedData[i].time < startEpoch) {
        //Go through the list and find the earliest time
        startEpoch = widget.speedData[i].time;
        debugPrint('Time: ${widget.speedData[i].time}');
      }
    }
    debugPrint('Smooth Speed: $smoothSpeed');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                smoothSpeed ? Text('Raw Speed') : Text('Smooth Speed'),
                Checkbox(
                    value: smoothSpeed,
                    onChanged: (bool? value) {
                      setState(() {
                        smoothSpeed = value!;
                      });
                      debugPrint('Smooth Speed: $smoothSpeed');
                    }),
              ],
            ),
          ]),
          AspectRatio(
            aspectRatio: 2.0,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    preventCurveOverShooting: true,
                    barWidth: 5,
                    belowBarData: BarAreaData(
                      show: true,
                    ),
                    spots: smoothSpeed
                        ? getSmoothSpeedData()
                        : [
                            if (widget.speedData != null)
                              for (var i = 0; i < widget.speedData!.length; i++)
                                //Determine where the instance should land on the graph
                                FlSpot(
                                    (widget.speedData[i].time - startEpoch) /
                                        //Convert the time to seconds
                                        1000.toDouble(),
                                    widget.speedData[i].speed),
                          ],
                  ),
                ],
                titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}s',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        //Hide the right titles
                        sideTitles: SideTitles(
                      showTitles: false,
                    ))),
                minX: 0,
                //Find the maximum time of the graph
                maxX: (widget.speedData.last.time - startEpoch) / 1000,
                minY: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //This function calculates the smooth speed data by only showing unique speed values
  List<FlSpot> getSmoothSpeedData() {
    if (widget.speedData == null) {
      return [];
    }

    List<FlSpot> smoothSpeedData = [];
    smoothSpeedData.add(FlSpot(
        (widget.speedData[0].time - startEpoch) / 1000.toDouble(),
        widget.speedData[0].speed));
    for (var i = 1; i < widget.speedData.length; i++) {
      if (i == widget.speedData.length - 1) {
        smoothSpeedData.add(FlSpot(
            (widget.speedData[i].time - startEpoch) / 1000.toDouble(),
            widget.speedData[i].speed));
      } else if (widget.speedData[i].speed != widget.speedData[i - 1].speed) {
        smoothSpeedData.add(FlSpot(
            (widget.speedData[i].time - startEpoch) / 1000.toDouble(),
            widget.speedData[i].speed));
      }
    }
    return smoothSpeedData;
  }
}
