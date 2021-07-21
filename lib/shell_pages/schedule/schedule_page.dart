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
  DateTime _firstDay = DateTime.utc(DateTime.now().year - 4, 1, 1);
  DateTime _lastDay = DateTime.utc(DateTime.now().year + 10, 1, 1);
  Future<bool> _future;
  DateTime _selectedDay;
  DateTime _focusDay;
  ScheduleCollection _scheduleCollection;

  @override
  void initState() {
    print('initState in SchedulePage');
    this._selectedDay = DateTime.now();
    this._focusDay = DateTime.now();
    this._scheduleCollection = ScheduleCollection();
    this._future =
        _getSchedulesForMonth(widget.appState.targetCalendarMonth, false);
    super.initState();
  }

  Future<bool> _getSchedulesForMonth(DateTime targetMonth, bool isAll) async {
    // await Future.delayed(Duration(seconds: 2));
    await _scheduleCollection.getSchedulesForMonth(
        widget.appState.targetCalendarMonth, isAll);
    setState(() {});
    return true;
  }

  List<Schedule> _getEventForDay(DateTime day) {
    return _scheduleCollection.getScheduleList(day);
  }

  void _onPageChanged(DateTime day) {
    print('onPageChanged');
    widget.appState.targetCalendarMonth = day;
    _getSchedulesForMonth(day, false);
    setState(() {
      // todo: false -> userSetting
      _focusDay = day;
    });
  }

  void _onDaySelected(DateTime newSelectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, newSelectedDay)) {
      setState(() {
        this._selectedDay = newSelectedDay;
        this._focusDay = focusedDay;
      });
    } else if (isSameDay(_focusDay, newSelectedDay)) {
      widget.appState.selectedDayForScheduleList = _focusDay;
    }
  }

  bool _selectedDayPredicate(DateTime day) {
    return isSameDay(_selectedDay, day);
  }

  CalendarBuilders<Schedule> _getCalendarBuilder() {
    final res = CalendarBuilders<Schedule>(singleMarkerBuilder:
        (BuildContext context, DateTime date, Schedule event) {
      Color _color = Colors.red;
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
                  focusedDay: _focusDay,
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
