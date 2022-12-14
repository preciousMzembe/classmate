// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, must_be_immutable, unused_field

import 'package:classmate/pages/sub_pages/Subject.dart';
import 'package:classmate/pages/sub_pages/add_subject.dart';
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

  var main_color = Colors.orangeAccent;
  final TextEditingController _subject = TextEditingController();

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

  bool isChecked = true;

  @override
  void initState() {
    getSubjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // add subject
    void addSubjectSheet() async {

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddSubject(),
        ),
      );

      getSubjects();
    }

    // subject templet
    Widget subject(var subject) {
      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Subject(
                id: subject["id"],
              ),
            ),
          );

          getSubjects();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: main_color,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(""),
                ),
                Icon(
                  Icons.my_library_books_rounded,
                  size: 40,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${subject['name']}".toUpperCase(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(""),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Subjects",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // List of all subjects
              _subjects.isNotEmpty ? GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                ),
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  return subject(_subjects[index]);
                },
              ):
              Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off_rounded,size: 50,),
                    SizedBox(height: 10,),
                    Text("You have no subjects"),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              // Text(
              //   "Today",
              //   overflow: TextOverflow.ellipsis,
              //   maxLines: 2,
              //   softWrap: true,
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 16,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              //
              // // activity list
              // Row(
              //   children: [
              //     // mark
              //     Column(
              //       children: [
              //         Stack(
              //           alignment: Alignment.center,
              //           children: [
              //             ClipRRect(
              //               borderRadius: BorderRadius.circular(20),
              //               child: Container(
              //                 width: 15,
              //                 height: 15,
              //                 color: Colors.grey,
              //               ),
              //             ),
              //             ClipRRect(
              //               borderRadius: BorderRadius.circular(20),
              //               child: Container(
              //                 width: 10,
              //                 height: 10,
              //                 color: Colors.white,
              //               ),
              //             ),
              //           ],
              //         ),
              //         Container(
              //           width: 3,
              //           height: 40,
              //           color: Colors.grey,
              //         ),
              //       ],
              //     ),
              //
              //     // activity details
              //     SizedBox(
              //       width: 5,
              //     ),
              //     Expanded(
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             "ICT APPLICATION",
              //             overflow: TextOverflow.ellipsis,
              //             maxLines: 1,
              //             softWrap: true,
              //           ),
              //         ],
              //       ),
              //     ),
              //
              //     // time or check box
              //     Center(
              //       child: Text("11:00am"),
              //     ),
              //   ],
              // ),
              //
              // Row(
              //   children: [
              //     // mark
              //     Column(
              //       children: [
              //         Stack(
              //           alignment: Alignment.center,
              //           children: [
              //             ClipRRect(
              //               borderRadius: BorderRadius.circular(20),
              //               child: Container(
              //                 width: 15,
              //                 height: 15,
              //                 color: Color(0xff75ccb9),
              //               ),
              //             ),
              //             ClipRRect(
              //               borderRadius: BorderRadius.circular(20),
              //               child: Container(
              //                 width: 10,
              //                 height: 10,
              //                 color: Color(0xff75ccb9),
              //               ),
              //             ),
              //           ],
              //         ),
              //         Container(
              //           width: 3,
              //           height: 40,
              //           color: Color(0xff75ccb9),
              //         ),
              //       ],
              //     ),
              //
              //     // activity details
              //     SizedBox(
              //       width: 5,
              //     ),
              //     Expanded(
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             "ICT APPLICATION",
              //             overflow: TextOverflow.ellipsis,
              //             maxLines: 1,
              //             softWrap: true,
              //           ),
              //           Text(
              //             "Submit Assignment",
              //             overflow: TextOverflow.ellipsis,
              //             maxLines: 1,
              //             softWrap: true,
              //           ),
              //         ],
              //       ),
              //     ),
              //
              //     // time or check box
              //     Center(
              //       child: Checkbox(
              //         checkColor: Colors.white,
              //         activeColor: Colors.grey,
              //         value: isChecked,
              //         onChanged: (bool? value) {
              //           setState(() {
              //             isChecked = value!;
              //           });
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              //
            ],
          ),
        ),
      ),

      // add subject button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addSubjectSheet();
        },
        child: Icon(
          Icons.add,
          color: Color(0xffdbffff),
        ),
      ),
    );
  }
}
