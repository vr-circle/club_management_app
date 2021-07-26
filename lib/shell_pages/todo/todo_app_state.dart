import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/todo_collection.dart';
import 'package:flutter_application_1/store/store_service.dart';

class TabInfo {
  TabInfo(
      {@required this.id, @required this.name, @required this.todoCollection});
  final String id;
  final String name;
  TodoCollection todoCollection;
}

class TodoAppState extends ChangeNotifier {
  TodoAppState();
  List<TabInfo> _tabInfoList;

  int get tabLength => _tabInfoList.length;

  Future<void> initTabInfo() async {
    _tabInfoList = [];
    final personalTodoCollection = PersonalTodoCollection();
    personalTodoCollection.initTasksFromDatabase();
    _tabInfoList.add(TabInfo(
        id: '', name: 'personal', todoCollection: personalTodoCollection));
    List<String> idList = await dbService.getParticipatingOrganizationIdList();
    await Future.forEach(idList, (id) async {
      final name = (await dbService.getOrganizationInfo(id)).name;
      final todoCollection = OrganizationTodoCollection(id);
      todoCollection.initTasksFromDatabase();
      _tabInfoList
          .add(TabInfo(id: id, name: name, todoCollection: todoCollection));
    });
    notifyListeners();
  }

  List<Tab> getTabList() {
    return _tabInfoList
        .map((e) => Tab(
              text: e.name,
            ))
        .toList();
  }

  List<TodoCollection> getTodoCollectionList() {
    return _tabInfoList.map((e) => e.todoCollection).toList();
  }

  Future<void> addTask(
      Task task, String targetGroupName, String targetOrganizationId) async {
    await dbService.addTask(task, targetGroupName, targetOrganizationId);
    notifyListeners();
  }

  Future<void> deleteTask(task, targetGroupName, targetOrganizationId) async {
    await dbService.deleteTask(task, targetGroupName, targetOrganizationId);
    notifyListeners();
  }

  Future<void> addGroup(groupName, targetOrganizationId) async {
    await dbService.addTaskGroup(groupName, targetOrganizationId);
    notifyListeners();
  }

  Future<void> deleteGroup(groupName, targetOrganizationId) async {
    await dbService.deleteTaskGroup(groupName, targetOrganizationId);
    notifyListeners();
  }
}
