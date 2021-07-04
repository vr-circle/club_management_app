import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/schedule/schedule.dart';

final scheduleListToday = <Schedule>[
  Schedule(
      createdBy: '',
      details: 'hogehoge',
      end: DateTime.now(),
      start: DateTime.now(),
      place: 'hogehogeplace',
      title: 'fugafugatitle'),
  Schedule(
      createdBy: '',
      details: 'hogehoge',
      end: DateTime.now(),
      start: DateTime.now(),
      place: 'hogehogeplace',
      title: 'fugafugatitle'),
  Schedule(
      createdBy: '',
      details: 'hogehoge',
      end: DateTime.now(),
      start: DateTime.now(),
      place: 'hogehogeplace',
      title: 'fugafugatitle'),
  Schedule(
      createdBy: '',
      details: 'hogehoge',
      end: DateTime.now(),
      start: DateTime.now(),
      place: 'hogehogeplace',
      title: 'fugafugatitle'),
];

class HomePage extends StatelessWidget {
  static const String route = '/homepage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            title: Text('Schedule in today'),
          ),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: scheduleListToday.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Text(scheduleListToday[index].title),
                        trailing: Text(scheduleListToday[index].details));
                  }))
        ],
      ),
    );
  }
}
