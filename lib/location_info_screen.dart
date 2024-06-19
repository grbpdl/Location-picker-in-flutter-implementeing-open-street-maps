import 'package:flutter/material.dart';

class LocationInfo extends StatefulWidget {
  const LocationInfo({super.key});

  @override
  State<LocationInfo> createState() => _LocationInfoState();
}

class _LocationInfoState extends State<LocationInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("My Location Coordinates"),
        //show all the saved coordinates here
        Flexible(
          flex: 1,
          child: ElevatedButton(
            onPressed: saveLocation,
            child: const Text('Save a Location'),
          ),
        ),
      ],
    );
  }

  void saveLocation() {}
}
