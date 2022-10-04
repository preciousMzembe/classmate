// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Timetable extends StatefulWidget {
  const Timetable({super.key});

  @override
  State<Timetable> createState() => _SettingsState();
}

class _SettingsState extends State<Timetable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Text("Timetable"),
      ),
    );
  }
}
