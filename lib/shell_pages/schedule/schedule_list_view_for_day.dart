import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:intl/intl.dart';
import 'schedule.dart';

class ScheduleListViewForDay extends StatefulWidget {
  ScheduleListViewForDay({
    Key key,
    @required this.targetDate,
    @required this.handleOpenAddPage,
    @required this.handleChangeScheduleDetails,
  }) : super(key: key);
  final DateTime targetDate;
  final void Function(Schedule schedule) handleChangeScheduleDetails;
  final void Function() handleOpenAddPage;
  @override
  _ScheduleListViewForDayState createState() => _ScheduleListViewForDayState();
}

class _ScheduleListViewForDayState extends State<ScheduleListViewForDay> {
  Future<List<Schedule>> _getSchedules(DateTime day) async {
    final data = await dbService.getSchedulesForDay(day, false);
    return data;
  }

  @override
  void initState() {
    super.initState();
  }

  final _appBarFormat = DateFormat('yyyy/MM/dd(E)');
  final _timeFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_appBarFormat.format(widget.targetDate)),
        ),
        body: FutureBuilder(
          future: _getSchedules(widget.targetDate),
          builder:
              (BuildContext context, AsyncSnapshot<List<Schedule>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null || snapshot.data.isEmpty) {
              return Center(
                child: Text('There is no schedules'),
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
                            widget.handleChangeScheduleDetails(e);
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
