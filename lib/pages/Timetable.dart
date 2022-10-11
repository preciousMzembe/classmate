// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Timetable extends StatefulWidget {
  const Timetable({super.key});

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  final int listLength = 54;
  late List<bool> _subjects;
  @override
  void initState() {
    super.initState();
    initializeSelection();
  }

  void initializeSelection() {
    _subjects = List<bool>.generate(listLength, (_) => false);
    for(int i=0; i<_subjects.length; i++){
      if(i%9==0){
        _subjects[i] = true;
      }
      if(i%13==0){
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
    return Scaffold(
      body: GridBuilder(
        subjectList: _subjects,
      )
    );
  }
}

class GridBuilder extends StatefulWidget {
  const GridBuilder({
    super.key,
    required this.subjectList,
  });

  final List<bool> subjectList;

  @override
  GridBuilderState createState() => GridBuilderState();
}
//https://stackoverflow.com/questions/43943946/how-do-i-use-async-http-data-to-return-child-widgets-in-an-indexedwidgetbuilder
class GridBuilderState extends State<GridBuilder> {
  final boxdata = Hive.box("classmatebox").toMap();
  final _timeList = ['1 (8:30~9:45)', '2 (10:00~11:15)', '3 (11:30~12:45)', '4 (1:00~2:15)', '5 (2:30~3:45)', '6 (4:00~5:15)', '7 (5:30~6:45)', '8 (7:00~8:15)'];
  final _days = ["", "Mon", "Tue", "Wed", "Thur", "Fri"];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.only(right: 10),
        itemCount: widget.subjectList.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
        itemBuilder: (_, int index) {
          double row = index/6;

          // Header: Mon Tue Wed Thur Fri
          if(index < 6){
            return InkWell(
              child: GridTile(
                  child: Center(
                    child: Text(
                      "${_days[index]}",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )),
                  ),
            );
          }
          // Time : 1 2 3 4 5 6 7 8
          if(index%6==0){
            return InkWell(
              child: GridTile(
                  child: Center(
                      child: Text(
                        "${row.toInt()}",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                  )
              ),
            );
          }
          // shows subject
          for (var element in boxdata.values) {
            if (element['classTime'] == _timeList[row.toInt() -1] &&
                element['title'] == "subject") {

              for(var data in element["dayList"]){
                if(data == _days[index%6]){
                  return InkWell(
                    child: GridTile(
                      child: Container(
                        margin: EdgeInsets.all(3),
                        padding: EdgeInsets.all(3),
                        alignment: Alignment.center,
                        decoration:BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            )),
                        child: Text(element["name"]),
                      ),
                    ),
                  );
                }
              }
            }
          }
          return InkWell(
            child: GridTile(
                child: Container(
                  // child: Text(index.toString()),
                  decoration:BoxDecoration(
                    border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))
                )),
            )
          );
        });
  }
}
