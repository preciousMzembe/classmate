// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.only(right: 10),
        itemCount: widget.subjectList.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
        itemBuilder: (_, int index) {
          // Header: Mon Tue Wed Thur Fri
          if(index < 6){
            var days = ["", "Mon", "Tue", "Wed", "Thur", "Fri"];
            return InkWell(
              child: GridTile(
                  child: Center(
                    child: Text(
                      "${days[index]}",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )),
                  ),
            );
          }
          // Time : 1 2 3 4 5 6 7 8
          if(index%6==0){
            double row = index/6;
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
          if(widget.subjectList[index]){
            return InkWell(
              child: GridTile(
                  child: Container(
                    margin: EdgeInsets.all(3),
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    child: Text("ICT APP Develop"),
                    decoration:BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                    ),
                  ),
            );
          }
          return InkWell(
            child: GridTile(
                child: Container(
                  decoration:BoxDecoration(
                    border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))
                )),
            )
          );
        });
  }
}
