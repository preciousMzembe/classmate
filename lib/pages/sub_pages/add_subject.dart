// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:classmate/pages/sub_pages/palette.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({super.key});

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  final _classmatebox = Hive.box("classmatebox");
  var main_color = Colors.grey[500];

  final _formKey = GlobalKey<FormState>();

  final _timeList = ['1 (8:30-9:45)', '2 (10:00-11:15)', '3 (11:30-12:45)', '4 (1:00-2:15)', '5 (2:30-3:45)', '6 (4:00-5:15)', '7 (5:30-6:45)', '8 (7:00-8:15)'];
  List _buttonColor = [false, false, false, false, false];

  // data
  bool _check = true; // check duplicate subject name
  late String _subjectName;
  late String _place;
  late String _professor;
  late String _classTime;
  List<String> _dayList= [];
  int _color = Color.fromRGBO(127, 188, 210, 1).value;

  Color currentColor = Color.fromRGBO(127, 188, 210, 1); //default color
  List<Color> colorHistory = [];

  void changeColor(Color color) => setState((){
    currentColor = color;
    _color = color.value;
  });

  void addSubjectDB() async {
    if(_dayList.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Select Days of Week",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),),
          backgroundColor: Colors.blueAccent,
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {

      _formKey.currentState!.save();

      var data = {
        "title": "subject",
        "name": _subjectName,
        "place": _place,
        "professor": _professor,
        "classTime": _classTime,
        "dayList": _dayList,
        "color": _color,
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
                  renderDaysOfWeek(),
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
                  DropdownButtonFormField(
                      hint: Text("Class Time", style: TextStyle(color: Colors.blueGrey),),
                      items: _timeList.map(
                              (value){
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }
                      ).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Choose Class Time';
                        }
                        return null;
                      },
                      onChanged: (value){
                        setState(() {
                          _classTime = value.toString();
                        });
                      }
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

  renderItem({
    required String text,
    required int index
  }){

    return Padding(
      padding: const EdgeInsets.fromLTRB(5,5,5,5),
      child: GestureDetector(
        onTap: (){
          setState(() {
            _buttonColor[index] = !_buttonColor[index];
            if(_buttonColor[index]){
              if(!_dayList.contains(text)){
                _dayList.add(text);
              }
            }else{
              if(_dayList.contains(text)){
                _dayList.remove(text);
              }
            }
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 50,
            width: 60,
            padding: EdgeInsets.all(5),
            color: _buttonColor[index] ? currentColor : Colors.transparent,
            child: Center(
              child: Text(
                text,
                style: TextStyle(fontSize:16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
            ),
          ),
        ),
      ),
    );
  }
  renderDaysOfWeek() {
    return Column(
      children: [
        Row(
          children: [
            renderItem(text: "Mon", index: 0),
            renderItem(text: "Tue", index: 1),
            renderItem(text: "Wed", index: 2),
            renderItem(text: "Thur", index: 3),
            renderItem(text: "Fri", index: 4),
          ],
        ),
      ],
    );
  }
}