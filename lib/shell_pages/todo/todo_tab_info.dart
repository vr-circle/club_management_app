import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/task_group.dart';
import 'package:flutter_application_1/store/store_service.dart';

class TodoTabInfo {
  TodoTabInfo(
      {@required this.id, @required this.name, List<TaskGroup> taskGroupList})
      : this.taskGroupList = taskGroupList ?? [];
  final String id;
  final String name;
  List<TaskGroup> taskGroupList;

  Future<void> loadTasks([String organizationId]) async {
    this.taskGroupList = await dbService.loadTaskList(organizationId);
  }

  Future<void> addTask(Task newTask, String targetGroupId) async {
    final targetGroup = this
        .taskGroupList
        .where((group) => group.id == targetGroupId)
        .toList()
        .first;
    targetGroup.addTask(newTask);
  }

  Future<void> deleteTask(Task targetTask, String targetGroupId) async {
    final targetGroup = this
        .taskGroupList
        .where((element) => element.id == targetGroupId)
        .toList()
        .first;
    targetGroup.deleteTask(targetTask);
  }

  void addGroup(TaskGroup newGroup) {
    this.taskGroupList.add(newGroup);
  }

  void deleteGroup(String targetGroupId) {
    this.taskGroupList = this
        .taskGroupList
        .where((element) => element.id != targetGroupId)
        .toList();
  }

  List<TaskGroup> getSortedTaskGroupList() {
    return this.taskGroupList..sort((a, b) => a.name.compareTo(b.name));
  }
}
