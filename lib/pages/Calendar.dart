// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  var main_color = Colors.grey[500];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // calendar
        TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime(2020),
          lastDay: DateTime(2050),
          calendarFormat: _calendarFormat,
          onFormatChanged: (CalendarFormat format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: main_color,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            leftChevronVisible: false,
            rightChevronVisible: false,
            headerPadding: EdgeInsets.fromLTRB(0, 0, 0, 15),
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            // search activities here

            setState(
              () {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              },
            );
          },
        ),
        Divider(
          height: 10,
        ),

        // day activity details
        Expanded(
          child: Center(
              child: Text(
            "nothing planned for this day",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          )),
        ),
      ],
    );
  }
}
