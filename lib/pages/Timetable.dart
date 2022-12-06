// ignore_for_file: prefer_const_constructors

import 'package:classmate/pages/sub_pages/subject_timetable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Timetable extends StatefulWidget {
  const Timetable({super.key});

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  final _classmatebox = Hive.box("classmatebox");
  List<List<int>> timetable = [];

  @override
  void initState() {
    super.initState();
    timetable = List.generate(6, (i) => List.filled(9,  0,growable: false), growable: false);

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SubjectTimetable(
        select: false,
        data: _classmatebox.toMap(),
        timetable: timetable,
        id: 0,
      )
    );
  }
}
