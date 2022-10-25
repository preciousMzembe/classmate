// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditSubject extends StatefulWidget {
  final int id;
  const EditSubject({super.key, required this.id});

  @override
  State<EditSubject> createState() => _EditSubjectState();
}

class _EditSubjectState extends State<EditSubject> {
  var main_color = Colors.grey[500];
  final _formKey = GlobalKey<FormState>();

  final _classmatebox = Hive.box("classmatebox");
  var _subjectInfo = {}; // get subject information using widget.id(key)

  final _timeList = ['1 (8:30-9:45)', '2 (10:00-11:15)', '3 (11:30-12:45)', '4 (1:00-2:15)', '5 (2:30-3:45)', '6 (4:00-5:15)', '7 (5:30-6:45)', '8 (7:00-8:15)'];

  List _buttonColor = [false, false, false, false, false];

  @override
  void initState() {
    getSubjectInfo();
    super.initState();
  }

  void getSubjectInfo() {
    setState(() {
      _subjectInfo = _classmatebox.get(widget.id);
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
        SnackBar(content: Text("Select days of week!!")),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {

      _formKey.currentState!.save();

      await _classmatebox.put(widget.id, _subjectInfo).then((value) =>
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Subject edited successfully!!")),
          )
      ).then((value) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Subject"),
        elevation: 0.0,
        backgroundColor: Colors.grey[800],
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
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
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
                          return 'Please choose item';
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
                    ),
                    onSaved: (value){
                      setState(() {
                        _subjectInfo["professor"] = value.toString();
                      });
                    },
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
                          color: main_color,
                          child: Center(
                            child: Text("Save"),
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
            color: _buttonColor[index] ? main_color : Colors.transparent,
            child: Center(
              child: Text(
                text,
                style: TextStyle(fontSize:16, fontWeight: FontWeight.bold),
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