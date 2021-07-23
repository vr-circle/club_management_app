import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule_collection.dart';
import 'package:table_calendar/table_calendar.dart';

import 'schedule.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key, this.appState}) : super(key: key);
  final AppState appState;
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final DateTime _firstDay = DateTime.utc(DateTime.now().year - 4, 1, 1);
  final DateTime _lastDay = DateTime.utc(DateTime.now().year + 10, 1, 1);
  Future<bool> _future;
  DateTime _selectedDay;
  ScheduleCollection _scheduleCollection;

  @override
  void initState() {
    _scheduleCollection.addListener(() {
      setState(() {});
    });
    print('initState in SchedulePage');
    this._selectedDay = DateTime.now();
    widget.appState.getScheduleForMonth();
    this._future = _getSchedulesForMonth();
    super.initState();
  }

  Future<bool> _getSchedulesForMonth() async {
    await widget.appState.getScheduleForMonth();
    return true;
  }

  List<Schedule> _getEventForDay(DateTime day) {
    return widget.appState.getScheduleForDay(day);
  }

  void _onPageChanged(DateTime day) {
    print('onPageChanged');
    widget.appState.targetCalendarMonth = day;
    this._getSchedulesForMonth(day, false);
  }

  void _onDaySelected(DateTime newSelectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, newSelectedDay)) {
      setState(() {
        this._selectedDay = newSelectedDay;
        widget.appState.targetCalendarMonth = focusedDay;
      });
    } else if (isSameDay(widget.appState.targetCalendarMonth, newSelectedDay)) {
      widget.appState.selectedDayForScheduleList =
          widget.appState.targetCalendarMonth;
    }
  }

  bool _selectedDayPredicate(DateTime day) {
    return isSameDay(_selectedDay, day);
  }

  CalendarBuilders<Schedule> _getCalendarBuilder() {
    final res = CalendarBuilders<Schedule>(singleMarkerBuilder:
        (BuildContext context, DateTime date, Schedule event) {
      Color _color = event.createdBy == widget.appState.user.uid
          ? Colors.blue
          : Colors.red;
      // todo: change color by event.createdBy;
      if (event.title == 'title') {
        _color = Colors.blue;
      }
      return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
        width: 7,
        height: 7,
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
      );
    });
    return res;
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
            future: this._future,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              }
              return Column(children: [
                TableCalendar(
                  locale: 'en_US',
                  calendarFormat: CalendarFormat.month,
                  firstDay: _firstDay,
                  lastDay: _lastDay,
                  focusedDay: widget.appState.targetCalendarMonth,
                  calendarBuilders: _getCalendarBuilder(),
                  onPageChanged: _onPageChanged,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  selectedDayPredicate: _selectedDayPredicate,
                  eventLoader: _getEventForDay,
                  onDaySelected: _onDaySelected,
                ),
                Expanded(
                    child: ListView(shrinkWrap: true, children: [
                  Column(
                      children: _getEventForDay(_selectedDay)
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
