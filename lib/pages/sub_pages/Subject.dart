// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:classmate/pages/sub_pages/add_task.dart';
import 'package:flutter/material.dart';

class Subject extends StatefulWidget {
  const Subject({super.key});

  @override
  State<Subject> createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  @override
  Widget build(BuildContext context) {
    void addTaskSheet() {
      Future future = showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return AddTask();
        },
      );
      // future.then((value) => getSubjects());
    }

    void onSelected(value) {
      if (value == 0) {
        print("edit");
      } else {
        print("delete");
      }
    }

    return Scaffold(
      // app bar
      appBar: AppBar(
        title: Text(
          "Subject name",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
        ),
        elevation: 0.0,
        backgroundColor: Colors.grey[800],
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              onSelected(value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text("Edit"),
              ),
              PopupMenuItem(
                value: 1,
                child: Text("Delete"),
              ),
            ],
          ),
        ],
      ),

      // body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tasks",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                height: 20,
              ),
            ],
          ),
        ),
      ),

      // add subject button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTaskSheet();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
