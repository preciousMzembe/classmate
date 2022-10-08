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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      // height: 300,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Add Task",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _task,
            decoration: InputDecoration(
              hintText: "Type a task name",
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
              hintText: "Type date",
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

                await _classmatebox.add(data);
                setState(() {
                  _task.text = "";
                  _date.text = "";
                });

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(
                        "Task added successfully",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                );
              }
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
        ],
      ),
    );
  }
}
