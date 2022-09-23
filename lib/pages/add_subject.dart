// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({super.key});

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  final _classmatebox = Hive.box("classmatebox");
  var main_color = Colors.grey[500];
  final TextEditingController _subject = TextEditingController();
  List _subjects = [];

  // get all subjects
  void getSubjects() async {
    var tempData = [];
    var boxdata = _classmatebox.toMap();
    for (var key in boxdata.keys) {
      if (boxdata[key]['title'] == "subject") {
        var subject = {
          "id": key,
          "name": boxdata[key]['name'],
        };
        tempData.add(subject);
      }
    }
    setState(() {
      _subjects = tempData;
    });
  }

  @override
  void initState() {
    getSubjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        title: Text("Add Subject"),
        elevation: 0.0,
        backgroundColor: Colors.grey[800],
      ),

      // body
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // subject
                    Column(
                      children: _subjects.map((subject) {
                        return Column(
                          children: [
                            Container(
                              color: Colors.grey[300],
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${subject['name']}"),
                                  GestureDetector(
                                    onTap: ()async{
                                      await _classmatebox.delete(subject['id']);
                                      getSubjects();
                                    },
                                    child: Icon(
                                      Icons.remove,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: 0,
                              color: Colors.grey[900],
                            ),
                          ],
                        );
                      }).toList(),
                    ),

                    // input field
                    TextFormField(
                      controller: _subject,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Type a subject name",
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
                  ],
                ),
              ),
            ),

            // save button
            GestureDetector(
              onTap: () async {
                getSubjects();
                var subject = _subject.text.trim();
                if (subject != "") {
                  var condition = false;
                  var boxdata = _classmatebox.toMap();
                  for (var element in boxdata.values) {
                    if (element['name'] == subject &&
                        element['title'] == "subject") {
                      condition = true;
                    }
                  }
                  if (condition) {
                    // subject already added
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                            "Subject already exists",
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    );
                  } else {
                    // add task
                    var data = {
                      "title": "subject",
                      "name": subject,
                    };
                    await _classmatebox.add(data);
                    getSubjects();
                    setState(() {
                      _subject.text = "";
                    });
                  }
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
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
      ),
    );
  }
}
