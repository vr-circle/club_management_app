import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/store_service.dart';
import 'package:flutter_application_1/todo/task.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'task_list.dart';

class TodoPage extends HookWidget {
  static const String route = '/todo';
  @override
  Widget build(BuildContext context) {
    return BuildDefaultTabController();
  }
}

class BuildDefaultTabController extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _tabInfo = <String>['private', 'club'];
    return DefaultTabController(
        length: _tabInfo.length,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TabBar(
                    isScrollable: true,
                    tabs: _tabInfo
                        .map((e) => Tab(
                              text: e,
                            ))
                        .toList())
              ],
            ),
            elevation: 0,
          ),
          body: TabBarView(children: [
            TodoPrivatePage(),
            TodoClubPage(),
          ]),
        ));
  }
}

class TaskTile extends HookWidget {
  const TaskTile(
      {this.isChecked,
      this.taskTitle,
      this.checkboxCallback,
      this.longPressCallback});

  final bool isChecked;
  final String taskTitle;
  final Function(bool) checkboxCallback;
  final Function() longPressCallback;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: GestureDetector(
        onLongPress: longPressCallback,
        child: ListTile(
          title: Text(
            taskTitle,
          ),
          // value: isChecked,
          // onChanged: checkboxCallback,
        ),
      ),
    );
  }
}

class TabPage extends HookWidget {
  const TabPage({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('$title')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TodoClubPage()));
        },
      ),
    );
  }
}

class TodoClubPage extends HookWidget {
  TodoClubPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final taskList = useProvider(clubTaskListProvider);
    final taskListState = useProvider(clubTaskListProvider.notifier);
    return Scaffold(
      body: FutureBuilder(
          future: storeService.getClubTaskList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print('snapshot is done');
              // taskListState.addTaskList(snapshot.data);
              print('a1');
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  print('a2');
                  final task = taskList[index];
                  return TaskTile(
                    taskTitle: task.title,
                    isChecked: task.isDone,
                    checkboxCallback: (bool value) {
                      context
                          .read(clubTaskListProvider.notifier)
                          .toggleDone(task.id);
                    },
                    longPressCallback: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: Text(task.title),
                              children: [
                                SimpleDialogOption(
                                  child: Text('削除'),
                                  onPressed: () async {
                                    // delete task by id
                                    await storeService.deleteTask(task, true);
                                    context
                                        .read(clubTaskListProvider.notifier)
                                        .deleteTask(task);
                                    Navigator.pop(context);
                                  },
                                ),
                                SimpleDialogOption(
                                  child: Text('キャンセル'),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            );
                          });
                    },
                  );
                },
                itemCount: taskList.length,
              );
            } else {
              print('loading..');
              return Center(child: Text('loading...'));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoPrivatePage extends HookWidget {
  TodoPrivatePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final taskList = useProvider(taskListProvider);
    final taskListState = useProvider(taskListProvider.notifier);

    return Scaffold(
      body: FutureBuilder(
          future: storeService.getPrivateTaskList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print('snapshot is done');
              print('a_1');
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  // taskListState.addTaskList(snapshot.data);
                  print('a_2');
                  final task = taskList[index];
                  print('a_3');
                  return TaskTile(
                    taskTitle: task.title,
                    isChecked: task.isDone,
                    checkboxCallback: (bool value) {
                      context
                          .read(taskListProvider.notifier)
                          .toggleDone(task.id);
                    },
                    longPressCallback: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: Text(task.title),
                              children: [
                                SimpleDialogOption(
                                  child: Text('削除'),
                                  onPressed: () async {
                                    // delete task by id
                                    await storeService.deleteTask(task, true);
                                    context
                                        .read(taskListProvider.notifier)
                                        .deleteTask(task);
                                    Navigator.pop(context);
                                  },
                                ),
                                SimpleDialogOption(
                                  child: Text('キャンセル'),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            );
                          });
                    },
                  );
                },
                itemCount: taskList.length,
              );
            } else {
              print('a_4');
              return Center(child: Text('loading...'));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class ToDoAddPage extends StatelessWidget {
  ToDoAddPage(this.isPrivate);
  final bool isPrivate;
  @override
  Widget build(BuildContext context) {
    String _newTaskTitle = '';
    final _textEditingController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text('タスクの追加'),
        ),
        body: Container(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Consumer(builder: (context, watch, child) {
                  return TextField(
                    controller: _textEditingController,
                    onChanged: (newText) {
                      _newTaskTitle = newText;
                    },
                    onSubmitted: (newText) async {
                      if (_newTaskTitle.isEmpty) {
                        return;
                      }
                      if (isPrivate) {
                        watch(taskListProvider.notifier).addTask(_newTaskTitle);
                        storeService.addTask(Task(title: newText), isPrivate);
                      } else {
                        watch(clubTaskListProvider.notifier)
                            .addTask(_newTaskTitle);
                        storeService.addTask(Task(title: newText), isPrivate);
                      }
                      Navigator.of(context).pop();
                    },
                  );
                }),
                const SizedBox(
                  height: 8,
                ),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Consumer(builder: (context, watch, child) {
                      return TextButton(
                          onPressed: () {
                            if (_newTaskTitle.isEmpty) {
                              return;
                            }
                            if (isPrivate) {
                              watch(taskListProvider.notifier)
                                  .addTask(_newTaskTitle);
                            } else {
                              watch(clubTaskListProvider.notifier)
                                  .addTask(_newTaskTitle);
                            }
                          },
                          child: Text('Add'));
                    }),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'キャンセル',
                          style: TextStyle(color: Colors.red),
                        )),
                  ],
                )),
              ]),
            )));
  }
}
