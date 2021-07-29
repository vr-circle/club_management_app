import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'schedule.dart';

class ScheduleHomePage extends StatefulWidget {
  ScheduleHomePage({
    Key key,
    @required this.appState,
    @required this.participatingOrganizationIdList,
    @required this.personalEventColor,
    @required this.organizationEventColor,
  }) : super(key: key);
  final AppState appState;
  final List<String> participatingOrganizationIdList;
  final Color personalEventColor;
  final Color organizationEventColor;
  @override
  _ScheduleHomePageState createState() => _ScheduleHomePageState();
}

class _ScheduleHomePageState extends State<ScheduleHomePage> {
  final DateTime _firstDay = DateTime.utc(DateTime.now().year - 4, 1, 1);
  final DateTime _lastDay = DateTime.utc(DateTime.now().year + 10, 1, 1);
  Future<bool> _future;
  DateTime _selectedDay;

  @override
  void initState() {
    print('initState in ScheduleHomePage');
    this._selectedDay = DateTime.now();
    widget.appState.getSchedulesForMonth(widget.appState.targetCalendarMonth);
    this._future = _getSchedulesForMonth();
    super.initState();
  }

  Future<bool> _getSchedulesForMonth() async {
    await widget.appState
        .getSchedulesForMonth(widget.appState.targetCalendarMonth);
    return true;
  }

  List<Schedule> _getEventForDay(DateTime day) {
    return widget.appState.getScheduleForDay(day);
  }

  void _onPageChanged(DateTime day) {
    widget.appState.targetCalendarMonth = day;
    this._getSchedulesForMonth();
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
          ? widget.personalEventColor
          : widget.organizationEventColor;
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
                                trailing: Text(
                                    '${DateFormat('HH:mm').format(e.start)} ~ ${DateFormat('HH:mm').format(e.end)}'),
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
