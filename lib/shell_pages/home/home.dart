import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
    @required this.getScheduleForDay,
  }) : super(key: key);
  final Future<List<Schedule>> Function() getScheduleForDay;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Schedule>> _futureSchedule;
  @override
  void initState() {
    _futureSchedule = widget.getScheduleForDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            const FlutterLogo(),
            const Text('CMA'),
          ],
        )),
        body: FutureBuilder(
          future: _futureSchedule,
          builder:
              (BuildContext context, AsyncSnapshot<List<Schedule>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: const CircularProgressIndicator());
            }
            return Column(
              children: [
                const ListTile(
                  title: Text('Your plans for today'),
                ),
                if (snapshot.data.isEmpty)
                  const ListTile(
                    title: Text('No plans'),
                  )
                else
                  ...snapshot.data
                      .map((e) => Card(
                              child: ListTile(
                            title: Text(e.title),
                            trailing: Text(
                                '${DateFormat('HH:mm').format(e.start)} ~ ${DateFormat('HH:mm').format(e.end)}'),
                          )))
                      .toList()
              ],
            );
          },
        ));
  }
}
