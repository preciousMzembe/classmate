// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field, prefer_final_fields, non_constant_identifier_names

import 'package:classmate/pages/Calendar.dart';
import 'package:classmate/pages/Home.dart';
import 'package:classmate/pages/Timetable.dart';
import 'package:classmate/pages/sub_pages/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _nav_position = 0;
  void _navigate(int index) {
    setState(() {
      _nav_position = index;
    });
  }

  // list of main pages
  List _pages = [
    Home(),
    Calendar(),
    Timetable()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        title: Center(child:Icon(Icons.face, size: 30,)),
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(127, 188, 250, 1),
      ),
      // body
      body: _pages[_nav_position],
      // bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(127, 188, 250, 1),
        onTap: _navigate,
        currentIndex: _nav_position,
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month_rounded,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.grid_on_rounded,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
