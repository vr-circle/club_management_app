import 'package:flutter/material.dart';
import 'package:flutter_application_1/shell_pages/search/organization_info.dart';
import 'package:flutter_application_1/shell_pages/todo/task.dart';
import 'package:flutter_application_1/shell_pages/todo/task_expansion_tile.dart';
import 'package:flutter_application_1/shell_pages/todo/task_group.dart';

class TodoPage extends StatefulWidget {
  TodoPage(
      {Key key,
      @required this.initTodoCollection,
      @required this.participatingOrganizationInfoList,
      @required this.loadTasks,
      @required this.addGroup,
      @required this.deleteGroup,
      @required this.addTask,
      @required this.deleteTask,
      @required this.getTaskGroupList,
      @required this.targetIndexId,
      @required this.handleChangeTab});
  final String targetIndexId;
  final void Function(String value) handleChangeTab;
  final void Function() initTodoCollection;
  final List<OrganizationInfo> participatingOrganizationInfoList;
  final Future<void> Function([String targetOrganizationId]) loadTasks;
  final Future<void> Function(Task newTask, String targetGroupId,
      [String targetOrganizationId]) addTask;
  final Future<void> Function(Task targetTask, String targetGroupId,
      [String targetOrganizationId]) deleteTask;
  final Future<void> Function(String newGroupName,
      [String targetOrganizationId]) addGroup;
  final Future<void> Function(String groupId, [String targetOrganizationId])
      deleteGroup;
  final List<TaskGroup> Function([String id]) getTaskGroupList;
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    print('initState in _TodoPageState');
    int res = 0;
    final x = widget.participatingOrganizationInfoList
      ..sort((a, b) => a.name.compareTo(b.name));
    for (int i = 0; i < x.length; i++) {
      if (x[i].id == widget.targetIndexId) {
        res = i + 1;
        break;
      }
    }
    _tabController = TabController(
        initialIndex: res,
        length: widget.participatingOrganizationInfoList.length + 1,
        vsync: this);
    _tabController.addListener(_handleChangeTab);
    widget.initTodoCollection();
    super.initState();
  }

  void _handleChangeTab() {
    if (_tabController.index == 0) {
      widget.handleChangeTab('');
    } else {
      widget.handleChangeTab((widget.participatingOrganizationInfoList
            ..sort(
                (a, b) => a.name.compareTo(b.name)))[_tabController.index - 1]
          .id);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int res = 0;
    final x = widget.participatingOrganizationInfoList
      ..sort((a, b) => a.name.compareTo(b.name));
    for (int i = 0; i < x.length; i++) {
      if (x[i].id == widget.targetIndexId) {
        res = i + 1;
        break;
      }
    }
    _tabController.index = res;
    return Scaffold(
        appBar: AppBar(
            title: Row(
              children: [
                const FlutterLogo(),
                const Text('CMA'),
              ],
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: 'personal',
                ),
                ...(widget.participatingOrganizationInfoList
                      ..sort((a, b) => a.name.compareTo(b.name)))
                    .map((e) => Tab(
                          text: e.name,
                        ))
                    .toList()
              ],
            )),
        body: TabBarView(controller: _tabController, children: [
          TodoTabBarView(
            key: ValueKey('personalTodo'),
            taskGroupList: widget.getTaskGroupList(),
            addGroup: (String newGroupName) async {
              await widget.addGroup(newGroupName);
            },
            deleteGroup: (String groupId) async {
              await widget.deleteGroup(groupId);
            },
            addTask: (Task newTask, String targetGroupId) async {
              await widget.addTask(newTask, targetGroupId);
            },
            deleteTask: (Task targetTask, String targetGroupId) async {
              await widget.deleteTask(targetTask, targetGroupId);
            },
            loadTasks: () async {
              await widget.loadTasks();
              return true;
            },
          ),
          ...(widget.participatingOrganizationInfoList
                ..sort((a, b) => a.name.compareTo(b.name)))
              .map((e) => TodoTabBarView(
                    key: ValueKey(e.id),
                    taskGroupList: widget.getTaskGroupList(e.id),
                    addGroup: (String newGroupName) async {
                      await widget.addGroup(newGroupName, e.id);
                    },
                    deleteGroup: (String groupId) async {
                      await widget.deleteGroup(groupId, e.id);
                    },
                    addTask: (Task newTask, String targetGroupId) async {
                      await widget.addTask(newTask, targetGroupId, e.id);
                    },
                    deleteTask: (Task targetTask, String targetGroupId) async {
                      await widget.deleteTask(targetTask, targetGroupId, e.id);
                    },
                    loadTasks: () async {
                      await widget.loadTasks(e.id);
                      return true;
                    },
                  ))
              .toList()
        ]));
  }
}

class TodoTabBarView extends StatefulWidget {
  TodoTabBarView(
      {Key key,
      @required this.taskGroupList,
      @required this.loadTasks,
      @required this.addGroup,
      @required this.deleteGroup,
      @required this.addTask,
      @required this.deleteTask});
  final Future<bool> Function() loadTasks;
  final List<TaskGroup> taskGroupList;
  final Future<void> Function(String newGroupName) addGroup;
  final Future<void> Function(String targetGroupId) deleteGroup;
  final Future<void> Function(Task newTask, String targetGroupId) addTask;
  final Future<void> Function(Task newTask, String targetGroupId) deleteTask;
  @override
  _TodoTabBarViewState createState() => _TodoTabBarViewState();
}

class _TodoTabBarViewState extends State<TodoTabBarView> {
  Future<bool> _future;
  @override
  void initState() {
    _future = widget.loadTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          return Scaffold(
            body: ListView(
                children: (widget.taskGroupList
                      ..sort((a, b) => a.name.compareTo(b.name)))
                    .map((e) => TaskExpansionTile(
                        groupName: e.name,
                        taskGroup: e,
                        addTask: (Task newTask) async {
                          await widget.addTask(newTask, e.id);
                        },
                        deleteTask: (Task targetTask) async {
                          await widget.deleteTask(targetTask, e.id);
                        },
                        deleteGroup: () async {
                          await widget.deleteGroup(e.id);
                        }))
                    .toList()),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.library_add),
              onPressed: () async {
                String newName;
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Add group'),
                        content: TextField(
                          onChanged: (value) {
                            newName = value;
                          },
                          decoration:
                              InputDecoration(hintText: 'New group name'),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                await widget.addGroup(newName);
                                Navigator.pop(context);
                              },
                              child: const Text('Add')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                        ],
                      );
                    });
              },
            ),
          );
        });
  }
}
