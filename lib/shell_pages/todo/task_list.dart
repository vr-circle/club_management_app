import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';

class TaskList {
  List<Task> _taskList;
  TaskList(List<Task> initTaskList) {
    _taskList = initTaskList;
  }

  List<Widget> getTaskTileList(
      Future<void> Function(Task targetTask) deleteTask) {
    return _taskList
        .map((e) => Card(
            child: ListTile(
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await deleteTask(e);
                  },
                ),
                onLongPress: () async {},
                title: Text(e.title))))
        .toList();
  }

  int get length => _taskList.length;

  void addTask(Task task) {
    this._taskList.add(task);
  }

  void deleteTask(Task target) {
    this._taskList =
        this._taskList.where((element) => element.id != target.id).toList();
  }
}
