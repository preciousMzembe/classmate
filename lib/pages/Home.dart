// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:classmate/main.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var main_color = Colors.grey[500];

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: 2,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 20,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return subject();
            },
          ),
        ),

        // add tast button
        SizedBox(
          height: 10,
        ),
        ClipRRect(
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
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget subject() {
    var main_color = Colors.grey[500];

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
                    "ICT Application Development",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "03 October",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            // sub tasks
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          // name
                          child: Text(
                            "BMC",
                            style: TextStyle(fontSize: 12, color: main_color),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // left buttons
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                width: 15,
                                height: 15,
                                color: main_color,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: main_color,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),

            // add task button
            ClipRRect(
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
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
