import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/store/store_service.dart';

class ScheduleHomeView extends StatelessWidget {
  ScheduleHomeView({Key key, @required this.appState}) : super(key: key);
  final AppState appState;
  Future<List<Schedule>> _getScheduleList() async {
    return await dbService.getSchedulesOnDay(DateTime.now(),
        [...await dbService.getParticipatingOrganizationIdList()]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          title: const Text('Schedule in today'),
        ),
        FutureBuilder(
            future: _getScheduleList(),
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
      ],
    );
  }
}
