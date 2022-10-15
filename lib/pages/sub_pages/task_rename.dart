// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TaskRename extends StatefulWidget {
  final int id;
  const TaskRename({
    super.key,
    required this.id,
  });

  @override
  State<TaskRename> createState() => _TaskRenameState();
}

class _TaskRenameState extends State<TaskRename> {
  final _classmatebox = Hive.box("classmatebox");
  final _formKey = GlobalKey<FormState>();
  final _taskName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            "Rename Task",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _taskName,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: "Enter task name",
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: TextStyle(
              fontSize: 12,
            ),
            validator: ((value) {
              if (value! == "") {
                return "Enter task name";
              } else {
                return null;
              }
            }),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                var boxData = _classmatebox.get(widget.id);
                boxData['name'] = _taskName.text.trim();
                // print(boxData);

                _classmatebox.put(widget.id, boxData);
                Navigator.pop(context);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                color: Colors.grey[800],
                child: Text(
                  "Set",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          // loading ---------------------------
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
