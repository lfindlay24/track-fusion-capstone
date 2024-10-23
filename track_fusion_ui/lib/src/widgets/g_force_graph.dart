import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:track_fusion_ui/src/models/recording_event.dart';

class GForceGraph extends StatefulWidget {
  final List<RecordingEvent> gForceData;
  String xyz = 'x';
  bool isGForceChecked;
  String title = 'Acceleration G-Force';

  GForceGraph({
    required this.gForceData,
    required this.isGForceChecked,
    required String xyz,
    required this.title,
  })  : assert(xyz == 'x' || xyz == 'y' || xyz == 'z',
            'xyz must be either x, y, or z'),
        this.xyz = xyz;

  @override
  State<StatefulWidget> createState() => _GForceGraphState();
}

class _GForceGraphState extends State<GForceGraph> {
  late int startEpoch;

  @override
  void initState() {
    super.initState();
    startEpoch = widget.gForceData[0].time;
    debugPrint('Number of G-Force Data: ${widget.gForceData.length}');
    for (var i = 0; i < widget.gForceData.length; i++) {
      if (widget.gForceData[i].time < startEpoch) {
        startEpoch = widget.gForceData[i].time;
        debugPrint('Time: ${widget.gForceData[i].time}');
      }
    }
    debugPrint('Start Epoch: $startEpoch');
    debugPrint('End Epoch: ${widget.gForceData.last.time}');
    debugPrint('Duration: ${(widget.gForceData.last.time - startEpoch) / 1000}');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(widget.title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                widget.isGForceChecked
                    ? Text('Show M/s^2')
                    : Text('Show G-Force'),
                Checkbox(
                    value: widget.isGForceChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        widget.isGForceChecked = value!;
                      });
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
                    spots: [
                      if (widget.gForceData != null)
                        for (var i = 0; i < widget.gForceData!.length; i++)
                          widget.isGForceChecked
                              ? FlSpot(
                                  (widget.gForceData[i].time
                                               -
                                          startEpoch) /
                                      1000.toDouble(),
                                  widget.xyz == 'x'
                                      ? widget.gForceData[i].gForce.x / 9.8
                                      : widget.xyz == 'y'
                                          ? widget.gForceData[i].gForce.y / 9.8
                                          : widget.gForceData[i].gForce.z / 9.8)
                              : FlSpot(
                                  (widget.gForceData[i].time
                                               -
                                          startEpoch) /
                                      1000.toDouble(),
                                  widget.xyz == 'x'
                                      ? widget.gForceData[i].gForce.x
                                      : widget.xyz == 'y'
                                          ? widget.gForceData[i].gForce.y
                                          : widget.gForceData[i].gForce.z),
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
                    sideTitles: SideTitles(
                      showTitles: false,
                    )
                  )
                ),
                minX: 0,
                maxX: (widget.gForceData.last.time -
                        startEpoch) /
                    1000,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
