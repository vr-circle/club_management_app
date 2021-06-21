import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'schedule.dart';
import 'schedule_details.dart';
import 'schedule_add.dart';

class ScheduleListOnDay extends StatefulWidget {
  ScheduleListOnDay(
      {Key key,
      @required this.handleOpenScheduleDetails,
      @required this.addSchedule,
      @required this.deleteSchedule,
      @required this.schedules,
      @required this.targetDate})
      : super(key: key);
  final void Function(Schedule schedule) handleOpenScheduleDetails;
  final Future<void> Function(Schedule schedule, String target) addSchedule;
  final Future<void> Function(Schedule schedule) deleteSchedule;
  final DateTime targetDate;
  List<Schedule> schedules;
  @override
  _ScheduleListOnDayState createState() => _ScheduleListOnDayState();
}

class _ScheduleListOnDayState extends State<ScheduleListOnDay> {
  Future<void> addScheduleInListView(Schedule schedule, String target) async {
    await widget.addSchedule(schedule, target);
    // setState(() {
    //   widget.schedules.add(schedule);
    // });
  }

  Future<void> deleteScheduleInListView(Schedule schedule) async {
    await widget.deleteSchedule(schedule);
    setState(() {
      widget.schedules = widget.schedules
          .where((element) => schedule.id != element.id)
          .toList();
    });
  }

  var _format = new DateFormat('yyyy/MM/dd(E)');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_format.format(widget.targetDate)),
        ),
        body: widget.schedules == null || widget.schedules.isEmpty
            ? Center(child: Text('予定はありません'))
            : ListView(
                children: [
                  ...widget.schedules
                      .map((e) => Card(
                              child: ListTile(
                            title: Text(e.title),
                            onTap: () {
                              widget.handleOpenScheduleDetails(e);
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
