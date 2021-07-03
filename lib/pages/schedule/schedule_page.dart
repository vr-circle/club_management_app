import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/pages/schedule/schedule_collection.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:table_calendar/table_calendar.dart';

import 'schedule.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({
    Key key,
    @required this.handleOpenList,
    @required this.scheduleCollection,
    @required this.handleChangePage,
    @required this.appState,
  }) : super(key: key);
  final MyAppState appState;
  final void Function(DateTime day) handleOpenList;
  final void Function(DateTime day) handleChangePage;
  final ScheduleCollection scheduleCollection;
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Future<LinkedHashMap<DateTime, List<Schedule>>> _futureSchedules;

  Future<LinkedHashMap<DateTime, List<Schedule>>> getScheduleData() async {
    final Map<DateTime, List<Schedule>> res =
        await storeService.getSchedule(['circle']); // todo: circle -> name
    widget.scheduleCollection.initScheduleCollection(res);
    return widget.scheduleCollection.schedules;
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
      if (widget.scheduleCollection.schedules.containsKey(schedule.start) ==
          false) {
        widget.scheduleCollection.schedules[schedule.start] = [];
      }
      widget.scheduleCollection.schedules[schedule.start].add(schedule);
    });
  }

  Future<void> deleteSchedule(Schedule targetSchedule) async {
    widget.scheduleCollection.deleteSchedule(targetSchedule);
    setState(() {});
  }

  void editSchedule(Schedule targeet) {}

  List<Schedule> getEventForDay(DateTime day) {
    return widget.scheduleCollection.schedules[day] ?? [];
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
                  // // if you wanna change colors in calendar markers
                  // calendarBuilders: CalendarBuilders(singleMarkerBuilder:
                  //     (BuildContext context, DateTime data, Schedule event) {
                  //   Color color = event.createdBy == 'private'
                  //       ? Colors.blue
                  //       : Colors.red;
                  //   return Container(
                  //     decoration:
                  //         BoxDecoration(shape: BoxShape.circle, color: color),
                  //   );
                  // }),
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
                      setState(() {
                        this._selectedDay = selectedDay;
                        this._focusDay = focusedDay;
                      });
                    } else if (isSameDay(_focusDay, selectedDay)) {
                      widget.handleOpenList(selectedDay);
                    }
                  },
                  onPageChanged: (DateTime day) {
                    widget.handleChangePage(day);
                    print(day);
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
                                  widget.appState.selectedSchedule = e;
                                  widget.appState.selectedDay = e.start;
                                },
                              )))
                          .toList()),
                ]))
              ]);
            }));
  }
}
