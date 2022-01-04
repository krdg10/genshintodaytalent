import 'package:flutter/material.dart';
import 'package:genshintodaytalent/screens/dashboard.dart';

void main() {
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
