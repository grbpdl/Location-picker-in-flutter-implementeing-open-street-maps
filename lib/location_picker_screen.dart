import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as coordinates;
import 'package:shared_preferences/shared_preferences.dart';

typedef Location = List<double> Function(dynamic data);

class LocationPicker extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final double zoomLevel;
  final bool displayOnly;
  final Color appBarColor;
  final Color markerColor;
  final Color appBarTextColor;
  final String appBarTitle;

  // ignore: use_super_parameters
  const LocationPicker({
    Key? key,
    this.initialLatitude = 28.45306253513271,
    this.initialLongitude = 81.47338277012638,
    this.zoomLevel = 12.0,
    this.displayOnly = false,
    this.appBarColor = Colors.blueAccent,
    this.appBarTextColor = Colors.white,
    this.appBarTitle = "Select Location",
    this.markerColor = Colors.blueAccent,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late SimpleLocationResult _selectedLocation = SimpleLocationResult(
    widget.initialLatitude,
    widget.initialLongitude,
  );

  @override
  void initState() {
    super.initState();
    _loadSelectedLocation();
  }

  void _loadSelectedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double latitude =
        prefs.getDouble('selectedLatitude') ?? widget.initialLatitude;
    double longitude =
        prefs.getDouble('selectedLongitude') ?? widget.initialLongitude;
    setState(() {
      _selectedLocation = SimpleLocationResult(latitude, longitude);
    });
  }

  void _saveSelectedLocation(double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('selectedLatitude', latitude);
    await prefs.setDouble('selectedLongitude', longitude);
  }

  void _getlocation() {
    double latitude = _selectedLocation.latitude;
    double longitude = _selectedLocation.longitude;
    _saveSelectedLocation(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Latitude: ${_selectedLocation.latitude}"),
            Text("Longitude: ${_selectedLocation.longitude}"),
            Flexible(
              flex: 10,
              child: _osmWidget(),
            ),
            Flexible(
              flex: 1,
              child: ElevatedButton(
                onPressed: _getlocation,
                child: const Text('Pick Location'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _osmWidget() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: _selectedLocation.getLatLng(),
        initialZoom: widget.zoomLevel,
        onTap: (tapLoc, position) {
          if (!widget.displayOnly) {
            setState(() {
              _selectedLocation =
                  SimpleLocationResult(position.latitude, position.longitude);
            });
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(markers: [
          Marker(
            width: 80.0,
            height: 80.0,
            point: _selectedLocation.getLatLng(),
            child: const Icon(
              Icons.location_on,
              color: Color.fromARGB(255, 255, 7, 7),
            ),
          ),
        ])
      ],
    );
  }
}

class SimpleLocationResult {
  final double latitude;
  final double longitude;

  SimpleLocationResult(this.latitude, this.longitude);

  coordinates.LatLng getLatLng() => coordinates.LatLng(latitude, longitude);
}
