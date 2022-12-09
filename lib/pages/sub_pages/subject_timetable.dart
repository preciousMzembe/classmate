// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SubjectTimetable extends StatefulWidget {
  const SubjectTimetable({
    Key? key,
    required this.select,
    required this.data,
    required this.timetable,
    required this.id,
  }) : super(key: key);

  final bool select;
  final Map<dynamic, dynamic> data;
  final List<List<int>> timetable;
  final int id;

  @override
  State<SubjectTimetable> createState() => _SubjectTimetableState();
}

class _SubjectTimetableState extends State<SubjectTimetable> {
  var main_color = Colors.grey[200]; //default color
  final _timeList = [
    '1 (8:30-9:45)',
    '2 (10:00-11:15)',
    '3 (11:30-12:45)',
    '4 (1:00-2:15)',
    '5 (2:30-3:45)',
    '6 (4:00-5:15)',
    '7 (5:30-6:45)',
    '8 (7:00-8:15)'
  ];
  final _days = ["", "Mon", "Tue", "Wed", "Thur", "Fri"];
  Timetable t = Timetable();

  final int listLength = 54;
  late List<bool> _subjects;

  @override
  void initState() {
    super.initState();
    initializeSelection();
  }

  void initializeSelection() {
    _subjects = List<bool>.generate(listLength, (_) => false);
    for (int i = 0; i < _subjects.length; i++) {
      if (i % 9 == 0) {
        _subjects[i] = true;
      }
      if (i % 13 == 0) {
        _subjects[i] = true;
      }
    }
  }

  @override
  void dispose() {
    _subjects.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.only(right: 10),
        itemCount: _subjects.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
        itemBuilder: (_, int index) {
          var c = index % 6;
          var r = index ~/ 6;

          // Header: Mon Tue Wed Thur Fri
          if (index < 6) {
            return InkWell(
              child: GridTile(
                child: Center(
                    child: Text(
                  _days[index],
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                  textAlign: TextAlign.center,
                )),
              ),
            );
          }
          // Time : 1 2 3 4 5 6 7 8
          if (index % 6 == 0) {
            return InkWell(
              child: GridTile(
                  child: Center(
                      child: Text(
                "${r}",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ))),
            );
          }
          // show changed button color for selected timeblock
          if (widget.select == true && widget.timetable[c][r] == 1) {
            return InkWell(
                child: GridTile(
              child: Container(
                margin: EdgeInsets.all(3),
                padding: EdgeInsets.all(3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey)),
                  child: Container(),
                  onPressed: () {
                    setState(() {
                      if (widget.timetable[c][r] == 1) {
                        widget.timetable[c][r] = 0;
                      } else {
                        widget.timetable[c][r] = 1;
                      }
                    });
                  },
                ),
              ),
            ));
          }
          // Disable stored timeblock, except timeblock in timetable (for editing)
          for (var element in widget.data.values) {
            if (element.containsKey("timetable")) {
              var et = element["timetable"];
              if (et[c][r] > 0) {
                // if(element.containsKey(widget.id)){
                if (widget.id != 0 && widget.data[widget.id] == element) {
                  return InkWell(
                      child: GridTile(
                    child: Container(
                      margin: EdgeInsets.all(3),
                      padding: EdgeInsets.all(3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: Container(),
                        onPressed: () {
                          setState(() {
                            if (widget.timetable[c][r] == 1) {
                              widget.timetable[c][r] = 0;
                            } else {
                              widget.timetable[c][r] = 1;
                            }
                          });
                        },
                      ),
                    ),
                  ));
                }
                return InkWell(
                  child: GridTile(
                    child: widget.select == false
                        ? Container(
                            margin: EdgeInsets.all(3),
                            padding: EdgeInsets.all(3),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: element['color'] != null
                                    ? Color(element['color'])
                                    : main_color,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                            child: Text(
                              element["name"],
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.all(3),
                            padding: EdgeInsets.all(3),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: main_color,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                          ),
                  ),
                );
              }
            }
            if (element.containsKey("classTime")) {
              if (element['classTime'] == _timeList[r - 1]) {
                for (var data in element["dayList"]) {
                  if (data == _days[c]) {
                    return InkWell(
                      child: GridTile(
                        child: widget.select == false
                            ? Container(
                                margin: EdgeInsets.all(3),
                                padding: EdgeInsets.all(3),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: element['color'] != null
                                        ? Color(element['color'])
                                        : main_color,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    )),
                                child: Text(
                                  element["name"],
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.all(3),
                                padding: EdgeInsets.all(3),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: main_color,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    )),
                              ),
                      ),
                    );
                  }
                }
              }
            }
          }
          return widget.select == false
              ? InkWell(child: GridTile(child: Container()))
              : InkWell(
                  child: GridTile(
                  child: Container(
                    margin: EdgeInsets.all(3),
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        )),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Container(),
                      onPressed: () {
                        setState(() {
                          if (widget.timetable[c][r] == 1) {
                            widget.timetable[c][r] = 0;
                          } else {
                            widget.timetable[c][r] = 1;
                          }
                        });
                      },
                    ),
                  ),
                ));
        });
  }
}

class Timetable {
  final daysOfWeek = ['Mon', "Tue", "Wed", "Thur", 'Fri'];
  final timeList = [
    '1 (8:30-9:45)',
    '2 (10:00-11:15)',
    '3 (11:30-12:45)',
    '4 (1:00-2:15)',
    '5 (2:30-3:45)',
    '6 (4:00-5:15)',
    '7 (5:30-6:45)',
    '8 (7:00-8:15)'
  ];

  String showInfo(int col, int row) {
    return "${getDays(col)} ${getTime(row)}";
  }

  String getDays(int index) {
    if (index < daysOfWeek.length && index > 0) {
      return daysOfWeek[--index];
    } else {
      return "Invalid Input";
    }
  }

  String getTime(int index) {
    if (index < timeList.length && index > 0) {
      return timeList[--index];
    } else {
      return "Invalid Input";
    }
  }
}
