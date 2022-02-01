import 'package:flutter/material.dart';
import 'package:genshintodaytalent/screens/dashboard.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(GensinTodayApp());
}

class GensinTodayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Dashboard(),
    );
  }
}
