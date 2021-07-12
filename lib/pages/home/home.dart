import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/pages/schedule/schedule.dart';
import 'package:flutter_application_1/pages/search/club.dart';
import 'package:flutter_application_1/pages/todo/task.dart';
import 'package:flutter_application_1/route_path.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, @required this.appState}) : super(key: key);
  final MyAppState appState;
  static const String route = '/homepage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        TodoPartsListView(
          appState: appState,
        ),
        const Divider(
          color: Colors.white,
        ),
        SchedulePartsListView(
          appState: appState,
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
  SchedulePartsListView({Key key, @required this.appState}) : super(key: key);
  final MyAppState appState;
  Future<List<Schedule>> getScheduleList() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      Schedule(
        title: 'hogehoe',
        details: 'details',
        start: DateTime.now(),
        end: DateTime.now(),
        place: 'place01',
        createdBy: 'hogehoge',
      ),
      Schedule(
        title: 'hogehoe',
        details: 'details',
        start: DateTime.now(),
        end: DateTime.now(),
        place: 'place01',
        createdBy: 'hogehoge',
      ),
    ];
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
              appState.selectedIndex = SchedulePath.index;
            },
            child: Text('More')),
      ],
    );
  }
}

class TodoPartsListView extends StatelessWidget {
  TodoPartsListView({Key key, @required this.appState}) : super(key: key);
  final MyAppState appState;
  Future<List<Task>> getTaskList() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      Task(title: 'hogehoe'),
      Task(title: 'hogehoe'),
      Task(title: 'hogehoe'),
      Task(title: 'hogehoe'),
      Task(title: 'hogehoe'),
      Task(title: 'hogehoe'),
      Task(title: 'hogehoe'),
      Task(title: 'hogehoe'),
      Task(title: 'hogehoe'),
      Task(title: 'hogehoe'),
      Task(title: 'hogehoe'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          title: Text('Todo list'),
        ),
        FutureBuilder(
            future: getTaskList(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
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
              appState.selectedIndex = TodoPath.index;
            },
            child: Text('More')),
      ],
    );
  }
}

class ClubPartsListView extends StatelessWidget {
  ClubPartsListView({Key key, @required this.appState}) : super(key: key);
  final MyAppState appState;
  Future<List<ClubInfo>> getClubInfoList() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      ClubInfo(
          id: 0,
          name: 'Hitech',
          memberNum: 10,
          categoryList: ['circle'],
          introduction: 'hogehoge',
          otherInfo: [
            {'hogehoeg': 'hogehoe'}
          ]),
      ClubInfo(
          id: 1,
          name: 'Hitech',
          memberNum: 10,
          categoryList: ['circle'],
          introduction: 'hogehoge',
          otherInfo: [
            {'hogehoeg': 'hogehoe'}
          ]),
      ClubInfo(
          id: 2,
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
