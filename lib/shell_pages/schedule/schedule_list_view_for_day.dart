import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'schedule.dart';

class ScheduleListViewForDay extends StatefulWidget {
  ScheduleListViewForDay({
    Key key,
    @required this.targetDate,
    @required this.scheduleList,
    @required this.handleOpenAddPage,
    @required this.handleChangeScheduleDetails,
  }) : super(key: key);
  final DateTime targetDate;
  final List<Schedule> scheduleList;
  final void Function(Schedule schedule) handleChangeScheduleDetails;
  final void Function() handleOpenAddPage;
  @override
  _ScheduleListViewForDayState createState() => _ScheduleListViewForDayState();
}

class _ScheduleListViewForDayState extends State<ScheduleListViewForDay> {
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
        body: widget.scheduleList.isEmpty
            ? Center(
                child: Text('No schedules'),
              )
            : ListView(
                children: widget.scheduleList
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
              ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            widget.handleOpenAddPage();
          },
        ));
  }
}
