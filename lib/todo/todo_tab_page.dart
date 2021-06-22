import 'package:flutter/material.dart';

import 'task_list.dart';
import 'task_list_panel.dart';
import 'task.dart';
import 'task_tile.dart';
import '../store/store_service.dart';
import 'todo_add.dart';

class TodoTabPage extends StatefulWidget {
  TodoTabPage({Key key, @required this.target}) : super(key: key);
  final String target;
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoTabPage> {
  Future<TaskList> _taskListFuture;
  TaskList _taskList = TaskList([]);
  Future<TaskList> getTaskData() async {
    final List<Task> res = await storeService.getTaskList(widget.target);
    _taskList = TaskList(res);
    return _taskList;
  }

  @override
  void initState() {
    _taskListFuture = getTaskData();
    super.initState();
  }

  Future<void> addTask(Task task) async {
    await storeService.addTask(task, widget.target);
    setState(() {
      _taskList.addTask(task.title);
    });
  }

  Future<void> _deleteTask(Task task) async {
    await storeService.deleteTask(task, widget.target);
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
                child: Text('Delete'),
                onPressed: () async {
                  await _deleteTask(task);
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  ExpansionTile _createExpansionTile(TaskListPanel taskListItem) {
    return ExpansionTile(
        initiallyExpanded: true,
        leading: Icon(Icons.task),
        title: Text(taskListItem.name),
        children: taskListItem.taskList.taskList.length == 0
            ? [
                ListTile(
                  title: Text('There are no tasks'),
                )
              ]
            : taskListItem.taskList.taskList.map((e) {
                return TaskTile(
                  task: e,
                  checkboxCallback: (value) {
                    setState(() {
                      taskListItem.taskList.toggleDone(e.id);
                    });
                  },
                  longPressCallback: () {
                    _showDialog(e);
                  },
                );
              }).toList());
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
            final _isDoneList = TaskList(this
                ._taskList
                .taskList
                .where((element) => element.isDone)
                .toList());
            final _isNotDoneList = TaskList(this
                ._taskList
                .taskList
                .where((element) => !element.isDone)
                .toList());
            return SingleChildScrollView(
                child: Column(
              children: [
                _createExpansionTile(
                    TaskListPanel('Incomplete', _isNotDoneList)),
                _createExpansionTile(TaskListPanel('Completed', _isDoneList)),
              ],
            ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ToDoAddPage(widget.target, this.addTask);
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
