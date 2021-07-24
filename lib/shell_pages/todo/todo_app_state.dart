import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/todo/todo_collection.dart';
import 'package:flutter_application_1/store/store_service.dart';

class TabInfo {
  TabInfo({@required this.id, @required this.name});
  final String id;
  final String name;
  TodoCollection todoCollection;
}

class TodoAppState extends ChangeNotifier {
  TodoAppState();
  List<TabInfo> tabInfoList;

  Future<void> initTabInfo() async {
    List<String> idList = await dbService.getParticipatingOrganizationIdList();
    List<OrganizationInfo> infoList = [];
    await Future.forEach(idList, (id) async {
      infoList.add(await dbService.getOrganizationInfo(id));
    });
    notifyListeners();
  }

  List<Tab> getTabList() {}

  Future<void> addTask(task, targetGroupName, targetOrganizationId) async {
    await dbService.addTask(task, targetGroupName, targetOrganizationId);
  }

  Future<void> deleteGroup(groupName, targetOrganizationId) async {
    await dbService.deleteTaskGroup(groupName, targetOrganizationId);
  }

  Future<void> deleteTask(task, targetGroupName, targetOrganizationId) async {
    await dbService.deleteTask(task, targetGroupName, targetOrganizationId);
  }
}
