// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, must_be_immutable, unused_field

import 'package:classmate/pages/sub_pages/Subject.dart';
import 'package:classmate/pages/sub_pages/add_subject.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> _sendAnalyticsEvent() async {
    await FirebaseAnalytics.instance.logEvent(
      name: "select_content",
      parameters: null,
    );
  }

  final _classmatebox = Hive.box("classmatebox");
  List _subjects = [];

  var main_color = Colors.grey[300];
  final TextEditingController _subject = TextEditingController();

  // get subjects and tasks
  void getSubjects() async {
    var tempData = [];
    var boxdata = _classmatebox.toMap();
    for (var key in boxdata.keys) {
      // _classmatebox.delete(key);
      if (boxdata[key]['title'] == "subject") {
        var subject = {
          "id": key,
          "name": boxdata[key]['name'],
          'color': boxdata[key]['color'],
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
            decoration: BoxDecoration(
              color: subject['color'] != null
                  ? Color(subject['color'])
                  : main_color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  offset: Offset(4, 4),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
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
                  color: Colors.white,
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
                    color: Colors.white,
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
      /*appBar: AppBar(
        title: Text("Classmate"),
        elevation: 0.0,
        backgroundColor: Colors.grey[800],
      ),*/
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*Text(
                "My Subjects",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),*/
              SizedBox(
                height: 20,
              ),

              // List of all subjects
              _subjects.isNotEmpty
                  ? GridView.builder(
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
                    )
                  : Container(
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Icon(
                            Icons.book_rounded,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "ADD YOUR SUBJECT",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400]),
                            textAlign: TextAlign.center,
                          ),
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
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Color.fromRGBO(127, 188, 250, 1),
          onPressed: () async {
            _sendAnalyticsEvent();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddSubject(),
              ),
            );
            getSubjects();
          },
          elevation: 0,
          label: Icon(
            Icons.add,
            color: Colors.white,
          ),

          // color: Colors.white

          // icon: Icon(
          //   Icons.add,
          //   color: Colors.white,
          // ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     addSubjectSheet();
      //   },
      //   child: Icon(
      //     Icons.add,
      //     color: Color(0xffdbffff),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
