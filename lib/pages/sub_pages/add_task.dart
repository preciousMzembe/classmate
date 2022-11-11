// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  final int id;
  const AddTask({super.key, required this.id});

  @override
  State<AddTask> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddTask> {
  final _classmatebox = Hive.box("classmatebox");
  var subjectInfo = {};

  void getSubjectInfo() {
    setState(() {
      subjectInfo = _classmatebox.get(widget.id);
    });
  }

  var main_color = Colors.grey[500];
  final TextEditingController _task = TextEditingController();
  final TextEditingController _date = TextEditingController();

  @override
  void initState() {
    getSubjectInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task",style: TextStyle(fontWeight: FontWeight.bold),),
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(127, 188, 250, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _task,
                decoration: InputDecoration(
                  hintText: "Task Name",
                  labelStyle: TextStyle(color:Colors.blueGrey),
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
          
              SizedBox(
                height: 20,
              ),
          
              TextFormField(
                controller: _date,
                decoration: InputDecoration(
                  hintText: "Due Date",
                  labelStyle: TextStyle(color:Colors.blueGrey),
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                  );
          
                  if (pickedDate != null) {
                    setState(() {
                      _date.text = DateFormat("yyyy-MM-dd").format(pickedDate);
                    });
                  }
                },
              ),
          
              // add button
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  var subject = subjectInfo['name'];
                  var task = _task.text.trim();
                  var date = _date.text.trim();
          
                  if (subject != "" && task != "" && date != "") {
                    var data = {
                      "title": "task",
                      "name": task,
                      "subject": subject,
                      "date": date,
                      "done": false,
                    };
          
                    await _classmatebox.add(data).then((value) =>
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(
                                "Task Added Successfully",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.white,
                            );
                          },
                        )
                    ).then((value) => Navigator.pop(context));
                    setState(() {
                      _task.text = "";
                      _date.text = "";
                    });
          
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    color: Color.fromRGBO(127, 188, 250, 1),
                    child: Center(
                      child: Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white,),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
