import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'schedule.dart';

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
    final res = await storeService.getSchedule();
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
    setState(() {
      if (_schedules.containsKey(schedule.start) == false)
        _schedules[schedule.start] = [];
      _schedules[schedule.start].add(schedule);
    });
  }

  void deleteSchedule(Schedule targetSchedule) {
    setState(() {
      _schedules[targetSchedule.start] = _schedules[targetSchedule.start]
          .where((schedule) => schedule.title != targetSchedule.title)
          .toList();
    });
  }

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
                          addSchedule: addSchedule,
                          deleteSchedule: deleteSchedule,
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
                                      builder: (context) => ScheduleDetails(
                                            schedule: e,
                                            deleteSchedule: deleteSchedule,
                                          )));
                                },
                              )))
                          .toList()),
                ]))
              ]);
            }));
  }
}

class ScheduleListOnDay extends StatefulWidget {
  ScheduleListOnDay(
      {Key key,
      @required this.addSchedule,
      @required this.deleteSchedule,
      @required this.schedules,
      this.targetDate})
      : super(key: key);
  final void Function(Schedule schedule) addSchedule;
  final void Function(Schedule schedule) deleteSchedule;
  List<Schedule> schedules;
  DateTime targetDate;
  @override
  _ScheduleListOnDayState createState() => _ScheduleListOnDayState();
}

class _ScheduleListOnDayState extends State<ScheduleListOnDay> {
  void addScheduleInListView(Schedule schedule) {
    setState(() {
      widget.addSchedule(schedule);
      widget.schedules.add(schedule);
    });
  }

  var _format = new DateFormat('yyyy/MM/dd(E)', 'ja_JP');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_format.format(widget.targetDate)),
        ),
        body: widget.schedules.isEmpty
            ? Center(child: Text('予定はありません'))
            : ListView(
                children: [
                  ...widget.schedules
                      .map((e) => Card(
                              child: ListTile(
                            title: Text(e.title),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ScheduleDetails(
                                        schedule: e,
                                        deleteSchedule: widget.deleteSchedule,
                                      )));
                            },
                          )))
                      .toList()
                ],
              ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ScheduleAddPage(
                  addSchedule: addScheduleInListView,
                  targetDate: widget.targetDate);
            }));
          },
        ));
  }
}

class ScheduleDetails extends StatelessWidget {
  ScheduleDetails({@required this.schedule, @required this.deleteSchedule});
  final void Function(Schedule schedule) deleteSchedule;
  final Schedule schedule;
  final _format = new DateFormat('yyyy/MM/dd(E) hh:mm', 'ja_JP');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(schedule.title),
        ),
        body: Column(children: [
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
                ListTile(
                  leading: Text('内容'),
                  title: Text(schedule.details),
                ),
              ],
            ),
          )),
        ]),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: () {
                // edit schedule
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ScheduleEditPage(schedule);
                }));
              },
            ),
            SizedBox(
              height: 16,
            ),
            FloatingActionButton(
              onPressed: () {
                deleteSchedule(schedule);
                Navigator.pop(context);
              },
              child: Icon(Icons.delete),
              backgroundColor: Colors.red,
            )
          ],
        ));
  }
}

class ScheduleAddPage extends StatefulWidget {
  ScheduleAddPage(
      {Key key, this.addSchedule, this.targetDate, DateTime initSchedule})
      : super(key: key);
  final void Function(Schedule schedule) addSchedule;
  final DateTime targetDate;
  @override
  _ScheduleAddPageState createState() => _ScheduleAddPageState();
}

class _ScheduleAddPageState extends State<ScheduleAddPage> {
  final _format = new DateFormat('yyyy/MM/dd(E)', 'ja_JP');

  TextEditingController startTextFiledController;
  TextEditingController endTextFiledController;
  List<String> targetUsers;
  String _selectedTargetUsers;

  @override
  void initState() {
    super.initState();
    this.startTextFiledController = new TextEditingController(
        text: DateFormat('yyyy/MM/dd HH:mm').format(widget.targetDate));
    this.endTextFiledController = new TextEditingController(
        text: DateFormat('yyyy/MM/dd HH:mm')
            .format(widget.targetDate.add(Duration(days: 1))));
    this.targetUsers = [
      'Private',
      'Club'
    ]; // todo: generate list from user setting
    this._selectedTargetUsers = 'Private';
  }

  Schedule newSchedule = new Schedule(
    title: '',
    place: '',
    start: DateTime.now(),
    end: DateTime.now(),
    details: '',
  );

  Future<DateTime> _selectTime(BuildContext context) async {
    TimeOfDay newSelectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newSelectedTime != null) {
      DateTime newDate = DateTime(
        widget.targetDate.year,
        widget.targetDate.month,
        widget.targetDate.day,
        newSelectedTime.hour,
        newSelectedTime.minute,
      );
      return newDate;
    } else {
      return widget.targetDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_format.format(widget.targetDate)),
      ),
      body: Padding(
          padding: EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('対象'),
                    DropdownButton(
                      value: _selectedTargetUsers,
                      items: this
                          .targetUsers
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          this._selectedTargetUsers = newValue;
                        });
                      },
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.title), labelText: 'タイトル'),
                  onChanged: (value) {
                    this.newSchedule.title = value;
                  },
                ),
                TextField(
                  decoration:
                      InputDecoration(icon: Icon(Icons.place), labelText: '場所'),
                  onChanged: (value) {
                    this.newSchedule.place = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.timer), labelText: '開始時刻'),
                  onTap: () async {
                    var newDate = await _selectTime(context);
                    startTextFiledController.text =
                        DateFormat('yyyy/MM/dd HH:mm').format(newDate);
                    this.newSchedule.start = newDate;
                  },
                  controller: this.startTextFiledController,
                  enableInteractiveSelection: false,
                  focusNode: FocusNode(),
                  readOnly: true,
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.timer), labelText: '終了時刻'),
                  onTap: () async {
                    var newDate = await _selectTime(context);
                    endTextFiledController.text =
                        DateFormat('yyyy/MM/dd HH:mm').format(newDate);
                    this.newSchedule.end = newDate;
                  },
                  controller: this.endTextFiledController,
                  enableInteractiveSelection: false,
                  focusNode: FocusNode(),
                  readOnly: true,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    icon: Icon(Icons.content_copy),
                    labelText: '内容',
                  ),
                  onChanged: (value) {
                    this.newSchedule.details = value;
                  },
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
                      onPressed: () async {
                        final format = DateFormat('yyyy/MM/dd HH:mm');
                        newSchedule.start =
                            format.parseStrict(startTextFiledController.text);
                        newSchedule.end =
                            format.parseStrict(endTextFiledController.text);
                        await storeService.addSchedule(this.newSchedule,
                            this._selectedTargetUsers == 'Private');
                        widget.addSchedule(this.newSchedule);
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

class ScheduleEditPage extends StatelessWidget {
  ScheduleEditPage(this._targetSchedule);
  final Schedule _targetSchedule;
  TextEditingController _endTimeTextEditingController;
  TextEditingController _startTimeTextEditingController;
  String newTitle = '';
  String newPlace = '';
  String newDetails = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_targetSchedule.title),
        ),
        body: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.title), labelText: 'タイトル'),
                  onChanged: (value) {
                    newTitle = value;
                  },
                ),
                TextField(
                  decoration:
                      InputDecoration(icon: Icon(Icons.place), labelText: '場所'),
                  onChanged: (value) {
                    newPlace = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.timer), labelText: '開始時刻'),
                  onTap: () async {
                    // var newDate = await _selectTime(context);
                    // endTextFiledController.text =
                    //     DateFormat('yyyy/MM/dd HH:mm').format(newDate);
                    // this.newSchedule.end = newDate;
                  },
                  controller: this._startTimeTextEditingController,
                  enableInteractiveSelection: false,
                  focusNode: FocusNode(),
                  readOnly: true,
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.timer), labelText: '終了時刻'),
                  onTap: () async {
                    // var newDate = await _selectTime(context);
                    // endTextFiledController.text =
                    //     DateFormat('yyyy/MM/dd HH:mm').format(newDate);
                    // this.newSchedule.end = newDate;
                  },
                  controller: this._endTimeTextEditingController,
                  enableInteractiveSelection: false,
                  focusNode: FocusNode(),
                  readOnly: true,
                ),
                TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.content_copy), labelText: '内容'),
                  onChanged: (value) {
                    newDetails = value;
                  },
                ),
              ],
            )));
  }
}