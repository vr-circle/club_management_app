import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_collection.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:table_calendar/table_calendar.dart';

import 'schedule.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key, this.appState}) : super(key: key);
  final AppState appState;
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _selectedDay = DateTime.now();
  ScheduleCollection scheduleCollection;

  Future<LinkedHashMap<DateTime, List<Schedule>>> _futureSchedules;

  Future<LinkedHashMap<DateTime, List<Schedule>>> getScheduleData() async {
    final Map<DateTime, List<Schedule>> res = await dbService.getMonthSchedules(
        widget.appState.targetCalendarPageDate, false);
    scheduleCollection.initScheduleCollection(res);
    return scheduleCollection.schedules;
  }

  @override
  void initState() {
    print('initState in SchedulePage');
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
        appBar: AppBar(
          title: Row(
            children: [
              const FlutterLogo(),
              const Text('CMA'),
            ],
          ),
        ),
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
                  onPageChanged: (DateTime day) {
                    widget.appState.targetCalendarPageDate = day;
                    widget.appState.focusDay = day;
                  },
                  calendarBuilders: CalendarBuilders(singleMarkerBuilder:
                      (BuildContext context, DateTime data, Schedule event) {
                    Color color = Colors.red;
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
                  focusedDay: widget.appState.focusDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  eventLoader: getEventForDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        this._selectedDay = selectedDay;
                        widget.appState.focusDay = focusedDay;
                      });
                    } else if (isSameDay(
                        widget.appState.focusDay, selectedDay)) {
                      widget.appState.isOpenScheduleListView = true;
                      widget.appState.focusDay = selectedDay;
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
                                  widget.appState.selectedSchedule = e;
                                },
                              )))
                          .toList()),
                ]))
              ]);
            }));
  }
}
