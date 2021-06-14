import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/store_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../user_settings/settings.dart';

// todo: show timePicker in ScheduleAddPage
// todo: cooperate with firestore

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
    final res = await storeService.getPrivateSchedule();
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

  void addSchedule(Schedule schedule) {
    _schedules[schedule.start].add(schedule);
    storeService.addSchedule(schedule, true);
  }

  void deleteSchedule(Schedule schedule) {}

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
                                      builder: (context) =>
                                          ScheduleDetails(schedule: e)));
                                },
                              )))
                          .toList()),
                ]))
              ]);
            }));
  }
}

class ScheduleListOnDay extends StatelessWidget {
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
        title: Text(_format.format(targetDate)),
      ),
      body: schedules.isEmpty
          ? Center(child: Text('予定はありません'))
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
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ScheduleAddPage(targetDate: targetDate);
          }));
        },
      ),
    );
  }
}

class ScheduleDetails extends StatelessWidget {
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
        onPressed: () {
          // edit schedule
        },
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
      body: Padding(
          padding: EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.title), labelText: 'タイトル'),
                ),
                TextField(
                  decoration:
                      InputDecoration(icon: Icon(Icons.place), labelText: '場所'),
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.timer), labelText: '開始時刻'),
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.timer), labelText: '終了時刻'),
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  decoration: InputDecoration(
                    icon: Icon(Icons.content_copy),
                    labelText: '内容',
                  ),
                ),
              ],
            ),
          )),
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
