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
        child: CheckboxListTile(
          title: Text(
            taskTitle,
          ),
          value: isChecked,
          onChanged: checkboxCallback,
        ),
      ),
    );
  }
}

class TodoClubPage extends StatefulWidget {
  TodoClubPage({Key key}) : super(key: key);
  @override
  _TodoClubPageState createState() => _TodoClubPageState();
}

class _TodoClubPageState extends State<TodoClubPage> {
  Future<TaskList> _taskListFuture;
  TaskList _taskList = TaskList([]);

  Future<TaskList> getTaskData() async {
    await Future.delayed(Duration(seconds: 3));
    final List<Task> res = await storeService.getClubTaskList();
    _taskList = TaskList(res);
    return _taskList;
  }

  @override
  void initState() {
    _taskListFuture = getTaskData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _taskListFuture,
          builder: (context, AsyncSnapshot<TaskList> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            return Container(
                child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                final task = _taskList.taskList[index];
                return TaskTile(
                  taskTitle: task.title,
                  isChecked: task.isDone,
                  checkboxCallback: (bool value) {},
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
                                  await storeService.deleteTask(task, false);
                                  setState(() {
                                    _taskList.deleteTask(task);
                                  });
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
              itemCount: _taskList.taskList.length,
            ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ToDoAddPage(false, this._taskList);
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoPrivatePage extends StatefulWidget {
  TodoPrivatePage({Key key}) : super(key: key);
  @override
  _TodoPrivatePageState createState() => _TodoPrivatePageState();
}

class _TodoPrivatePageState extends State<TodoPrivatePage> {
  Future<List<Task>> _taskListFuture;
  List<Task> _taskList = <Task>[];

  Future<List<Task>> getTaskData() async {
    await Future.delayed(Duration(seconds: 3));
    final List<Task> res = await storeService.getPrivateTaskList();
    _taskList = res;
    return res;
  }

  @override
  Widget build(BuildContext context) {
    _taskListFuture = getTaskData();
    return Scaffold(
      body: FutureBuilder(
          future: _taskListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('snapshot error'),
              );
            }
            return Container(
                child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                final task = _taskList[index];
                return TaskTile(
                  taskTitle: task.title,
                  isChecked: task.isDone,
                  checkboxCallback: (bool value) {
                    // context.read(taskListProvider.notifier).toggleDone(task.id);
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
                                  // context
                                  //     .read(taskListProvider.notifier)
                                  //     .deleteTask(task);
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
              itemCount: _taskList.length,
            ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class ToDoAddPage extends StatelessWidget {
  ToDoAddPage(this.isPrivate, this.taskList);
  final TaskList taskList;
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
                      taskList.addTask(_newTaskTitle);
                      storeService.addTask(
                          Task(title: _newTaskTitle), isPrivate);
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
                            taskList.addTask(_newTaskTitle);
                            storeService.addTask(
                                Task(title: _newTaskTitle), isPrivate);
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
