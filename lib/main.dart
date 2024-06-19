import 'package:flutter/material.dart';
import 'package:location_picker_and_saver/location_info_screen.dart';

import 'utils/shared_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: LocationInfo(),
      ),
    );
  }
}
