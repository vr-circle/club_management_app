import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
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

  Future<void> initTabInfo(List<OrganizationInfo> organizationInfoList) async {
    _tabInfoList = [];
    final personalTodoCollection = PersonalTodoCollection();
    personalTodoCollection.initTasksFromDatabase();
    _tabInfoList.add(TabInfo(
        id: '', name: 'personal', todoCollection: personalTodoCollection));
    await Future.forEach(organizationInfoList, (info) async {
      final todoCollection = OrganizationTodoCollection(info.id);
      await todoCollection.initTasksFromDatabase();
      _tabInfoList.add(TabInfo(
          id: info.id, name: info.name, todoCollection: todoCollection));
    });
    notifyListeners();
  }

  int getTabIndex(String targetId) {
    for (int i = 0; i < _tabInfoList.length; i++) {
      if (_tabInfoList[i].id == targetId) {
        return i;
      }
    }
    return 0;
  }

  void handleChangeTabIndex(AppState appState, int index) {
    appState.targetTodoTabId = _tabInfoList[index].id;
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
