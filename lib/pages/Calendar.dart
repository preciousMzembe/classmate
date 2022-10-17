// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final _classmatebox = Hive.box("classmatebox");
  var main_color = Colors.orangeAccent;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Map<DateTime, List<dynamic>> _events = {};

  void getEvents() {
    Map<DateTime, List<dynamic>> data = {};
    var boxdata = _classmatebox.toMap();
    for (var key in boxdata.keys) {
      if (boxdata[key]['title'] == "task") {
        // _classmatebox.delete(key);
        if (boxdata[key]['date'] != null) {
          DateTime date = DateTime.parse(boxdata[key]['date']);
          date = DateTime.parse(
              DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date));
          if (data[date] == null) data[date] = [];
          var event = [key, boxdata[key]['name'], boxdata[key]['done']];
          data[date]!.add(event);
        }
      }
    }
    setState(() {
      _events = data;
    });
  }

  List<dynamic> getSelectedDay(DateTime date) {
    return _events[date] ?? [];
  }

  List dayEvents = [];
  void getDayEvents() {
    setState(() {
      dayEvents = getSelectedDay(_selectedDay);
    });

    DateTime date = DateTime.parse(
        DateFormat("yyyy-MM-dd").format(_selectedDay));
    date = DateTime.parse(
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date));
    setState(() {
      dayEvents = getSelectedDay(date);
    });
  }

  @override
  void initState() {
    getEvents();
    getDayEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // calendar
            TableCalendar(
              eventLoader: getSelectedDay,
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
                  color: Colors.deepOrangeAccent,
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

                getDayEvents();
              },
            ),
            Divider(
              height: 10,
            ),

            // day activity details
            SizedBox(
              height: 5,
            ),
            Text(
              "Events",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: dayEvents.isNotEmpty
                  ? ListView.separated(
                      itemCount: dayEvents.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${dayEvents[index][1]}"),
                              Checkbox(
                                checkColor: Colors.orangeAccent,
                                activeColor: Colors.orangeAccent,
                                value: dayEvents[index][2],
                                onChanged: (bool? value) {
                                  // change and fetch events
                                  var data = dayEvents[index];
                                  data[2] = !data[2];
                                  // print(data);
                                  var boxData = _classmatebox.get(data[0]);
                                  boxData['done'] = data[2];
                                  // print(boxData);

                                  _classmatebox.put(data[0], boxData);
                                  getEvents();
                                  getDayEvents();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "nothing planned for this day",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
