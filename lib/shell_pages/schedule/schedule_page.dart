import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_collection.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:table_calendar/table_calendar.dart';

import 'schedule.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({
    Key key,
    @required this.handleOpenListPage,
    @required this.handleSelectSchedule,
  }) : super(key: key);
  final void Function(DateTime day) handleOpenListPage;
  final void Function(Schedule schedule) handleSelectSchedule;
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  ScheduleCollection scheduleCollection;

  Future<LinkedHashMap<DateTime, List<Schedule>>> _futureSchedules;

  Future<LinkedHashMap<DateTime, List<Schedule>>> getScheduleData() async {
    final Map<DateTime, List<Schedule>> res = await dbService.getSchedules('');
    scheduleCollection.initScheduleCollection(res);
    return scheduleCollection.schedules;
  }

  @override
  void initState() {
    scheduleCollection = ScheduleCollection();
    this._futureSchedules = getScheduleData();
    super.initState();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List<Schedule> getEventForDay(DateTime day) {
    return scheduleCollection.getScheduleList(day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: this._futureSchedules,
            builder: (context,
                AsyncSnapshot<LinkedHashMap<DateTime, List<Schedule>>>
                    snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              }
              return Column(children: [
                TableCalendar(
                  calendarBuilders: CalendarBuilders(singleMarkerBuilder:
                      (BuildContext context, DateTime data, Schedule event) {
                    Color color =
                        event.createdBy == 'private' ? Colors.blue : Colors.red;
                    return Container(
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: color),
                    );
                  }),
                  locale: 'en_US',
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2050, 12, 31),
                  focusedDay: _focusDay,
                  calendarFormat: _calendarFormat,
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
                      widget.handleOpenListPage(selectedDay);
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
                                  widget.handleSelectSchedule(e);
                                  widget.handleOpenListPage(_selectedDay);
                                },
                              )))
                          .toList()),
                ]))
              ]);
            }));
  }
}
