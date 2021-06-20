import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:table_calendar/table_calendar.dart';

import 'schedule.dart';
import 'schedule_details.dart';
import 'schedule_list_on_day.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key}) : super(key: key);
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  LinkedHashMap<DateTime, List<Schedule>> _schedules = LinkedHashMap();
  Future<LinkedHashMap<DateTime, List<Schedule>>> _futureSchedules;

  Future<LinkedHashMap<DateTime, List<Schedule>>> getScheduleData() async {
    final res =
        await storeService.getSchedule(['circle']); // todo: circle -> name
    _schedules = LinkedHashMap(equals: isSameDay, hashCode: getHashCode)
      ..addAll(res);
    return _schedules;
  }

  @override
  void initState() {
    this._futureSchedules = getScheduleData();
    super.initState();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Future<void> addSchedule(Schedule schedule, String target) async {
    await storeService.addSchedule(schedule, target);
    setState(() {
      if (_schedules.containsKey(schedule.start) == false) {
        print('contain');
        _schedules[schedule.start] = [];
      }
      _schedules[schedule.start].add(schedule);
      print('added');
    });
  }

  Future<void> deleteSchedule(Schedule targetSchedule) async {
    await storeService.deleteSchedule(targetSchedule);
    setState(() {
      _schedules[targetSchedule.start] = _schedules[targetSchedule.start]
          .where((schedule) => schedule.title != targetSchedule.title)
          .toList();
    });
  }

  void editSchedule(Schedule targeet) {}

  List<Schedule> getEventForDay(DateTime day) {
    return _schedules[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    const CalendarFormat _calendarFormat = CalendarFormat.month;

    return Scaffold(
        body: FutureBuilder(
            future: this._futureSchedules,
            builder: (context,
                AsyncSnapshot<LinkedHashMap<DateTime, List<Schedule>>>
                    snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(children: [
                TableCalendar(
                  locale: 'en_US',
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2050, 12, 31),
                  focusedDay: _focusDay,
                  calendarFormat: _calendarFormat,
                  calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  eventLoader: getEventForDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      // updateSelectedDay & update FocusDay
                      setState(() {
                        this._selectedDay = selectedDay;
                        this._focusDay = focusedDay;
                      });
                    } else if (isSameDay(_focusDay, selectedDay)) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return ScheduleListOnDay(
                          targetDate: selectedDay,
                          schedules: getEventForDay(selectedDay),
                          addSchedule: addSchedule,
                          deleteSchedule: deleteSchedule,
                        );
                      }));
                    }
                  },
                ),
                Expanded(
                    child: ListView(shrinkWrap: true, children: [
                  Column(
                      children: getEventForDay(_selectedDay)
                          .map((e) => Card(
                                  child: ListTile(
                                title: Text(e.title),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ScheduleDetails(
                                            schedule: e,
                                            deleteSchedule: deleteSchedule,
                                          )));
                                },
                              )))
                          .toList()),
                ]))
              ]);
            }));
  }
}
