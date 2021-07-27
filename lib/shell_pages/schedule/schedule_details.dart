import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'schedule.dart';

class ScheduleDetails extends StatelessWidget {
  ScheduleDetails({
    @required this.schedule,
    @required this.deleteSchedule,
    @required this.handleCloseDetailsPage,
  });
  final Schedule schedule;
  final Future<void> Function(Schedule schedule) deleteSchedule;
  final void Function() handleCloseDetailsPage;
  final _format = DateFormat('HH:mm');
  // new DateFormat('yyyy/MM/dd(E) HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(
                    flex: 1,
                    child: const Text('Title'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(schedule.title),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(
                    flex: 1,
                    child: const Text('Place'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(schedule.place),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(
                    flex: 1,
                    child: const Text('Start Time'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(_format.format(schedule.start)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(
                    flex: 1,
                    child: const Text('End Time'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(_format.format(schedule.end)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(
                    flex: 1,
                    child: const Text('Details'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(schedule.details),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(
                    flex: 1,
                    child: const Text('Public or Private'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(schedule.isPublic ? 'Public' : 'Private'),
                  ),
                ],
              ),
            ),
          ],
        )),
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
                await deleteSchedule(schedule);
                handleCloseDetailsPage();
              },
              child: const Icon(Icons.delete),
              backgroundColor: Colors.red,
            )
          ],
        ));
  }
}
