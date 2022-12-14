// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:classmate/pages/sub_pages/subject_timetable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:classmate/pages/sub_pages/palette.dart';

class EditSubject extends StatefulWidget {
  final int id;
  const EditSubject({super.key, required this.id});

  @override
  State<EditSubject> createState() => _EditSubjectState();
}

class _EditSubjectState extends State<EditSubject> {
  var main_color = Color.fromRGBO(127, 188, 250, 1);
  final _formKey = GlobalKey<FormState>();
  Timetable t = Timetable();
  List<List<int>> timetable = [];
  List<String> timetable_msg = [];

  final _classmatebox = Hive.box("classmatebox");
  var _subjectInfo = {}; // get subject information using widget.id(key)

  Color currentColor = Color.fromRGBO(127, 188, 210, 1); //default color
  List<Color> colorHistory = [];

  void changeColor(Color color) => setState(() {
        currentColor = color;
      });

  @override
  void initState() {
    getSubjectInfo();
    super.initState();
  }

  void getSubjectInfo() {
    setState(() {
      _subjectInfo = _classmatebox.get(widget.id);
      currentColor = _subjectInfo['color'] != null
          ? Color(_subjectInfo['color'])
          : currentColor;
      if (_subjectInfo.containsKey('timetable')) {
        // timetable = _subjectInfo["timetable"];
        timetable = List.generate(6, (i) => List.filled(9, 0, growable: false),
            growable: false);
        for (var c = 0; c < _subjectInfo["timetable"].length; c++) {
          for (var r = 0; r < _subjectInfo["timetable"][c].length; r++) {
            if (_subjectInfo["timetable"][c][r] == 1) {
              String info;
              info = "${t.getDays(c)} ${t.getTime(r)}";
              timetable[c][r] = 1;

              // save timetable information
              if (timetable[c][r] == 1) {
                setState(() {
                  timetable_msg.add(info);
                });
              }
            }
          }
        }
      } else {
        timetable = List.generate(6, (i) => List.filled(9, 0, growable: false),
            growable: false);
      }
    });
  }

  void editSubjectDB() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _subjectInfo['color'] = currentColor.value;
      _subjectInfo["timetable"] = timetable;

      await _classmatebox
          .put(widget.id, _subjectInfo)
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Subject Added Successfully",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Color.fromRGBO(127, 188, 250, 1),
                ),
              ))
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Subject",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                                    id: widget.id,
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ).then((value) {
                    for (var list in timetable) {
                      var col = timetable.indexOf(list);

                      for (var row = 0; row < list.length; row++) {
                        String info;
                        info = t.showInfo(col, row);

                        // save timetable information
                        if (!timetable_msg.contains(info)) {
                          setState(() {
                            timetable_msg.add(info);
                          });
                        }
                        else{
                          int index = timetable_msg.indexOf(info);
                          setState(() {
                            timetable_msg.removeAt(index);
                          });
                        }
                        // if (list[row] == 1) {
                        //   if (!timetable_msg.contains(info)) {
                        //     setState(() {
                        //       timetable_msg.add(info);
                        //     });
                        //   }
                        // } else {
                        //   if (timetable_msg.contains(info)) {
                        //     int index = timetable_msg.indexOf(info);
                        //     setState(() {
                        //       timetable_msg.removeAt(index);
                        //     });
                        //   }
                        // }
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
                initialValue: _subjectInfo["name"],
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Subject',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Subject Name';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _subjectInfo["name"] = value.toString();
                  });
                },
              ),
              TextFormField(
                initialValue: _subjectInfo["place"],
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Place',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onSaved: (value) {
                  setState(() {
                    _subjectInfo["place"] = value.toString();
                  });
                },
              ),
              TextFormField(
                initialValue: _subjectInfo["professor"],
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Professor',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onSaved: (value) {
                  setState(() {
                    _subjectInfo["professor"] = value.toString();
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
                    editSubjectDB();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.all(10),
                      color: currentColor,
                      child: Center(
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  renderClassTimeText() {
    return Column(
      children: [
        for (int i = 0; i < timetable_msg.length; i++) Text(timetable_msg[i]),
      ],
    );
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
    //index--;
    if (index < daysOfWeek.length && index > 0) {
      return daysOfWeek[--index];
    } else {
      return "Invalid Input";
    }
  }

  String getTime(int index) {
    if (index < timeList.length) {
      return timeList[--index];
    } else {
      return "Invalid Input";
    }
  }
}
