import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:intl/intl.dart';
import 'schedule.dart';

class ScheduleListOnDay extends StatefulWidget {
  ScheduleListOnDay({
    Key key,
    @required this.targetDate,
    @required this.handleOpenAddPage,
    @required this.handleOpenScheduleDetails,
  }) : super(key: key);
  final DateTime targetDate;
  final void Function(Schedule schedule) handleOpenScheduleDetails;
  final void Function() handleOpenAddPage;
  @override
  _ScheduleListOnDayState createState() => _ScheduleListOnDayState();
}

class _ScheduleListOnDayState extends State<ScheduleListOnDay> {
  Future<List<Schedule>> getSchedules(DateTime day) async {
    final data = await dbService.getSchedulesOnDay(day, ['']);
    return data;
  }

  @override
  void initState() {
    super.initState();
  }

  final _appBarFormat = new DateFormat('yyyy/MM/dd(E)');
  final _timeFormat = new DateFormat('HH:mm');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_appBarFormat.format(widget.targetDate)),
        ),
        body: FutureBuilder(
          future: getSchedules(widget.targetDate),
          builder:
              (BuildContext context, AsyncSnapshot<List<Schedule>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data
                  .map((e) => Card(
                        child: ListTile(
                          title: Text(e.title),
                          subtitle: Text(
                              '${_timeFormat.format(e.start)} ~ ${_timeFormat.format(e.end)}'),
                          onTap: () {
                            widget.handleOpenScheduleDetails(e);
                          },
                        ),
                      ))
                  .toList(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            widget.handleOpenAddPage();
          },
        ));
  }
}
