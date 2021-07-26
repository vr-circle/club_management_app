import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/task_expansion_tile.dart';
import 'package:flutter_application_1/shell_pages/todo/task_list.dart';
import 'package:flutter_application_1/store/store_service.dart';

abstract class TodoCollection extends ChangeNotifier {
  TodoCollection() {
    this._taskMap = Map<String, TaskList>();
  }
  List<Widget> getSortedTaskMapWidget() {
    return (_taskMap.keys.toList()..sort((a, b) => a.compareTo(b)))
        .map((e) => TaskExpansionTile(
            groupName: e,
            taskList: _taskMap[e],
            addTask: (Task newTask) async {
              await this.addTask(newTask, e);
            },
            deleteTask: (Task targetTask) async {
              await this.deleteTask(targetTask, e);
            },
            deleteGroup: (String targetGroupName) async {
              await this.deleteGroup(targetGroupName);
            }))
        .toList();
  }

  Map<String, TaskList> _taskMap;

  Future<void> initTasksFromDatabase();

  Future<void> addGroup(String name);
  Future<void> deleteGroup(String groupName);
  Future<void> addTask(Task newTask, String targetGroupName);
  Future<void> deleteTask(Task targetTask, String targetGroupName);
}

class PersonalTodoCollection extends TodoCollection {
  PersonalTodoCollection() : super();

  @override
  Future<void> initTasksFromDatabase() async {
    this._taskMap = await dbService.getTaskList('');
  }

  @override
  Future<void> addGroup(String name) async {
    await dbService.addTaskGroup(name, '');
    this._taskMap[name] = TaskList(<Task>[]);
    notifyListeners();
  }

  @override
  Future<void> deleteGroup(String groupName) async {
    await dbService.deleteTaskGroup(groupName, '');
    this._taskMap.remove(groupName);
    notifyListeners();
  }

  @override
  Future<void> addTask(Task newTask, String targetGroupName) async {
    await dbService.addTask(newTask, targetGroupName, '');
    this._taskMap[targetGroupName].addTask(newTask);
    notifyListeners();
  }

  @override
  Future<void> deleteTask(Task targetTask, String targetGroupName) async {
    await dbService.deleteTask(targetTask, targetGroupName, '');
    this._taskMap[targetGroupName].deleteTask(targetTask);
    notifyListeners();
  }
}

class OrganizationTodoCollection extends TodoCollection {
  OrganizationTodoCollection(this._organizationId) : super();
  String _organizationId;

  @override
  Future<void> initTasksFromDatabase() async {
    this._taskMap = await dbService.getTaskList(_organizationId);
  }

  @override
  Future<void> addGroup(String name) async {
    await dbService.addTaskGroup(name, _organizationId);
    this._taskMap[name] = TaskList(<Task>[]);
    notifyListeners();
  }

  @override
  Future<void> deleteGroup(String groupName) async {
    await dbService.deleteTaskGroup(groupName, _organizationId);
    this._taskMap.remove(groupName);
    notifyListeners();
  }

  @override
  Future<void> addTask(Task newTask, String targetGroupName) async {
    await dbService.addTask(newTask, targetGroupName, _organizationId);
    this._taskMap[targetGroupName].addTask(newTask);
    notifyListeners();
  }

  @override
  Future<void> deleteTask(Task targetTask, String targetGroupName) async {
    await dbService.deleteTask(targetTask, targetGroupName, _organizationId);
    this._taskMap[targetGroupName].deleteTask(targetTask);
    notifyListeners();
  }
}
