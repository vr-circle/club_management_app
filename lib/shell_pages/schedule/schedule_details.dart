import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'schedule.dart';

class ScheduleDetails extends StatelessWidget {
  ScheduleDetails({
    @required this.schedule,
    @required this.deleteSchedule,
    @required this.handleCloseDetailsPage,
  });
  final Future<void> Function(Schedule schedule) deleteSchedule;
  final void Function() handleCloseDetailsPage;
  final Schedule schedule;
  final _format = new DateFormat('yyyy/MM/dd(E) HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Title'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                  child: Text(
                    schedule.title,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text('Start time'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                  child: Text(_format.format(schedule.start)),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text('End time'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                  child: Text(_format.format(schedule.end)),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text('Place'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                  child: Text(schedule.place),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text('Details'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                  child: Text(schedule.details),
                )
              ],
            ),
          )),
        ]),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              child: const Icon(Icons.edit),
              onPressed: () {
                // edit schedule
                // todo : create EditSchedulePath
              },
            ),
            const SizedBox(
              height: 16,
            ),
            FloatingActionButton(
              onPressed: () async {
                // await deleteSchedule(schedule);
                // handleCloseDetailsPage();
              },
              child: const Icon(Icons.delete),
              backgroundColor: Colors.red,
            )
          ],
        ));
  }
}
