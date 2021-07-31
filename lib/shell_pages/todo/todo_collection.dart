import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/task_group.dart';
import 'package:flutter_application_1/shell_pages/todo/todo_tab_info.dart';
import 'package:flutter_application_1/store/store_service.dart';

class TodoCollection {
  TodoCollection()
      : _todoCollection = {},
        _loadTable = {};
  Map<String, TodoTabInfo> _todoCollection; // <organizationId, (TabInfo)>
  Map<String, bool> _loadTable; // <organizationId, bool>

  void initCollection(
      List<OrganizationInfo> participatingOrganizationInfoList) {
    print('start initCollection in TodoCollection');
    _todoCollection[''] = TodoTabInfo(id: '', name: 'personal');
    participatingOrganizationInfoList.forEach((element) {
      _todoCollection[element.id] =
          TodoTabInfo(id: element.id, name: element.name);
    });
    print('end initCollection in TodoCollection');
  }

  Future<void> loadTask([String organizationId]) async {
    if (_loadTable.containsKey(organizationId ?? '')) {
      return;
    }
    _loadTable[organizationId ?? ''] = true;
    await _todoCollection[organizationId ?? ''].loadTasks(organizationId);
  }

  List<TaskGroup> getTaskGroupList([String targetOrganizationId]) {
    return _todoCollection[targetOrganizationId ?? ''].getSortedTaskGroupList();
  }

  Future<void> addTask(Task newTask, String targetGroupId,
      [String targetOrganizationId]) async {
    _todoCollection[targetOrganizationId ?? ''].addTask(newTask, targetGroupId);
    await dbService.addTask(newTask, targetGroupId, targetOrganizationId);
  }

  Future<void> deleteTask(Task targetTask, String targetGroupId,
      [String targetOrganizationId]) async {
    _todoCollection[targetOrganizationId ?? '']
        .deleteTask(targetTask, targetGroupId);
    await dbService.addTask(targetTask, targetGroupId, targetOrganizationId);
  }

  Future<void> addGroup(String newGroupName,
      [String targetOrganizationId]) async {
    final TaskGroup newGroup =
        await dbService.addTaskGroup(newGroupName, targetOrganizationId);
    _todoCollection[targetOrganizationId ?? ''].addGroup(newGroup);
  }

  Future<void> deleteGroup(String targetGroupId,
      [String targetOrganizationId]) async {
    await dbService.deleteTaskGroup(targetGroupId, targetOrganizationId);
    _todoCollection[targetOrganizationId ?? ''].deleteGroup(targetGroupId);
  }
}
