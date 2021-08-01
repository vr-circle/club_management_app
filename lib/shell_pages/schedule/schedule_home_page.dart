import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'schedule.dart';

class ScheduleHomePage extends StatefulWidget {
  ScheduleHomePage({
    Key key,
    @required this.userId,
    @required this.personalEventColor,
    @required this.organizationEventColor,
    @required this.loadSchedulesForMonth,
    @required this.targetCalendarMonth,
    @required this.getEventsForDay,
    @required this.handleChangeTargetCalendarMonth,
    @required this.handleChangeDayForScheduleListView,
    @required this.handleChangeSelectedSchedule,
  }) : super(key: key);
  final String userId;
  final Future<void> Function(DateTime targetMonth) loadSchedulesForMonth;
  final List<Schedule> Function(DateTime day) getEventsForDay;
  final DateTime targetCalendarMonth;
  final Color personalEventColor;
  final Color organizationEventColor;
  final void Function(DateTime day) handleChangeTargetCalendarMonth;
  final void Function(DateTime day) handleChangeDayForScheduleListView;
  final void Function(Schedule schedule) handleChangeSelectedSchedule;
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
    this._selectedDay = DateTime.now();
    widget.loadSchedulesForMonth(widget.targetCalendarMonth);
    this._future = _getSchedulesForMonth();
    super.initState();
  }

  Future<bool> _getSchedulesForMonth() async {
    await widget.loadSchedulesForMonth(widget.targetCalendarMonth);
    return true;
  }

  List<Schedule> _getEventForDay(DateTime day) {
    return widget.getEventsForDay(day);
  }

  void _onPageChanged(DateTime day) {
    widget.handleChangeTargetCalendarMonth(day);
    this._getSchedulesForMonth();
  }

  void _onDaySelected(DateTime newSelectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, newSelectedDay)) {
      setState(() {
        this._selectedDay = newSelectedDay;
        widget.handleChangeTargetCalendarMonth(focusedDay);
      });
    } else if (isSameDay(widget.targetCalendarMonth, newSelectedDay)) {
      widget.handleChangeDayForScheduleListView(widget.targetCalendarMonth);
    }
  }

  bool _selectedDayPredicate(DateTime day) {
    return isSameDay(_selectedDay, day);
  }

  CalendarBuilders<Schedule> _getCalendarBuilder() {
    final res = CalendarBuilders<Schedule>(singleMarkerBuilder:
        (BuildContext context, DateTime date, Schedule event) {
      Color _color = event.createdBy == widget.userId
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
                  focusedDay: widget.targetCalendarMonth,
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
                                  widget.handleChangeSelectedSchedule(e);
                                },
                              )))
                          .toList()),
                ]))
              ]);
            }));
  }
}
