import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/schedule/schedule.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/store/store_service.dart';

class SchedulePartsListView extends StatelessWidget {
  SchedulePartsListView({Key key, @required this.handleChangeSelectedIndex})
      : super(key: key);
  final void Function(int index) handleChangeSelectedIndex;
  Future<List<Schedule>> getScheduleList() async {
    return await dbService.getSchedulesOnDay(DateTime.now(), ['']);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          title: Text('Schedule in today'),
        ),
        FutureBuilder(
            future: getScheduleList(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Schedule>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data == null) {
                return const ListTile(
                  title: const Text('No data'),
                );
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: min(snapshot.data.length, 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                      title: Text(snapshot.data[index].title),
                    ));
                  });
            }),
        TextButton(
            onPressed: () {
              handleChangeSelectedIndex(SchedulePath.index);
            },
            child: const Text('More')),
      ],
    );
  }
}
