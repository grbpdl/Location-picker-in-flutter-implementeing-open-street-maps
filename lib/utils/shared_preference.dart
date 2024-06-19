import 'dart:convert';
import 'package:latlong2/latlong.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  static final SharedPrefs _instance = SharedPrefs._internal();

  factory SharedPrefs() => _instance;

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  List<SimpleLocationResult> get locations {
    final String? jsonString = _sharedPrefs.getString('locations');
    if (jsonString == null) {
      return [];
    }

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => SimpleLocationResult.fromJson(json)).toList();
  }

  set locations(List<SimpleLocationResult> value) {
    final List<Map<String, dynamic>> jsonList =
        value.map((location) => location.toJson()).toList();
    final String jsonString = json.encode(jsonList);
    _sharedPrefs.setString('locations', jsonString);
  }

  void deleteLocations() {
    _sharedPrefs.remove('locations');
  }
}

class SimpleLocationResult {
  final double latitude;
  final double longitude;

  SimpleLocationResult(this.latitude, this.longitude);

  factory SimpleLocationResult.fromJson(Map<String, dynamic> json) {
    return SimpleLocationResult(
      json['latitude'],
      json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // coordinates.LatLng getLatLng() => coordinates.LatLng(latitude, longitude);
}
