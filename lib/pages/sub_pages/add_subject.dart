// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:classmate/pages/sub_pages/subject_timetable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:classmate/pages/sub_pages/palette.dart';

class Timetable{
  final daysOfWeek = ['Mon', "Tue", "Wed", "Thur", 'Fri'];
  final timeList = ['1 (8:30-9:45)', '2 (10:00-11:15)', '3 (11:30-12:45)', '4 (1:00-2:15)', '5 (2:30-3:45)', '6 (4:00-5:15)', '7 (5:30-6:45)', '8 (7:00-8:15)'];

  String showInfo(int col, int row){
    return "${getDays(col)} ${getTime(row)}";
  }
  String getDays(int index){
    if(index < daysOfWeek.length && index > 0) {
      return daysOfWeek[--index];
    } else {
      return "Invalid Input";
    }
  }
  String getTime(int index){
    if(index < timeList.length && index > 0) {
      return timeList[--index];
    } else {
      return "Invalid Input";
    }
  }
}

class AddSubject extends StatefulWidget {
  const AddSubject({super.key});

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  final _classmatebox = Hive.box("classmatebox");
  var main_color = Colors.grey[500];

  final _formKey = GlobalKey<FormState>();

  // data
  bool _check = true; // check duplicate subject name
  late String _subjectName;
  late String _place;
  late String _professor;

  Timetable t = Timetable();
  List<List<int>> timetable = [];
  List<String> timetable_msg = [];
  @override
  void initState() {
    super.initState();
    timetable = List.generate(6, (i) => List.filled(9,  0,growable: false), growable: false);
  }

  int _color = Color.fromRGBO(127, 188, 210, 1).value;

  Color currentColor = Color.fromRGBO(127, 188, 210, 1); //default color
  List<Color> colorHistory = [];

  void changeColor(Color color) => setState((){
    currentColor = color;
    _color = color.value;
  });

  void addSubjectDB() async {
    if (_formKey.currentState!.validate()) {

      _formKey.currentState!.save();

      var data = {
        "title": "subject",
        "name": _subjectName,
        "place": _place,
        "professor": _professor,
        // "classTime": _classTime,
        // "dayList": _dayList,
        "color": _color,
        "timetable": timetable,
      };
      await _classmatebox.add(data).then((value) =>
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Subject Added Successfully",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),),
              backgroundColor: Colors.blueAccent,
            ),
          )
      ).then((value) => Navigator.pop(context));
    }
  }

  bool checkDuplicate_DB(String subject){
    var boxdata = _classmatebox.toMap();
    for (var element in boxdata.values) {
      if (element['name'] == subject &&
          element['title'] == "subject") {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Subject", style: TextStyle(fontWeight: FontWeight.bold),),
        elevation: 0.0,
        backgroundColor: currentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                      width: 300,
                                      height: 600,
                                      child: SubjectTimetable(
                                        select: true,
                                        data: _classmatebox.toMap(),
                                        timetable: timetable,
                                        id: 0,
                                      )
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).then((value){
                        for (var list in timetable) {
                          var col = timetable.indexOf(list);

                          for (var row=0; row<list.length; row++) {
                            String info;
                            info = "${t.getDays(col)} ${t.getTime(row)}";

                            // save timetable information
                            if(list[row] == 1){
                              if(!timetable_msg.contains(info)) {
                                setState(() {
                                  timetable_msg.add(info);
                                });
                              }
                            }
                            else{
                              if(timetable_msg.contains(info)) {
                                int index = timetable_msg.indexOf(info);
                                setState(() {
                                  timetable_msg.removeAt(index);
                                });
                              }
                            }
                          }
                        }
                      });
                    },
                    icon: Icon(Icons.add, size: 18),
                    label: Text(
                        "Choose class time",
                        textAlign: TextAlign.left,
                    ),
                  ),
                  renderClassTimeText(),
                  // renderDaysOfWeek(),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Subject',
                      labelStyle: TextStyle(
                        color:Colors.blueGrey,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter a Subject Name';
                      }
                      _check = checkDuplicate_DB(value.toString());
                      if(_check){
                        return "Subject Already Exists";
                      }
                      return null;
                    },
                    onSaved: (value){
                      setState(() {
                        _subjectName = value.toString();
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Place',
                      labelStyle: TextStyle(
                        color:Colors.blueGrey,
                      ),
                    ),
                    onSaved: (value){
                      setState(() {
                        _place = value.toString();
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Professor',
                      labelStyle: TextStyle(
                        color:Colors.blueGrey,
                      ),
                    ),
                    onSaved: (value){
                      setState(() {
                        _professor = value.toString();
                      });
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                    alignment: Alignment.center,
                    child: Palette(
                      pickerColor: currentColor,
                      onColorChanged: changeColor,
                      colorHistory: colorHistory,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: GestureDetector(
                      onTap: () async {
                        addSubjectDB();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.all(10),
                          color: currentColor,
                          child: Center(
                            child: Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
  renderClassTimeText() {
    return Column(
        children: [
        for(int i=0; i<timetable_msg.length; i++)
          Text(timetable_msg[i]),
        ],
    );
  }
}