import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/shell_pages/schedule/schedule.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, @required this.appState}) : super(key: key);
  final AppState appState;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Schedule> _scheduleListInToday;
  Future<bool> _future;

  Future<bool> _getHomeState() async {
    await _getScheduleForToday();
    return true;
  }

  Future<List<Schedule>> _getScheduleForToday() async {
    this._scheduleListInToday =
        await dbService.getSchedulesForDay(DateTime.now(), false);
    return this._scheduleListInToday;
  }

  @override
  void initState() {
    _future = _getHomeState();
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
          ),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: IconButton(
                  onPressed: () {
                    widget.appState.bottomNavigationIndex = SettingPath.index;
                  },
                  icon: const Icon(Icons.person)),
            )
          ],
        ),
        body: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            }
            return Column(children: [
              const ListTile(
                title: const Text('Schedule in today'),
              ),
              if (_scheduleListInToday.length == 0)
                const ListTile(
                  title: const Text('No schedule'),
                ),
              ..._scheduleListInToday
                  .map((e) => Card(
                          child: ListTile(
                        title: Text(e.title),
                        trailing: Text(
                            '${DateFormat('HH:mm').format(e.start)} ~ ${DateFormat('HH:mm').format(e.end)}'),
                      )))
                  .toList()
            ]);
          },
        ));
  }
}
