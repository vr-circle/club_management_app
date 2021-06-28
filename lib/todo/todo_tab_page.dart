import 'package:flutter/material.dart';

import 'task_list.dart';
import 'task_list_panel.dart';
import 'task.dart';
import 'task_tile.dart';
import '../store/store_service.dart';
import 'todo_add.dart';

class TodoTabPage extends StatefulWidget {
  TodoTabPage(
      {Key key,
      @required this.tasks,
      @required this.addTask,
      @required this.deleteTask})
      : super(key: key);
  final TaskList tasks;
  final Future<void> Function(Task task, String target) addTask;
  final Future<void> Function(Task task, String target) deleteTask;
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoTabPage> {
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
                  await widget.deleteTask(task);
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
    final _isDoneList = TaskList(
        widget.tasks.taskList.where((element) => element.isDone).toList());
    final _isNotDoneList = TaskList(
        widget.tasks.taskList.where((element) => !element.isDone).toList());
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          _createExpansionTile(TaskListPanel('Incomplete', _isNotDoneList)),
          _createExpansionTile(TaskListPanel('Completed', _isDoneList)),
        ],
      )),
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
