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
            "Add Subject",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _subject,
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

          // add button
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
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
                  setState(() {
                    _subject.text = "";
                  });
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                          "Subject added successfully",
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  );
                }
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
