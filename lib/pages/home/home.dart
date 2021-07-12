import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/pages/schedule/schedule.dart';
import 'package:flutter_application_1/pages/search/club.dart';
import 'package:flutter_application_1/pages/todo/task.dart';
import 'package:flutter_application_1/route_path.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, @required this.handleChangeSelectedIndex})
      : super(key: key);
  final void Function(int index) handleChangeSelectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        TodoHomeView(
          handleChangeSelectedIndex: handleChangeSelectedIndex,
        ),
        const Divider(
          color: Colors.white,
        ),
        SchedulePartsListView(
          handleChangeSelectedIndex: handleChangeSelectedIndex,
        ),
        // Divider(
        //   color: Colors.white,
        // ),
        // ClubPartsListView(
        //   appState: appState,
        // ),
      ],
    ));
  }
}

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

class TodoHomeView extends StatelessWidget {
  TodoHomeView({Key key, this.handleChangeSelectedIndex}) : super(key: key);
  final void Function(int index) handleChangeSelectedIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          title: Text('Todo List'),
        ),
        TodoPartsListView(),
        TextButton(
            onPressed: () {
              handleChangeSelectedIndex(TodoPath.index);
            },
            child: const Text('More')),
      ],
    );
  }
}

class TodoPartsListView extends StatefulWidget {
  TodoPartsListView({Key key, this.handleChangeSelectedIndex})
      : super(key: key);
  final void Function(int index) handleChangeSelectedIndex;
  TodoPartsListViewState createState() => TodoPartsListViewState();
}

class TodoPartsListViewState extends State<TodoPartsListView> {
  Future<List<Task>> futureTmp;
  List<Task> taskList = [];
  Future<List<Task>> getTaskList() async {
    final Map<String, List<Task>> data = await dbService.getTaskList('private');
    final res = [];
    data.forEach((key, value) {
      res.addAll(value);
    });
    taskList = res;
    return taskList;
  }

  @override
  void initState() {
    taskList = [];
    futureTmp = getTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureTmp,
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
          }
          print(taskList);
          return ListView.builder(
              shrinkWrap: true,
              itemCount: min(taskList.length, 3),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    child: ListTile(
                  title: Text(taskList[index].title),
                ));
              });
        });
  }
}

class ClubPartsListView extends StatelessWidget {
  ClubPartsListView({Key key, @required this.appState}) : super(key: key);
  final MyAppState appState;
  Future<List<ClubInfo>> getClubInfoList() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      ClubInfo(
          id: 0.toString(),
          name: 'Hitech',
          memberNum: 10,
          categoryList: ['circle'],
          introduction: 'hogehoge',
          otherInfo: [
            {'hogehoeg': 'hogehoe'}
          ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const ListTile(
        title: Text('Club list'),
      ),
      FutureBuilder(
          future: getClubInfoList(),
          builder:
              (BuildContext context, AsyncSnapshot<List<ClubInfo>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Expanded(
                child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: min(snapshot.data.length, 5),
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                                width: 200,
                                child: GestureDetector(
                                  onTap: () {
                                    appState.selectedIndex =
                                        SearchViewPath.index;
                                    appState.selectedSearchingClubId =
                                        snapshot.data[index].id.toString();
                                  },
                                  child: Card(
                                      child: Text(snapshot.data[index].name)),
                                ));
                          }),
                    ),
                  ]),
            ));
          })
    ]);
  }
}
