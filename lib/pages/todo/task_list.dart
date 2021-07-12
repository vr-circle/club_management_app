import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/pages/todo/task.dart';
import 'package:flutter_application_1/pages/todo/task_list_tile.dart';

class TaskList {
  List<Task> _taskList;
  TaskList([List<Task> initTaskList]) {
    _taskList = initTaskList;
  }

  List<Widget> getListTiles(void Function(Task task) handleDeleteTask) {
    return this._taskList.map((e) {
      return TaskListTile(task: e, deleteTask: handleDeleteTask);
    }).toList();
  }

  Future<void> addTask(Task task) async {
    this._taskList.add(task);
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> deleteTask(Task target) async {
    this._taskList =
        this._taskList.where((element) => element.id != target.id).toList();
    await Future.delayed(Duration(seconds: 1));
  }
}
