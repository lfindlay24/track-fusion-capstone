import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:track_fusion_ui/src/models/recording_event.dart';

class GForceGraph extends StatefulWidget {
  //List of G-Force data for the user to switch between
  final List<RecordingEvent> gForceData;

  //Determines if the user wants to see the G-Force in m/s^2 or G-Force
  bool isGForceChecked;

  //Title of the graph
  String title = 'Acceleration G-Force';

  GForceGraph({
    required this.gForceData,
    required this.isGForceChecked,
    required this.title,
  });

  @override
  State<StatefulWidget> createState() => _GForceGraphState();
}

class _GForceGraphState extends State<GForceGraph> {
  //Used to determine the start time of the graph
  late int startEpoch;

  bool showx = true;
  bool showy = true;
  bool showz = true;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    startEpoch = widget.gForceData[0].time;
    debugPrint('Number of G-Force Data: ${widget.gForceData.length}');
    for (var i = 0; i < widget.gForceData.length; i++) {
      if (widget.gForceData[i].time < startEpoch) {
        //Go through the list and find the earliest time
        startEpoch = widget.gForceData[i].time;
        debugPrint('Time: ${widget.gForceData[i].time}');
      }
    }
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
            Row(
              children: [
                Text('Show X?'),
                Checkbox(
                    value: showx,
                    onChanged: (bool? value) {
                      setState(() {
                        showx = value!;
                      });
                    }),
              ],
            ),
            Row(
              children: [
                Text('Show Y?'),
                Checkbox(
                    value: showy,
                    onChanged: (bool? value) {
                      setState(() {
                        showy = value!;
                      });
                    }),
              ],
            ),
            Row(
              children: [
                Text('Show Z?'),
                Checkbox(
                    value: showz,
                    onChanged: (bool? value) {
                      setState(() {
                        showz = value!;
                      });
                    }),
              ],
            ),
          ]),
          AspectRatio(
            aspectRatio: 2.0,
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  setState(() {
                    _scrollOffset += event.scrollDelta.dy;
                    if (_scrollOffset < 0)
                      _scrollOffset = 0; // Prevent scrolling past the start
                    _scrollController.jumpTo(_scrollOffset);
                  });
                }
              },
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _scrollOffset += details.primaryDelta!;
                    _scrollController.jumpTo(_scrollOffset);
                  });
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: SizedBox(
                    width: (widget.gForceData.length / 2).toDouble() *
                        50, // Adjust width to allow scrolling
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          if (showx)
                            LineChartBarData(
                              isCurved: true,
                              preventCurveOverShooting: true,
                              barWidth: 5,
                              color: Colors.red,
                              aboveBarData: BarAreaData(
                                show: true,
                                color: Colors.red.withOpacity(0.5),
                                cutOffY: 0.0,
                                applyCutOffY: true,
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.red.withOpacity(0.5),
                                cutOffY: 0.0,
                                applyCutOffY: true,
                              ),
                              spots: [
                                if (widget.gForceData != null)
                                  for (var i = 0;
                                      i < widget.gForceData!.length;
                                      i++)
                                    widget.isGForceChecked
                                        //Determine where the instance should land on the graph
                                        ? FlSpot(
                                            (widget.gForceData[i].time -
                                                    startEpoch) /
                                                //Convert the time to seconds
                                                1000.toDouble(),
                                            //Divides the G-Force by 9.8 to convert it to G's instead of m/s^2
                                            widget.gForceData[i].gForce.x / 9.8)
                                        : FlSpot(
                                            (widget.gForceData[i].time -
                                                    startEpoch) /
                                                1000.toDouble(),
                                            widget.gForceData[i].gForce.x),
                              ],
                            ),
                          if (showy)
                            LineChartBarData(
                              isCurved: true,
                              preventCurveOverShooting: true,
                              barWidth: 5,
                              color: Colors.green,
                              aboveBarData: BarAreaData(
                                show: true,
                                color: Colors.green.withOpacity(0.5),
                                cutOffY: 0.0,
                                applyCutOffY: true,
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.green.withOpacity(0.5),
                                cutOffY: 0.0,
                                applyCutOffY: true,
                              ),
                              spots: [
                                if (widget.gForceData != null)
                                  for (var i = 0;
                                      i < widget.gForceData!.length;
                                      i++)
                                    widget.isGForceChecked
                                        ? FlSpot(
                                            (widget.gForceData[i].time -
                                                    startEpoch) /
                                                1000.toDouble(),
                                            widget.gForceData[i].gForce.y / 9.8)
                                        : FlSpot(
                                            (widget.gForceData[i].time -
                                                    startEpoch) /
                                                1000.toDouble(),
                                            widget.gForceData[i].gForce.y),
                              ],
                            ),
                          if (showz)
                            LineChartBarData(
                              isCurved: true,
                              preventCurveOverShooting: true,
                              barWidth: 5,
                              color: Colors.blue,
                              aboveBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.5),
                                cutOffY: 0.0,
                                applyCutOffY: true,
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.5),
                                cutOffY: 0.0,
                                applyCutOffY: true,
                              ),
                              spots: [
                                if (widget.gForceData != null)
                                  for (var i = 0;
                                      i < widget.gForceData!.length;
                                      i++)
                                    widget.isGForceChecked
                                        ? FlSpot(
                                            (widget.gForceData[i].time -
                                                    startEpoch) /
                                                1000.toDouble(),
                                            widget.gForceData[i].gForce.z / 9.8)
                                        : FlSpot(
                                            (widget.gForceData[i].time -
                                                    startEpoch) /
                                                1000.toDouble(),
                                            widget.gForceData[i].gForce.z),
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
                        maxX:
                            ((widget.gForceData.last.time - startEpoch) / 1000),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
