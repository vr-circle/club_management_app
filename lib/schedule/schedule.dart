import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../user_settings/settings.dart';

var _uuid = Uuid();

class Schedule {
  Schedule({String id, this.title, this.start, this.end, this.place})
      : id = id ?? _uuid.v4();
  String id;
  String title;
  String place;
  DateTime start;
  DateTime end;
}

final eventMapProvider =
    StateNotifierProvider<EventMapStateNotifier, Map<DateTime, List>>(
        (ref) => EventMapStateNotifier());

class EventMapStateNotifier extends StateNotifier<Map<DateTime, List>> {
  EventMapStateNotifier() : super(Map<DateTime, List>());
}

final focusDayProvider =
    StateNotifierProvider<FocusDay, DateTime>((refs) => FocusDay());

class FocusDay extends StateNotifier<DateTime> {
  FocusDay() : super(DateTime.now());
  void updateFocusDay(day) {
    this.state = day;
  }
}

final selectedDayProvider = StateNotifierProvider((refs) => SelectedDay());

class SelectedDay extends StateNotifier<DateTime> {
  SelectedDay() : super(DateTime.now());
  void updateSelectedDay(day) {
    this.state = day;
  }
}

final calendarScreenProvider =
    StateNotifierProvider((refs) => CalendarScreen());

class CalendarScreenState {
  // CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List> _eventList = {};
}

class CalendarScreen extends StateNotifier<CalendarScreenState> {
  CalendarScreen() : super(CalendarScreenState());
}

class SchedulePage extends HookWidget {
  static const String route = '/schedule';
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Map<DateTime, List<Schedule>> _eventsList = {
    DateTime.now(): [
      Schedule(
          title: 'hoghoge',
          start: DateTime.now(),
          end: DateTime.now(),
          place: 'place_01'),
      Schedule(
          title: 'fugafuga',
          start: DateTime.now(),
          end: DateTime.now(),
          place: 'place_01'),
      Schedule(
          title: 'piyopiyo',
          start: DateTime.now(),
          end: DateTime.now(),
          place: 'place_01'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List<Schedule> _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    final _focusDay = useProvider(focusDayProvider);
    final _selectedDay = useProvider(selectedDayProvider);
    const CalendarFormat _calendarFormat = CalendarFormat.month;

    return Scaffold(
        body: Column(children: [
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
              shape: BoxShape.circle,
              color: useProvider(darkModeProvider) == true
                  ? Colors.white
                  : Colors.black),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        eventLoader: _getEventForDay,
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            context
                .read(selectedDayProvider.notifier)
                .updateSelectedDay(selectedDay);
            context.read(focusDayProvider.notifier).updateFocusDay(focusedDay);
          }
          if (isSameDay(_focusDay, selectedDay)) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ScheduleListOnDay(
                targetDate: selectedDay,
                schedules: _getEventForDay(selectedDay),
              );
            }));
          }
        },
      ),
      Expanded(
          child: ListView(shrinkWrap: true, children: [
        Column(
            children: _getEventForDay(_selectedDay)
                .map((e) => Card(
                        child: ListTile(
                      title: Text(e.title),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ScheduleDetails(schedule: e)));
                      },
                    )))
                .toList()),
      ]))
    ]));
  }
}

class NonScheduleListOnDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('予定はありません'),
    );
  }
}

class ScheduleListOnDay extends HookWidget {
  ScheduleListOnDay(
      {Key key, @required this.targetDate, @required this.schedules})
      : super(key: key);
  final List<Schedule> schedules;
  final DateTime targetDate;
  var _format = new DateFormat('yyyy/MM/dd(E)', 'ja_JP');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_format.format(DateTime.now())),
      ),
      body: schedules.isEmpty
          ? NonScheduleListOnDay()
          : ListView(
              children: [
                ...schedules
                    .map((e) => Card(
                            child: ListTile(
                          title: Text(e.title),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ScheduleDetails(schedule: e)));
                          },
                        )))
                    .toList()
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class ScheduleDetails extends HookWidget {
  ScheduleDetails({@required this.schedule});
  Schedule schedule;
  final _format = new DateFormat('yyyy/MM/dd(E) hh:mm', 'ja_JP');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(schedule.title), // fix
      ),
      body: Column(children: [
        // show details
        Expanded(
            child: Container(
          child: Column(
            children: [
              ListTile(
                leading: Text('開始時刻'),
                title: Text(_format.format(schedule.start)),
              ),
              ListTile(
                leading: Text('終了時刻'),
                title: Text(_format.format(schedule.end)),
              ),
              ListTile(
                leading: Text('場所'),
                title: Text(schedule.place),
              ),
            ],
          ),
        )),
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {},
      ),
    );
  }
}

class ScheduleAddPage extends HookWidget {
  final DateTime targetDate;
  final _format = new DateFormat('yyyy/MM/dd(E)', 'ja_JP');
  ScheduleAddPage({Key key, @required this.targetDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_format.format(targetDate)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const <Widget>[
            Text('title'),
            TextField(),
            Text('time'),
            TextField(),
            Text('place'),
            TextField(),
            Text('datail'),
            TextField(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 50,
                child: Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("追加")),
                )),
            SizedBox(
                height: 50,
                child: Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("キャンセル")),
                )),
          ],
        ),
      ),
    );
  }
}
