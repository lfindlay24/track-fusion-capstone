import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RaceTrackSelector extends StatefulWidget {

  Function onTrackSelected;

  RaceTrackSelector({required this.onTrackSelected});

  @override
  State<StatefulWidget> createState() {
    return _RaceTrackSelectorState();
  }
}

class _RaceTrackSelectorState extends State<RaceTrackSelector> {
  final List<RaceTrack> raceTracks = [
    RaceTrack(
        name: 'Daytona International Speedway, FL, USA',
        lat: 29.185118,
        long: -81.070686),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
        DrawerHeader(
          child: Text('Race Tracks'),
          decoration: BoxDecoration(
          color: Colors.blue,
          ),
        ),
        ...raceTracks.map((RaceTrack track) {
          return ListTile(
          title: Text(track.name),
          onTap: () {
            setState(() {
            selectedTrack = track;
            widget.onTrackSelected(selectedTrack);
            });
            Navigator.pop(context); // Close the drawer
          },
          );
        }).toList(),
        ],
      ),
      );
  }

  RaceTrack? selectedTrack;
}

class RaceTrack {
  final String name;
  final double lat;
  final double long;
  //final String image;

  RaceTrack({required this.name, required this.lat, required this.long});
}
