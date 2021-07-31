import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';

class TaskGroup {
  TaskGroup({@required this.id, @required this.name, List<Task> taskList})
      : _taskList = taskList ?? [];
  final String id;
  String name;
  List<Task> _taskList;

  void addTask(Task newTask) {
    _taskList.add(newTask);
  }

  void deleteTask(Task targetTask) {
    _taskList =
        _taskList.where((element) => element.id != targetTask.id).toList();
  }

  List<Task> getSortedTaskList() {
    return _taskList..sort((a, b) => a.title.compareTo(b.title));
  }
}
