// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:classmate/pages/sub_pages/add_task.dart';
import 'package:classmate/pages/sub_pages/task_rename.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Subject extends StatefulWidget {
  final int id;
  const Subject({super.key, required this.id});

  @override
  State<Subject> createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  final _classmatebox = Hive.box("classmatebox");

  var subjectInfo = {};
  void getSubjectInfo() {
    setState(() {
      subjectInfo = _classmatebox.get(widget.id);
    });
  }

  List _tasks = [];
  void getTasks() {
    var tempData = [];
    var boxdata = _classmatebox.toMap();
    for (var key in boxdata.keys) {
      if (boxdata[key]['title'] == "task" &&
          boxdata[key]['subject'] == subjectInfo['name']) {
        var task = {
          "id": key,
          "name": boxdata[key]['name'],
        };
        tempData.add(task);
      }
    }
    setState(() {
      _tasks = tempData;
    });
  }

  @override
  void initState() {
    getSubjectInfo();
    getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void editTask(id) async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                height: 200,
                color: Colors.transparent,
                child: TaskRename(
                  id: id,
                ),
              ),
            );
          });

      getTasks();
    }

    void deleteTask(id, name) async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Delete Dask',
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      "$name",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Are you sure you want to delete the task?',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    _classmatebox.delete(id);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });

      getTasks();
    }

    void addTaskSheet() async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddTask(
            id: widget.id,
          ),
        ),
      );

      getTasks();
    }

    void onSelected(value) async {
      if (value == 0) {
        print("edit");
      } else {
        await _classmatebox.delete(widget.id);
        Navigator.pop(context);
      }
    }

    return Scaffold(
      // app bar
      appBar: AppBar(
        title: Text(
          "${subjectInfo['name']}".toUpperCase(),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Text(
              "Tasks",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 30,
          ),

          // list of tasks
          Expanded(
            child: ListView.separated(
              itemCount: _tasks.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 20,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${_tasks[index]['name']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        // edit --------------------
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            editTask(_tasks[index]['id']);
                          },
                          child: Icon(Icons.edit),
                        ),
                        // delete ------------------
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            deleteTask(
                                _tasks[index]['id'], _tasks[index]['name']);
                          },
                          child: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
