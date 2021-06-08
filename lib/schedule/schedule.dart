import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../user_settings/settings.dart';

class Schedule {
  const Schedule({this.id, this.title, this.start, this.end});
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
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
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Map<DateTime, List> _eventsList = {
    DateTime.now(): [
      'hogehoge',
      'fugafuga',
      'aaaaaaaa',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    final _focusDay = useProvider(focusDayProvider);
    final _selectedDay = useProvider(selectedDayProvider);
    const CalendarFormat _calendarFormat = CalendarFormat.month;

    return Column(children: [
      TableCalendar(
        locale: 'ja_JP',
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
              return ScheduleListOnDay(targetDate: selectedDay);
            }));
          }
        },
      ),
      Expanded(
          child: ListView(shrinkWrap: true, children: [
        Column(
            children: _getEventForDay(_selectedDay)
                .map((e) => ListTile(
                      title: Text(e.toString()),
                    ))
                .toList()),
      ]))
    ]);
  }
}

class ScheduleListOnDay extends HookWidget {
  ScheduleListOnDay({Key key, @required this.targetDate}) : super(key: key);
  final DateTime targetDate;
  var _format = new DateFormat('yyyy/MM/dd(E)', 'ja_JP');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_format.format(DateTime.now())),
        ),
        body: ListView(
          children: [
            Card(
              child: ListTile(
                title: Text("hoge"),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ScheduleDetails();
                })),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("hoge"),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ScheduleDetails();
                })),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("hoge"),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ScheduleDetails();
                })),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("hoge"),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ScheduleDetails();
                })),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ScheduleAddPage(
                        targetDate: targetDate,
                      );
                    }));
                  },
                  child:
                      SizedBox(height: 50, child: Center(child: Text("Add")))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                      height: 50, child: Center(child: Text("Close")))),
            ],
          ),
        ));
  }
}

class ScheduleDetails extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("XXXX年OO月TT日"),
        ),
        body: Column(children: [
          // show details
          Expanded(child: Container(child: Text("hogehoge"))),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "delete",
                      )),
                ),
                SizedBox(
                  height: 50,
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Edit",
                      )),
                ),
                SizedBox(
                  height: 50,
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "cancel",
                      )),
                ),
              ],
            ),
          )
        ]));
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
          children: [
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
                      child: Text("追加")),
                )),
            SizedBox(
                height: 50,
                child: Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("キャンセル")),
                )),
          ],
        ),
      ),
    );
  }
}
