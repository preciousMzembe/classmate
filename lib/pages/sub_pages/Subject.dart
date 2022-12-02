// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:classmate/pages/sub_pages/add_task.dart';
import 'package:classmate/pages/sub_pages/edit_subject.dart';
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
    var tempData = []; //pass key and name of subject
    var boxdata = _classmatebox.toMap();
    for (var key in boxdata.keys) {
      if (boxdata[key]['title'] == "task" &&
          boxdata[key]['subject'] == subjectInfo['name']) {
        var task = {
          "id": key,
          "name": boxdata[key]['name'],
          "done": boxdata[key]['done'],
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

    Future<dynamic> alertDeleteSubject(BuildContext context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Are You Sure You Want To Delete',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      subjectInfo["name"].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'DELETE',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () async {
                    // delete tasks
                    var boxdata = _classmatebox.toMap();
                    for (var key in boxdata.keys) {
                      if (boxdata[key]['title'] == "task") {
                        if (boxdata[key]['subject'] == subjectInfo['name']) {
                          await _classmatebox.delete(key);
                        }
                      }
                    }

                    // delete subject
                    _classmatebox
                        .delete(widget.id)
                        .then((value) => Navigator.of(context).pop())
                        .then((value) => Navigator.of(context).pop());
                  },
                ),
              ],
            );
          });
    }

    void deleteTask(id, name) async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Are you sure you want\nto delete the task?',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      "$name",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(127, 188, 250, 1),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'DELETE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(245, 148, 148, 1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    _classmatebox
                        .delete(id)
                        .then((value) => Navigator.of(context).pop());
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

    return Scaffold(
      // app bar
      appBar: AppBar(
        title: Text(
          "${subjectInfo['name']}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(127, 188, 250, 1),
        elevation: 0.0,
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 0) {
                // move to edit subject
                await Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => EditSubject(
                      id: widget.id,
                    ),
                  ),
                )
                    .then((value) {
                  getSubjectInfo();
                });
              } else {
                // show alert dialog before delete
                alertDeleteSubject(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text(
                  "EDIT",
                  style: TextStyle(
                      color: Color.fromRGBO(255, 192, 144, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  "DELETE",
                  style: TextStyle(
                      color: Color.fromRGBO(245, 148, 148, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),

      // body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
              color: Colors.white24,
              border: Border.all(
                width: 1,
                color: Colors.white24,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5.0) // POINT
                  ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "TASK LIST",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // edit --------------------
                /*TextButton(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Text(
                        "EDIT",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 192, 144, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ,onPressed: ()async{
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditSubject(
                            id: widget.id,
                          ),
                        ),
                      );
                  },
                ),
                TextButton(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Text(
                      "DELETE",
                      style: TextStyle(
                        color: Color.fromRGBO(245, 148, 148, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  ,onPressed: (){alertDeleteSubject(context);},
                ),*/
              ],
            ),
          ),
          // list of tasks
          Expanded(
            child: ListView.separated(
              itemCount: _tasks.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${_tasks[index]['name']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                decoration: _tasks[index]['done']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                        ),
                        // edit --------------------
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!_tasks[index]['done']) {
                              editTask(_tasks[index]['id']);
                            }
                          },
                          child: Icon(
                            Icons.edit,
                            color: _tasks[index]['done']
                                ? Colors.grey
                                : Color.fromRGBO(255, 192, 144, 1),
                          ),
                        ),
                        // delete ------------------
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            deleteTask(
                                _tasks[index]['id'], _tasks[index]['name']);
                          },
                          child: Icon(Icons.delete,
                              color: Color.fromRGBO(245, 148, 148, 1)),
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
