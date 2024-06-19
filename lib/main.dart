import 'package:flutter/material.dart';
import 'package:location_picker_and_saver/saved_location_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SavedLocation(),
      ),
    );
  }
}
