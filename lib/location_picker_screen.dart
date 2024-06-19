import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as coordinates;

import 'utils/shared_preference.dart';

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

  const LocationPicker({
    super.key,
    this.initialLatitude = 28.45306253513271,
    this.initialLongitude = 81.47338277012638,
    this.zoomLevel = 12.0,
    this.displayOnly = false,
    this.appBarColor = Colors.blueAccent,
    this.appBarTextColor = Colors.white,
    this.appBarTitle = "Select Location",
    this.markerColor = Colors.blueAccent,
  });

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late SimpleLocationResult _selectedLocation;
  final SharedPrefs _sharedPrefs = SharedPrefs();

  @override
  void initState() {
    super.initState();
    _initSharedPrefs();
  }

  void _initSharedPrefs() async {
    await _sharedPrefs.init();
    List<SimpleLocationResult> savedLocations = _sharedPrefs.locations;
    if (savedLocations.isNotEmpty) {
      _selectedLocation = savedLocations.last;
    } else {
      _selectedLocation =
          SimpleLocationResult(widget.initialLatitude, widget.initialLongitude);
    }
    setState(() {});
  }

  void _saveLocation(SimpleLocationResult location) {
    List<SimpleLocationResult> locations = _sharedPrefs.locations;
    locations.add(location);
    _sharedPrefs.locations = locations;
  }

  void _getlocation() {
    double latitude = _selectedLocation.latitude;
    double longitude = _selectedLocation.longitude;
    var coords = [latitude, longitude];
    print(coords);
    _saveLocation(_selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.appBarTitle),
          backgroundColor: widget.appBarColor,
          foregroundColor: widget.appBarTextColor,
        ),
        body: Column(
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
            ),
          ],
        ));
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
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: _selectedLocation.getLatLng(),
              child: const Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 255, 7, 7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
