// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, must_be_immutable, unused_field

import 'package:classmate/pages/add_subject.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _classmatebox = Hive.box("classmatebox");

  List _subjects = [];

  var main_color = Colors.grey[500];

  // get subjects and tasks
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

    // subject templet
    Widget subject(var subject) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: main_color,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              // subject title and date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${subject['name']}",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),

              // sub task
              // Column(
              //   children: [
              //     ClipRRect(
              //       borderRadius: BorderRadius.circular(12),
              //       child: Container(
              //         padding:
              //             EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              //         color: Colors.white,
              //         child: Row(
              //           children: [
              //             Expanded(
              //               // name
              //               child: Text(
              //                 "BMC",
              //                 style: TextStyle(fontSize: 12, color: main_color),
              //               ),
              //             ),
              //             SizedBox(
              //               width: 10,
              //             ),
              //             // left buttons
              //             Row(
              //               children: [
              //                 ClipRRect(
              //                   borderRadius: BorderRadius.circular(15),
              //                   child: Container(
              //                     width: 15,
              //                     height: 15,
              //                     color: main_color,
              //                   ),
              //                 ),
              //                 Icon(
              //                   Icons.arrow_forward_ios_rounded,
              //                   color: main_color,
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       height: 20,
              //     ),
              //   ],
              // ),

              // add task button
              GestureDetector(
                onTap: () async {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Center(
                      child: Icon(
                        Icons.add_circle_outline_rounded,
                        color: main_color,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: _subjects.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 20,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return subject(_subjects[index]);
            },
          ),
        ),

        // add subject button
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddSubject()),
            );
            getSubjects();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(10),
              color: main_color,
              child: Center(
                child: Icon(
                  Icons.add_circle_outline_rounded,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
