import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'schedule.dart';
import 'schedule_edit.dart';

class ScheduleDetails extends StatelessWidget {
  ScheduleDetails({@required this.schedule, @required this.deleteSchedule});
  final Future<void> Function(Schedule schedule) deleteSchedule;
  final Schedule schedule;
  final _format = new DateFormat('yyyy/MM/dd(E) hh:mm');

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
                  leading: Text('Start time'),
                  title: Text(_format.format(schedule.start)),
                ),
                ListTile(
                  leading: Text('End time'),
                  title: Text(_format.format(schedule.end)),
                ),
                ListTile(
                  leading: Text('Place'),
                  title: Text(schedule.place),
                ),
                ListTile(
                  leading: Text('Details'),
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
                  return ScheduleEditPage(targetSchedule: schedule);
                }));
              },
            ),
            SizedBox(
              height: 16,
            ),
            FloatingActionButton(
              onPressed: () async {
                await deleteSchedule(schedule);
                Navigator.pop(context);
              },
              child: Icon(Icons.delete),
              backgroundColor: Colors.red,
            )
          ],
        ));
  }
}
