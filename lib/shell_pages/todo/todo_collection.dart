import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/store/store_service.dart';

class TodoCollection {
  Map<String, List<Task>> taskMap; // {target group name, List<Task>}
  TodoCollection() {
    this.taskMap = Map<String, List<Task>>();
  }

  get groupLength => taskMap.length;

  Future<Map<String, List<Task>>> initTasks(String id) async {
    taskMap = await dbService.getTaskList(id);
    return taskMap;
  }

  List<String> getSortedKey() {
    final keyAsc = taskMap.keys.toList()..sort((a, b) => a.compareTo(b));
    return keyAsc;
  }

  Future<void> addGroup(String name, String id) async {
    if (this.taskMap.containsKey(name)) {
      return;
    }
    await dbService.addTaskGroup(name, id);
    this.taskMap[name] = [];
  }

  Future<void> deleteGroup(String groupName, String organizationId) async {
    await dbService.deleteTaskGroup(groupName, organizationId);
    this.taskMap.remove(groupName);
  }

  Future<void> addTask(
      Task newTask, String targetGroupName, String targetOrganizationId) async {
    await dbService.addTask(newTask, targetGroupName, targetOrganizationId);
    this.taskMap[targetGroupName] = [...this.taskMap[targetGroupName], newTask];
  }

  Future<void> deleteTask(Task targetTask, String targetGroupName,
      String targetOrganizationId) async {
    await dbService.deleteTask(
        targetTask, targetGroupName, targetOrganizationId);
    this.taskMap[targetGroupName] = taskMap[targetGroupName]
        .where((task) => task.id != targetTask.id)
        .toList();
  }
}
