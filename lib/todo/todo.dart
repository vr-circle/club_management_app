import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/store_service.dart';
import 'package:flutter_application_1/todo/task.dart';

import 'task_list.dart';
import 'todo_add.dart';
import 'task_tile.dart';

class TodoPage extends StatelessWidget {
  static const String route = '/todo';
  @override
  Widget build(BuildContext context) {
    return BuildDefaultTabController();
  }
}

class BuildDefaultTabController extends StatelessWidget {
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

class TodoClubPage extends StatefulWidget {
  TodoClubPage({Key key}) : super(key: key);
  @override
  _TodoClubPageState createState() => _TodoClubPageState();
}

class _TodoClubPageState extends State<TodoClubPage> {
  Future<TaskList> _taskListFuture;
  TaskList _taskList = TaskList([]);

  Future<TaskList> getTaskData() async {
    final List<Task> res = await storeService.getClubTaskList();
    _taskList = TaskList(res);
    return _taskList;
  }

  @override
  void initState() {
    _taskListFuture = getTaskData();
    super.initState();
  }

  void addTask(String title) {
    setState(() {
      _taskList.addTask(title);
    });
  }

  void deleteTask(Task task) {
    setState(() {
      _taskList.deleteTask(task);
    });
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
                                  deleteTask(task);
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
            return ToDoAddPage(false, addTask);
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
  Future<TaskList> _taskListFuture;
  TaskList _taskList = TaskList([]);

  Future<TaskList> getTaskData() async {
    final List<Task> res = await storeService.getPrivateTaskList();
    _taskList = TaskList(res);
    return _taskList;
  }

  @override
  void initState() {
    _taskListFuture = getTaskData();
    super.initState();
  }

  void addTask(String title) {
    setState(() {
      _taskList.addTask(title);
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _taskList.deleteTask(task);
    });
  }

  void _showDialog(Task task) {
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
                  _deleteTask(task);
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
  }

  ExpansionPanel _createPanel(TaskListItem taskListItem) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Container(
            child: Row(
          children: [
            Padding(
                padding: EdgeInsets.only(right: 10.0), child: Icon(Icons.task)),
            Text(
              taskListItem.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        ));
      },
      body:
          // TaskTile(
          //   taskTitle: 'aaa',
          //   isChecked: false,
          //   longPressCallback: () {},
          //   checkboxCallback: (bool value) {},
          // ),
          ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final task = taskListItem.taskList.taskList[index];
          return TaskTile(
            taskTitle: task.title,
            isChecked: task.isDone,
            checkboxCallback: (bool value) {
              taskListItem.taskList.toggleDone(task.id);
            },
            longPressCallback: () {
              _showDialog(task);
            },
          );
        },
        itemCount: taskListItem.taskList.taskList.length,
      ),
      isExpanded: taskListItem.isExpanded,
    );
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
            TaskList isNotDoneList = TaskList(_taskList.taskList
                .where((element) => element.isDone == false)
                .toList());
            print(isNotDoneList.taskList);
            TaskList isDoneList = TaskList(
                _taskList.taskList.where((element) => element.isDone).toList());
            print(isDoneList.taskList);
            return Container(
                padding: EdgeInsets.all(8),
                child: ListView(
                  children: [
                    ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {});
                      },
                      children: [],
                    )
                  ],
                )
                //   child: ListView.builder(
                // itemBuilder: (BuildContext context, int index) {
                //   final task = _taskList.taskList[index];
                //   return TaskTile(
                //     taskTitle: task.title,
                //     isChecked: task.isDone,
                //     checkboxCallback: (bool value) {},
                //     longPressCallback: () {
                //       _showDialog(task);
                //     },
                //   );
                // },
                // itemCount: _taskList.taskList.length,
                );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ToDoAddPage(true, addTask);
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TaskListItem {
  bool isExpanded;
  String name;
  TaskList taskList;
  TaskListItem(this.isExpanded, this.name, this.taskList);
}
