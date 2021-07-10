import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/todo/task.dart';

// handle delete, add and toggle
// todo : add task in specific group

class TaskList {
  List<Task> taskList;
  TaskList([List<Task> initTaskList]) {
    taskList = initTaskList;
  }

  Future<void> addTask(Task task) async {
    taskList.add(task);
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> deleteTask(Task target) async {
    taskList =
        this.taskList.where((element) => element.id != target.id).toList();
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> toggleDone(Task target) async {
    target.toggleDone();
    await Future.delayed(Duration(seconds: 1));
  }
}

class TaskListTile extends StatelessWidget {
  TaskListTile({
    Key key,
    @required this.task,
    @required this.deleteTask,
    @required this.addTask,
    @required this.toggleDone,
  }) : super(key: key);
  final Task task;
  final Future<void> Function() deleteTask;
  final Future<void> Function() addTask;
  final Future<void> Function() toggleDone;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () {
        toggleDone();
      },
      onLongPress: () {},
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await deleteTask();
        },
      ),
      title: Text(this.task.title),
    ));
  }
}
