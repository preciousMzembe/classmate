// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

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

  final _classmatebox = Hive.box("classmatebox");
  var _subjectInfo = {}; // get subject information using widget.id(key)

  final _timeList = ['1 (8:30-9:45)', '2 (10:00-11:15)', '3 (11:30-12:45)', '4 (1:00-2:15)', '5 (2:30-3:45)', '6 (4:00-5:15)', '7 (5:30-6:45)', '8 (7:00-8:15)'];
  List _buttonColor = [false, false, false, false, false];

  Color currentColor = Color.fromRGBO(127, 188, 210, 1); //default color
  List<Color> colorHistory = [];

  void changeColor(Color color) => setState((){
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
      currentColor = _subjectInfo['color'] != null ? Color(_subjectInfo['color']) : currentColor;
      getButtonColor();
    });
  }
  void getButtonColor(){
    var buttonName = ["Mon", "Tue", "Wed", "Thur", "Fri"];
    var days = _subjectInfo["dayList"];
    for(int i=0; i<buttonName.length; i++){
      for(var item in days){
        if(item == buttonName[i]){
          setState(() {
            _buttonColor[i] = true;
          });
        }
      }
    }
  }

  void editSubjectDB() async {
    if(_subjectInfo["dayList"].isEmpty){
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
      _subjectInfo['color'] = currentColor.value;

      await _classmatebox.put(widget.id, _subjectInfo).then((value) =>
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Subject Added Successfully",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),),
              backgroundColor: Color.fromRGBO(127, 188, 250, 1),
            ),
          )
      ).then((value) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Subject", style: TextStyle(fontWeight: FontWeight.bold,),),
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
                    initialValue: _subjectInfo["name"],
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
                      return null;
                    },
                    onSaved: (value){
                      setState(() {
                        _subjectInfo["name"] = value.toString();
                      });
                    },
                  ),
                  DropdownButtonFormField(
                      value: _subjectInfo["classTime"].toString(),
                      hint: Text("Class Time"),

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
                          _subjectInfo["classTime"] = value.toString();
                        });
                      }
                  ),
                  TextFormField(
                    initialValue: _subjectInfo["place"],
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Place',
                      labelStyle: TextStyle(
                        color:Colors.blueGrey,
                      ),
                    ),
                    onSaved: (value){
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
                        color:Colors.blueGrey,
                      ),
                    ),
                    onSaved: (value){
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
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
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
              if(!_subjectInfo["dayList"].contains(text)){
                _subjectInfo["dayList"].add(text);
              }
            }else{
              if(_subjectInfo["dayList"].contains(text)){
                _subjectInfo["dayList"].remove(text);
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